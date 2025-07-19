const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// Routes
app.get('/', (req, res) => {
    res.send(`
        <!DOCTYPE html>
        <html lang="fr">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Projet 2 - Node.js App</title>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }
                
                body {
                    font-family: 'Arial', sans-serif;
                    background: linear-gradient(135deg, #FF6B6B, #4ECDC4);
                    min-height: 100vh;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: white;
                }
                
                .container {
                    text-align: center;
                    padding: 3rem;
                    background: rgba(255, 255, 255, 0.1);
                    border-radius: 20px;
                    backdrop-filter: blur(10px);
                    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                    max-width: 700px;
                }
                
                h1 {
                    font-size: 3rem;
                    margin-bottom: 1rem;
                }
                
                .status {
                    display: inline-block;
                    padding: 8px 16px;
                    background: #4CAF50;
                    border-radius: 20px;
                    margin: 1rem 0;
                }
                
                .api-demo {
                    margin: 2rem 0;
                    padding: 1rem;
                    background: rgba(255, 255, 255, 0.05);
                    border-radius: 10px;
                }
                
                button {
                    background: linear-gradient(45deg, #FF6B6B, #FF8E53);
                    color: white;
                    border: none;
                    padding: 12px 24px;
                    border-radius: 30px;
                    cursor: pointer;
                    margin: 0.5rem;
                    transition: transform 0.3s ease;
                }
                
                button:hover {
                    transform: translateY(-2px);
                }
                
                #apiResult {
                    margin-top: 1rem;
                    padding: 1rem;
                    background: rgba(0, 0, 0, 0.2);
                    border-radius: 10px;
                    min-height: 50px;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>⚡ Projet 2</h1>
                <div class="status">🟢 Node.js App Running</div>
                <p>Application Node.js dynamique avec API intégrée</p>
                
                <div class="api-demo">
                    <h3>🔗 Test API</h3>
                    <button onclick="testAPI()">Tester l'API</button>
                    <button onclick="getStats()">Statistiques</button>
                    <div id="apiResult">Cliquez sur un bouton pour tester l'API</div>
                </div>
                
                <a href="/" style="color: #fff; text-decoration: none; padding: 12px 24px; background: rgba(255,255,255,0.2); border-radius: 20px; display: inline-block; margin-top: 2rem;">
                    🏠 Retour au Portfolio
                </a>
            </div>
            
            <script>
                async function testAPI() {
                    const result = document.getElementById('apiResult');
                    result.innerHTML = '⏳ Chargement...';
                    
                    try {
                        const response = await fetch('/api/test');
                        const data = await response.json();
                        result.innerHTML = '<strong>✅ Succès:</strong><br>' + JSON.stringify(data, null, 2);
                    } catch (error) {
                        result.innerHTML = '<strong>❌ Erreur:</strong><br>' + error.message;
                    }
                }
                
                async function getStats() {
                    const result = document.getElementById('apiResult');
                    result.innerHTML = '⏳ Chargement...';
                    
                    try {
                        const response = await fetch('/api/stats');
                        const data = await response.json();
                        result.innerHTML = '<strong>📊 Statistiques:</strong><br>' + JSON.stringify(data, null, 2);
                    } catch (error) {
                        result.innerHTML = '<strong>❌ Erreur:</strong><br>' + error.message;
                    }
                }
            </script>
        </body>
        </html>
    `);
});

app.get('/api/test', (req, res) => {
    res.json({
        message: 'API fonctionnelle !',
        timestamp: new Date().toISOString(),
        project: 'Portfolio Project 2',
        version: '1.0.0'
    });
});

app.get('/api/stats', (req, res) => {
    res.json({
        uptime: process.uptime(),
        memory: process.memoryUsage(),
        nodeVersion: process.version,
        platform: process.platform,
        pid: process.pid
    });
});

app.get('/health', (req, res) => {
    res.json({ status: 'OK', service: 'Project2' });
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 Projet 2 démarré sur le port ${PORT}`);
    console.log(`📱 Environnement: ${process.env.NODE_ENV || 'development'}`);
});
