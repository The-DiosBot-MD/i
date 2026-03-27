#!/bin/bash

# Script de instalación de Ctrlpanel
# Colores para mejor visualización
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para mostrar mensajes
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Función para verificar si el comando anterior fue exitoso
check_error() {
    if [ $? -ne 0 ]; then
        print_error "Error al ejecutar: $1"
        exit 1
    fi
}

# Función especial para apt update (ignora errores)
run_apt_update() {
    print_message "Ejecutando apt update (los errores serán ignorados)..."
    apt update -y
    if [ $? -ne 0 ]; then
        print_warning "apt update tuvo errores pero continuamos con la instalación"
    else
        print_message "apt update completado exitosamente"
    fi
}

# Banner de bienvenida
clear
echo "================================================"
echo "      Script de Instalación de Ctrlpanel       "
echo "================================================"
echo ""

# Solicitar dominio
while true; do
    echo -n "Ingresa tu dominio (Ej: ejemplo.com): "
    read DOMINIO
    
    if [ -z "$DOMINIO" ]; then
        print_error "El dominio no puede estar vacío"
        continue
    fi
    
    echo ""
    echo "Dominio ingresado: $DOMINIO"
    echo -n "¿Es correcto? (s/n): "
    read CONFIRMAR
    
    if [[ "$CONFIRMAR" == "s" || "$CONFIRMAR" == "S" ]]; then
        break
    fi
done

echo ""
print_message "Iniciando instalación para el dominio: $DOMINIO"
echo "================================================"

# Verificar que se ejecuta como root
if [ "$EUID" -ne 0 ]; then 
    print_error "Por favor ejecuta el script como root (sudo)"
    exit 1
fi

# Comando 1
print_message "Comando 1: Instalando dependencias..."
apt -y install software-properties-common curl apt-transport-https ca-certificates gnupg lsb-release
check_error "apt install dependencias"

# Comando 2
print_message "Comando 2: Agregando repositorio PHP..."
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
check_error "repositorio PHP"

# Comando 3
print_message "Comando 3: Agregando repositorio Redis..."
curl -fsSL https://packages.redis.io/gpg | gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/redis.list
check_error "repositorio Redis"

# Comando 4 - apt update (ignora errores)
run_apt_update

# Comando 5
print_message "Comando 5: Instalando PHP, MariaDB, Nginx y Redis..."
apt install -y php8.3 php8.3-{common,cli,gd,mysql,mbstring,bcmath,xml,fpm,curl,zip,intl,redis} mariadb-server nginx git redis-server
check_error "instalación paquetes principales"

# Comando 6
print_message "Comando 6: Habilitando Redis..."
systemctl enable --now redis-server
check_error "habilitar Redis"

# Comando 7
print_message "Comando 7: Instalando Composer..."
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
check_error "instalación Composer"

# Comando 8
print_message "Comando 8: Creando directorio de la aplicación..."
mkdir -p /var/www/ctrlpanel && cd /var/www/ctrlpanel
check_error "crear directorio"

# Comando 9
print_message "Comando 9: Clonando repositorio..."
git clone https://github.com/Ctrlpanel-gg/panel.git ./
check_error "clonar repositorio"

# Comando 10
print_message "Comando 10: Configurando base de datos..."
print_warning "Se te solicitará la contraseña de root de MySQL"
print_warning "Por defecto es vacía (presiona Enter si es la primera instalación)"

mysql -u root -p <<EOF
CREATE USER IF NOT EXISTS 'ctrlpaneluser'@'127.0.0.1' IDENTIFIED BY '24032006';
CREATE DATABASE IF NOT EXISTS ctrlpanel;
GRANT ALL PRIVILEGES ON ctrlpanel.* TO 'ctrlpaneluser'@'127.0.0.1';
FLUSH PRIVILEGES;
EOF

if [ $? -ne 0 ]; then
    print_warning "Hubo un problema con la configuración de MySQL, pero continuamos..."
    print_warning "Es posible que necesites configurar la base de datos manualmente después"
else
    print_message "Base de datos configurada exitosamente"
fi

# Comando 11
print_message "Comando 11: Instalando dependencias PHP..."
COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader
check_error "composer install"

# Comando 12
print_message "Comando 12: Creando enlace de almacenamiento..."
php artisan storage:link
check_error "storage link"

# Comando 13 - apt update (ignora errores)
run_apt_update

# Comando 14
print_message "Comando 14: Instalando Certbot..."
apt install certbot -y
check_error "instalación certbot"

