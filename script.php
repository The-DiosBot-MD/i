<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>The-DiosBot-MD | Documentación Oficial</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;14..32,400;14..32,500;14..32,600;14..32,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #0f0c29 0%, #302b63 50%, #24243e 100%);
            min-height: 100vh;
            color: #e5e7eb;
            line-height: 1.6;
        }

        /* Partículas de fondo animadas */
        .bg-particles {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 0;
            overflow: hidden;
        }

        .particle {
            position: absolute;
            background: rgba(139, 92, 246, 0.3);
            border-radius: 50%;
            pointer-events: none;
            animation: float linear infinite;
        }

        @keyframes float {
            0% {
                transform: translateY(100vh) rotate(0deg);
                opacity: 0;
            }
            10% {
                opacity: 0.5;
            }
            90% {
                opacity: 0.5;
            }
            100% {
                transform: translateY(-20vh) rotate(360deg);
                opacity: 0;
            }
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
            position: relative;
            z-index: 1;
        }

        /* Header con efecto glassmorphism */
        .header {
            text-align: center;
            margin-bottom: 4rem;
            animation: fadeInDown 0.8s ease-out;
        }

        .logo {
            display: inline-flex;
            align-items: center;
            gap: 1rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 1rem 2rem;
            border-radius: 100px;
            margin-bottom: 1.5rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }

        .logo i {
            font-size: 2.5rem;
            filter: drop-shadow(0 2px 5px rgba(0,0,0,0.2));
        }

        .logo h1 {
            font-size: 2rem;
            font-weight: 700;
            background: linear-gradient(135deg, #fff, #e0e7ff);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .badge-container {
            display: flex;
            justify-content: center;
            gap: 1rem;
            flex-wrap: wrap;
            margin-top: 1rem;
        }

        .badge {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 0.85rem;
            border: 1px solid rgba(255,255,255,0.2);
        }

        .badge i {
            margin-right: 0.5rem;
            font-size: 0.9rem;
        }

        /* Cards de comandos */
        .commands-grid {
            display: grid;
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .command-card {
            background: rgba(255,255,255,0.05);
            backdrop-filter: blur(10px);
            border-radius: 24px;
            border: 1px solid rgba(255,255,255,0.1);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            animation: fadeInUp 0.6s ease-out;
            animation-fill-mode: both;
        }

        .command-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
            border-color: rgba(139, 92, 246, 0.5);
        }

        .card-header {
            background: linear-gradient(135deg, rgba(139, 92, 246, 0.2), rgba(99, 102, 241, 0.2));
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .card-header h2 {
            font-size: 1.5rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .card-header h2 i {
            color: #8b5cf6;
            font-size: 1.75rem;
        }

        .card-body {
            padding: 1.5rem;
        }

        .description {
            color: #a0aec0;
            margin-bottom: 1.5rem;
            font-size: 0.95rem;
        }

        .code-block {
            background: #0a0a0f;
            border-radius: 16px;
            padding: 0;
            overflow: hidden;
            border: 1px solid rgba(139, 92, 246, 0.3);
            transition: all 0.3s ease;
        }

        .code-header {
            background: rgba(0,0,0,0.4);
            padding: 0.75rem 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .code-label {
            font-size: 0.8rem;
            color: #8b5cf6;
            font-weight: 500;
            letter-spacing: 0.5px;
        }

        .copy-btn {
            background: rgba(139, 92, 246, 0.2);
            border: none;
            color: #e5e7eb;
            padding: 0.4rem 0.8rem;
            border-radius: 8px;
            cursor: pointer;
            font-size: 0.8rem;
            font-family: 'Inter', sans-serif;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s ease;
            backdrop-filter: blur(5px);
        }

        .copy-btn:hover {
            background: #8b5cf6;
            transform: scale(1.05);
        }

        .copy-btn.copied {
            background: #10b981;
        }

        pre {
            margin: 0;
            padding: 1rem;
            overflow-x: auto;
            font-family: 'Fira Code', 'Courier New', monospace;
            font-size: 0.9rem;
            line-height: 1.5;
            color: #e5e7eb;
        }

        code {
            font-family: 'Fira Code', 'Courier New', monospace;
        }

        /* Archivos list */
        .files-section {
            background: rgba(255,255,255,0.05);
            backdrop-filter: blur(10px);
            border-radius: 24px;
            padding: 1.5rem;
            margin-top: 2rem;
            border: 1px solid rgba(255,255,255,0.1);
            animation: fadeInUp 0.6s ease-out 0.3s both;
        }

        .files-section h3 {
            font-size: 1.3rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .files-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
        }

        .file-tag {
            background: rgba(139, 92, 246, 0.2);
            padding: 0.5rem 1rem;
            border-radius: 12px;
            font-size: 0.85rem;
            font-family: monospace;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s ease;
        }

        .file-tag i {
            font-size: 0.9rem;
            color: #8b5cf6;
        }

        .file-tag:hover {
            background: rgba(139, 92, 246, 0.4);
            transform: translateY(-2px);
        }

        /* Footer */
        .footer {
            text-align: center;
            margin-top: 4rem;
            padding-top: 2rem;
            border-top: 1px solid rgba(255,255,255,0.1);
            font-size: 0.85rem;
            color: #8b8b9e;
        }

        /* Animaciones */
        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Scrollbar personalizada */
        ::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }

        ::-webkit-scrollbar-track {
            background: rgba(0,0,0,0.3);
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb {
            background: #8b5cf6;
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: #6d28d9;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }
            
            .logo h1 {
                font-size: 1.5rem;
            }
            
            .card-header h2 {
                font-size: 1.2rem;
            }
            
            pre {
                font-size: 0.75rem;
            }
        }

        /* Toast notification */
        .toast {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            background: #10b981;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 50px;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 0.9rem;
            z-index: 1000;
            animation: slideIn 0.3s ease;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
    </style>
</head>
<body>
    <div class="bg-particles" id="particles"></div>
    
    <div class="container">
        <div class="header">
            <div class="logo">
                <i class="fab fa-whatsapp"></i>
                <h1>The-DiosBot-MD</h1>
            </div>
            <p style="font-size: 1.1rem; margin-bottom: 1rem;">🤖 Bot avanzado para WhatsApp con múltiples funcionalidades</p>
            <div class="badge-container">
                <span class="badge"><i class="fab fa-node-js"></i> Node.js</span>
                <span class="badge"><i class="fab fa-whatsapp"></i> WhatsApp WebJS</span>
                <span class="badge"><i class="fas fa-terminal"></i> Bash Scripts</span>
                <span class="badge"><i class="fas fa-code"></i> Open Source</span>
            </div>
        </div>

        <div class="commands-grid">
            <!-- Opción 1 -->
            <div class="command-card" style="animation-delay: 0.1s">
                <div class="card-header">
                    <h2>
                        <i class="fas fa-terminal"></i>
                        Opción 1: Usando bash con descriptor de archivo
                    </h2>
                </div>
                <div class="card-body">
                    <div class="description">
                        <i class="fas fa-info-circle" style="color: #8b5cf6;"></i> Ejecución directa desde GitHub usando el descriptor de archivo. Ideal para pruebas rápidas.
                    </div>
                    <div class="code-block">
                        <div class="code-header">
                            <span class="code-label"><i class="fas fa-code"></i> bash</span>
                            <button class="copy-btn" data-copy="bash <<(curl -sSL https://raw.githubusercontent.com/The-DiosBot-MD/i/main/start.sh)">
                                <i class="far fa-copy"></i>
                                <span>Copiar</span>
                            </button>
                        </div>
                        <pre><code>bash <<(curl -sSL https://raw.githubusercontent.com/The-DiosBot-MD/i/main/start.sh)</code></pre>
                    </div>
                </div>
            </div>

            <!-- Opción 2 -->
            <div class="command-card" style="animation-delay: 0.2s">
                <div class="card-header">
                    <h2>
                        <i class="fas fa-download"></i>
                        Opción 2: Descargar y ejecutar (más confiable)
                    </h2>
                </div>
                <div class="card-body">
                    <div class="description">
                        <i class="fas fa-star" style="color: #f59e0b;"></i> <strong>Recomendada</strong> - Descarga el script localmente y lo ejecuta. Mayor estabilidad.
                    </div>
                    <div class="code-block">
                        <div class="code-header">
                            <span class="code-label"><i class="fas fa-code"></i> bash</span>
                            <button class="copy-btn" data-copy="curl -sSL https://raw.githubusercontent.com/The-DiosBot-MD/i/main/start.sh -o /tmp/start.sh && bash /tmp/start.sh">
                                <i class="far fa-copy"></i>
                                <span>Copiar</span>
                            </button>
                        </div>
                        <pre><code>curl -sSL https://raw.githubusercontent.com/The-DiosBot-MD/i/main/start.sh -o /tmp/start.sh && bash /tmp/start.sh</code></pre>
                    </div>
                </div>
            </div>

            <!-- Opción 3 -->
            <div class="command-card" style="animation-delay: 0.3s">
                <div class="card-header">
                    <h2>
                        <i class="fas fa-broom"></i>
                        Opción 3: Una línea más limpia
                    </h2>
                </div>
                <div class="card-body">
                    <div class="description">
                        <i class="fas fa-magic" style="color: #8b5cf6;"></i> Comando en una sola línea, limpio y directo para ejecución rápida.
                    </div>
                    <div class="code-block">
                        <div class="code-header">
                            <span class="code-label"><i class="fas fa-code"></i> bash</span>
                            <button class="copy-btn" data-copy="curl -sSL https://raw.githubusercontent.com/The-DiosBot-MD/i/main/start.sh | bash -s">
                                <i class="far fa-copy"></i>
                                <span>Copiar</span>
                            </button>
                        </div>
                        <pre><code>curl -sSL https://raw.githubusercontent.com/The-DiosBot-MD/i/main/start.sh | bash -s</code></pre>
                    </div>
                </div>
            </div>
        </div>

        <!-- Archivos del proyecto -->
        <div class="files-section">
            <h3>
                <i class="fas fa-folder-open"></i>
                Estructura del Proyecto
            </h3>
            <div class="files-grid">
                <div class="file-tag"><i class="fab fa-markdown"></i> README.md</div>
                <div class="file-tag"><i class="fas fa-file-code"></i> bluepin.sh</div>
                <div class="file-tag"><i class="fas fa-file-code"></i> dash.sh</div>
                <div class="file-tag"><i class="fas fa-file-code"></i> menu_real.sh</div>
                <div class="file-tag"><i class="fas fa-file-code"></i> panel.sh</div>
                <div class="file-tag"><i class="fas fa-file-code"></i> start.sh</div>
            </div>
            <p style="margin-top: 1rem; font-size: 0.85rem; color: #a0aec0;">
                <i class="fas fa-info-circle"></i> Todos los scripts están optimizados para una instalación rápida y configuración sencilla.
            </p>
        </div>

        <!-- Footer con información adicional -->
        <div class="footer">
            <p>
                <i class="fab fa-github"></i> The-DiosBot-MD | 
                <i class="fas fa-code-branch"></i> Versión estable | 
                <i class="fas fa-heart" style="color: #ec489a;"></i> Código abierto
            </p>
            <p style="margin-top: 0.5rem; font-size: 0.75rem;">
                © 2024 The-DiosBot-MD - Bot para WhatsApp con múltiples características
            </p>
        </div>
    </div>

    <script>
        // Crear partículas animadas
        function createParticles() {
            const particlesContainer = document.getElementById('particles');
            const particleCount = 50;
            
            for (let i = 0; i < particleCount; i++) {
                const particle = document.createElement('div');
                particle.classList.add('particle');
                const size = Math.random() * 4 + 2;
                particle.style.width = `${size}px`;
                particle.style.height = `${size}px`;
                particle.style.left = `${Math.random() * 100}%`;
                particle.style.animationDuration = `${Math.random() * 10 + 10}s`;
                particle.style.animationDelay = `${Math.random() * 10}s`;
                particle.style.opacity = Math.random() * 0.5;
                particlesContainer.appendChild(particle);
            }
        }
        
        createParticles();

        // Función para mostrar toast
        function showToast(message, isError = false) {
            const existingToast = document.querySelector('.toast');
            if (existingToast) existingToast.remove();
            
            const toast = document.createElement('div');
            toast.className = 'toast';
            toast.style.background = isError ? '#ef4444' : '#10b981';
            toast.innerHTML = `
                <i class="fas ${isError ? 'fa-exclamation-triangle' : 'fa-check-circle'}"></i>
                <span>${message}</span>
            `;
            document.body.appendChild(toast);
            
            setTimeout(() => {
                toast.style.animation = 'slideIn 0.3s ease reverse';
                setTimeout(() => toast.remove(), 300);
            }, 2000);
        }

        // Función para copiar texto
        async function copyToClipboard(text, button) {
            try {
                await navigator.clipboard.writeText(text);
                const originalContent = button.innerHTML;
                button.innerHTML = '<i class="fas fa-check"></i><span>Copiado!</span>';
                button.classList.add('copied');
                showToast('✅ Comando copiado al portapapeles');
                
                setTimeout(() => {
                    button.innerHTML = originalContent;
                    button.classList.remove('copied');
                }, 2000);
            } catch (err) {
                console.error('Error al copiar:', err);
                showToast('❌ Error al copiar el comando', true);
            }
        }

        // Asignar eventos a todos los botones de copiar
        document.querySelectorAll('.copy-btn').forEach(button => {
            button.addEventListener('click', (e) => {
                e.preventDefault();
                const command = button.getAttribute('data-copy');
                if (command) {
                    copyToClipboard(command, button);
                }
            });
        });

        // Efecto de hover en los archivos
        document.querySelectorAll('.file-tag').forEach(tag => {
            tag.addEventListener('click', () => {
                const fileName = tag.textContent.trim();
                showToast(`📄 Archivo: ${fileName}`);
            });
        });

        // Animación de entrada para las cards
        const cards = document.querySelectorAll('.command-card, .files-section');
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, { threshold: 0.1 });
        
        cards.forEach(card => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            card.style.transition = 'all 0.6s ease';
            observer.observe(card);
        });
        
        // Forzar que se muestren después de cargar
        setTimeout(() => {
            cards.forEach(card => {
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            });
        }, 100);

        // Mensaje de bienvenida en consola
        console.log('%c🚀 The-DiosBot-MD | Documentación Cargada', 'color: #8b5cf6; font-size: 16px; font-weight: bold;');
        console.log('%c✨ Bot para WhatsApp con instalación simplificada', 'color: #a78bfa; font-size: 12px;');
    </script>
</body>
</html>