# Comando 15
print_message "Comando 15: Instalando plugin Certbot Nginx..."
apt install python3-certbot-nginx -y
check_error "instalación certbot nginx"

# Comando 16
print_message "Comando 16: Obteniendo certificado SSL..."
certbot certonly --nginx -d $DOMINIO --non-interactive --agree-tos --email admin@$DOMINIO
if [ $? -ne 0 ]; then
    print_warning "La obtención automática del certificado SSL falló"
    print_warning "Puedes ejecutar manualmente después: certbot certonly --nginx -d $DOMINIO"
else
    print_message "Certificado SSL obtenido exitosamente"
fi

# Comando 17
print_message "Comando 17: Eliminando configuración default de Nginx..."
rm /etc/nginx/sites-enabled/default 2>/dev/null || true

# Comando 18
print_message "Comando 18: Creando configuración de Nginx..."
cat > /etc/nginx/sites-available/ctrlpanel.conf <<EOF
server {
    listen 80;
    server_name $DOMINIO;
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name $DOMINIO;

    root /var/www/ctrlpanel/public;
    index index.php;

    access_log /var/log/nginx/ctrlpanel.app-access.log;
    error_log  /var/log/nginx/ctrlpanel.app-error.log error;

    client_max_body_size 100m;
    client_body_timeout 120s;

    sendfile off;

    ssl_certificate /etc/letsencrypt/live/$DOMINIO/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMINIO/privkey.pem;
    ssl_session_cache shared:SSL:10m;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384";
    ssl_prefer_server_ciphers on;

    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Robots-Tag none;
    add_header Content-Security-Policy "frame-ancestors 'self'";
    add_header X-Frame-Options DENY;
    add_header Referrer-Policy same-origin;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param PHP_VALUE "upload_max_filesize = 100M \n post_max_size=100M";
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param HTTP_PROXY "";
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF
check_error "crear configuración nginx"

# Comando 19
print_message "Comando 19: Habilitando sitio en Nginx..."
ln -s /etc/nginx/sites-available/ctrlpanel.conf /etc/nginx/sites-enabled/ctrlpanel.conf
check_error "habilitar sitio"

# Comando 20
print_message "Comando 20: Verificando configuración de Nginx..."
nginx -t
if [ $? -ne 0 ]; then
    print_error "La configuración de Nginx tiene errores"
    exit 1
else
    print_message "Configuración de Nginx válida"
fi

# Comando 21
print_message "Comando 21: Reiniciando Nginx..."
systemctl restart nginx
check_error "reiniciar nginx"

# Comando 22
print_message "Comando 22: Configurando permisos..."
chown -R www-data:www-data /var/www/ctrlpanel/
check_error "permisos usuario"

# Comando 23
print_message "Comando 23: Configurando permisos de carpetas..."
chmod -R 755 storage/* bootstrap/cache/
check_error "permisos carpetas"

# Comando 24
print_message "Comando 24: Configurando crontab..."
(crontab -l 2>/dev/null; echo "* * * * * php /var/www/ctrlpanel/artisan schedule:run >> /dev/null 2>&1") | crontab -
check_error "configurar crontab"

# Comando 25-26
print_message "Comando 25-26: Creando servicio de queue worker..."
cd /etc/systemd/system

cat > ctrlpanel.service <<EOF
# Ctrlpanel Queue Worker File
# ----------------------------------

[Unit]
Description=Ctrlpanel Queue Worker

[Service]
User=www-data
Group=www-data
Restart=always
ExecStart=/usr/bin/php /var/www/ctrlpanel/artisan queue:work --sleep=3 --tries=3
StartLimitBurst=0

[Install]
WantedBy=multi-user.target
EOF
check_error "crear servicio"

# Comando 27
print_message "Comando 27: Habilitando e iniciando servicio..."
systemctl enable --now ctrlpanel.service
check_error "habilitar servicio"

echo ""
echo "================================================"
echo -e "${GREEN}¡Instalación completada exitosamente!${NC}"
echo "================================================"
echo ""
echo "Resumen de la instalación:"
echo "Dominio: $DOMINIO"
echo "Usuario BD: ctrlpaneluser"
echo "Contraseña BD: 24032006"
echo "Base de datos: ctrlpanel"
echo ""
echo "Pasos siguientes:"
echo "1. Accede a https://$DOMINIO para continuar con la instalación web"
echo "2. Configura la base de datos con los datos proporcionados"
echo "3. Completa el asistente de instalación"
echo ""
print_warning "IMPORTANTE: Guarda los datos de la base de datos en un lugar seguro"
echo ""
echo "================================================"
