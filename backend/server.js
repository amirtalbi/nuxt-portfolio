import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import dotenv from 'dotenv';
import nodemailer from 'nodemailer';

// Charger les variables d'environnement
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3001;

// Configuration CORS pour permettre les requêtes depuis le frontend
const corsOptions = {
  origin: function (origin, callback) {
    // Origines autorisées
    const allowedOrigins = [
      process.env.FRONTEND_URL || 'http://localhost:3000',
      'http://localhost:3000',  // Développement
      'https://localhost',      // Production Docker local
      'https://localhost:443',  // Production Docker local avec port
    ];
    
    // Permettre les requêtes sans origine (ex: Postman, applications mobiles)
    if (!origin) return callback(null, true);
    
    if (allowedOrigins.indexOf(origin) !== -1) {
      callback(null, true);
    } else {
      console.log('CORS Error: Origin not allowed:', origin);
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true,
  optionsSuccessStatus: 200,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With']
};

// Middlewares de sécurité
app.use(helmet({
  contentSecurityPolicy: false
}));
app.use(cors(corsOptions));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Middleware pour logger les requêtes (utile pour débugger)
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path} - Origin: ${req.get('Origin') || 'No origin'}`);
  next();
});

// Rate limiting pour l'envoi d'emails
const emailLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // Maximum 5 emails par IP toutes les 15 minutes
  message: {
    error: 'Trop de tentatives d\'envoi d\'email. Réessayez dans 15 minutes.'
  },
  standardHeaders: true,
  legacyHeaders: false,
});

// Configuration du transporteur email
const createTransporter = () => {
  if (process.env.EMAIL_SERVICE === 'gmail') {
    return nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS // App password pour Gmail
      }
    });
  } else {
    // Configuration SMTP générique
    return nodemailer.createTransport({
      host: process.env.SMTP_HOST,
      port: process.env.SMTP_PORT || 587,
      secure: process.env.SMTP_SECURE === 'true',
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
      }
    });
  }
};

// Template HTML pour l'email
const createEmailTemplate = (name, email, message) => {
  return `
    <!DOCTYPE html>
    <html lang="fr">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Nouveau message de contact</title>
      <style>
        body {
          font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
          line-height: 1.6;
          color: #333;
          max-width: 600px;
          margin: 0 auto;
          padding: 20px;
          background-color: #f8f9fa;
        }
        .container {
          background: white;
          border-radius: 16px;
          overflow: hidden;
          box-shadow: 0 8px 32px rgba(0,0,0,0.1);
        }
        .header {
          background: linear-gradient(135deg, #ff6b6b 0%, #ffa500 100%);
          color: white;
          padding: 32px 24px;
          text-align: center;
          position: relative;
        }
        .header::before {
          content: '';
          position: absolute;
          top: 0;
          left: 0;
          right: 0;
          bottom: 0;
          background: linear-gradient(45deg, rgba(255,255,255,0.1) 25%, transparent 25%, transparent 75%, rgba(255,255,255,0.1) 75%), 
                      linear-gradient(45deg, rgba(255,255,255,0.1) 25%, transparent 25%, transparent 75%, rgba(255,255,255,0.1) 75%);
          background-size: 20px 20px;
          background-position: 0 0, 10px 10px;
        }
        .header h1 {
          margin: 0;
          font-size: 28px;
          font-weight: 700;
          position: relative;
          z-index: 1;
        }
        .header p {
          margin: 8px 0 0 0;
          opacity: 0.9;
          position: relative;
          z-index: 1;
        }
        .content {
          padding: 32px 24px;
        }
        .info-section {
          background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
          padding: 24px;
          border-radius: 12px;
          margin: 24px 0;
          border: 1px solid rgba(255, 107, 107, 0.1);
          position: relative;
        }
        .info-section::before {
          content: '';
          position: absolute;
          left: 0;
          top: 0;
          bottom: 0;
          width: 4px;
          background: linear-gradient(to bottom, #ff6b6b, #ffa500);
          border-radius: 0 4px 4px 0;
        }
        .info-section h3 {
          margin: 0 0 16px 0;
          color: #495057;
          font-size: 18px;
          font-weight: 600;
        }
        .info-row {
          display: flex;
          justify-content: space-between;
          align-items: flex-start;
          margin: 12px 0;
          padding: 8px 0;
          border-bottom: 1px solid rgba(0,0,0,0.05);
        }
        .info-row:last-child {
          border-bottom: none;
        }
        .label {
          font-weight: 600;
          color: #495057;
          min-width: 100px;
          font-size: 14px;
        }
        .value {
          color: #212529;
          flex: 1;
          text-align: right;
          font-weight: 500;
          word-break: break-word;
        }
        .message-section {
          background: #fff;
          padding: 24px;
          border-radius: 12px;
          border: 2px solid #f1f3f4;
          margin: 24px 0;
          position: relative;
        }
        .message-section::before {
          content: '"';
          font-size: 48px;
          color: #ff6b6b;
          opacity: 0.3;
          position: absolute;
          top: 8px;
          left: 16px;
          font-family: serif;
        }
        .message-section h3 {
          margin: 0 0 16px 0;
          color: #495057;
          font-size: 18px;
          font-weight: 600;
        }
        .message-content {
          white-space: pre-wrap;
          font-size: 16px;
          line-height: 1.6;
          color: #495057;
          padding-left: 24px;
          font-style: italic;
        }
        .footer {
          background: #f8f9fa;
          text-align: center;
          padding: 24px;
          color: #6c757d;
          border-top: 1px solid #dee2e6;
        }
        .portfolio-link {
          color: #ff6b6b;
          text-decoration: none;
          font-weight: 600;
          border-bottom: 2px solid transparent;
          transition: border-bottom-color 0.3s ease;
        }
        .portfolio-link:hover {
          border-bottom-color: #ff6b6b;
        }
        .timestamp {
          font-size: 12px;
          color: #adb5bd;
          margin-top: 8px;
        }
        .emoji {
          font-size: 20px;
          margin-right: 8px;
        }
        @media (max-width: 600px) {
          body {
            padding: 10px;
          }
          .content {
            padding: 20px 16px;
          }
          .info-section, .message-section {
            padding: 16px;
          }
          .header {
            padding: 24px 16px;
          }
        }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1><span class="emoji">📧</span>Nouveau message de contact</h1>
          <p>Votre portfolio a reçu un nouveau message !</p>
        </div>
        
        <div class="content">
          <div class="info-section">
            <h3><span class="emoji">👤</span>Informations de contact</h3>
            <div class="info-row">
              <span class="label">Nom complet</span>
              <span class="value">${name}</span>
            </div>
            <div class="info-row">
              <span class="label">Adresse email</span>
              <span class="value">${email}</span>
            </div>
            <div class="info-row">
              <span class="label">Date de réception</span>
              <span class="value">${new Date().toLocaleDateString('fr-FR', {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
              })}</span>
            </div>
          </div>
          
          <div class="message-section">
            <h3><span class="emoji">💬</span>Message</h3>
            <div class="message-content">${message}</div>
          </div>
        </div>
        
        <div class="footer">
          <p>Ce message a été envoyé depuis votre <a href="${process.env.FRONTEND_URL || 'https://localhost'}" class="portfolio-link">portfolio</a></p>
          <p class="timestamp">Email automatique - Ne pas répondre à cette adresse</p>
        </div>
      </div>
    </body>
    </html>
  `;
};

// Route de test
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    message: 'Backend portfolio service is running',
    timestamp: new Date().toISOString()
  });
});

// Route pour envoyer un email
app.post('/api/contact', emailLimiter, async (req, res) => {
  try {
    const { name, email, message } = req.body;

    // Validation des données
    if (!name || !email || !message) {
      return res.status(400).json({
        success: false,
        error: 'Tous les champs sont requis (nom, email, message)'
      });
    }

    // Validation de l'email
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({
        success: false,
        error: 'Format d\'email invalide'
      });
    }

    // Validation de la longueur
    if (name.length > 100 || email.length > 255 || message.length > 2000) {
      return res.status(400).json({
        success: false,
        error: 'Les données dépassent la longueur maximale autorisée'
      });
    }

    const transporter = createTransporter();

    // Email pour vous (propriétaire du portfolio)
    const ownerMailOptions = {
      from: process.env.EMAIL_USER,
      to: process.env.OWNER_EMAIL || process.env.EMAIL_USER,
      subject: `🚀 Nouveau message de contact - ${name}`,
      html: createEmailTemplate(name, email, message),
      text: `Nouveau message de contact de ${name} (${email}):\n\n${message}`
    };

    // Email de confirmation pour l'expéditeur
    const senderMailOptions = {
      from: process.env.EMAIL_USER,
      to: email,
      subject: '✅ Confirmation de réception - Amir Talbi Portfolio',
      html: `
        <!DOCTYPE html>
        <html lang="fr">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Message reçu</title>
          <style>
            body {
              font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
              line-height: 1.6;
              color: #333;
              max-width: 600px;
              margin: 0 auto;
              padding: 20px;
              background-color: #f8f9fa;
            }
            .container {
              background: white;
              border-radius: 16px;
              overflow: hidden;
              box-shadow: 0 8px 32px rgba(0,0,0,0.1);
            }
            .header {
              background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
              color: white;
              padding: 32px 24px;
              text-align: center;
              position: relative;
            }
            .header::before {
              content: '';
              position: absolute;
              top: 0;
              left: 0;
              right: 0;
              bottom: 0;
              background: linear-gradient(45deg, rgba(255,255,255,0.1) 25%, transparent 25%, transparent 75%, rgba(255,255,255,0.1) 75%), 
                          linear-gradient(45deg, rgba(255,255,255,0.1) 25%, transparent 25%, transparent 75%, rgba(255,255,255,0.1) 75%);
              background-size: 20px 20px;
              background-position: 0 0, 10px 10px;
            }
            .header h1 {
              margin: 0;
              font-size: 28px;
              font-weight: 700;
              position: relative;
              z-index: 1;
            }
            .content {
              padding: 32px 24px;
            }
            .message-preview {
              background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
              border-left: 4px solid #28a745;
              padding: 20px;
              margin: 20px 0;
              border-radius: 0 8px 8px 0;
              font-style: italic;
              position: relative;
            }
            .message-preview::before {
              content: '"';
              font-size: 48px;
              color: #28a745;
              opacity: 0.3;
              position: absolute;
              top: -8px;
              left: 8px;
              font-family: serif;
            }
            .signature {
              margin-top: 24px;
              padding: 20px;
              background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);
              border-radius: 12px;
              border: 1px solid #dee2e6;
            }
            .footer {
              background: #f8f9fa;
              text-align: center;
              padding: 24px;
              color: #6c757d;
              border-top: 1px solid #dee2e6;
            }
            .emoji {
              font-size: 20px;
              margin-right: 8px;
            }
            @media (max-width: 600px) {
              body {
                padding: 10px;
              }
              .content {
                padding: 20px 16px;
              }
              .header {
                padding: 24px 16px;
              }
            }
          </style>
        </head>
        <body>
          <div class="container">
            <div class="header">
              <h1><span class="emoji">✅</span>Message bien reçu !</h1>
              <p>Merci pour votre prise de contact</p>
            </div>
            <div class="content">
              <p>Bonjour <strong>${name}</strong>,</p>
              <p>Merci pour votre message ! Je l'ai bien reçu et je vous répondrai dans les plus brefs délais.</p>
              
              <div class="message-preview">
                <strong>Rappel de votre message :</strong><br><br>
                ${message}
              </div>
              
              <div class="signature">
                <p style="margin: 0;"><strong>À bientôt,</strong></p>
                <p style="margin: 8px 0 0 0; color: #ff6b6b; font-weight: 600; font-size: 18px;">Amir Talbi</p>
                <p style="margin: 4px 0 0 0; color: #6c757d; font-size: 14px;">Développeur Full Stack</p>
                <p style="margin: 12px 0 0 0; font-size: 14px;">
                  🌐 <a href="${process.env.FRONTEND_URL || 'https://localhost'}" style="color: #ff6b6b; text-decoration: none;">Portfolio</a> | 
                  💼 <a href="https://www.linkedin.com/in/amir-talbi" style="color: #0077b5; text-decoration: none;">LinkedIn</a> | 
                  💻 <a href="https://github.com/amirtalbi" style="color: #333; text-decoration: none;">GitHub</a>
                </p>
              </div>
            </div>
            <div class="footer">
              <p><span class="emoji">📧</span>Email automatique - Ne pas répondre</p>
            </div>
          </div>
        </body>
        </html>
      `,
      text: `Bonjour ${name},\n\nMerci pour votre message ! Je l'ai bien reçu et je vous répondrai dans les plus brefs délais.\n\nRappel de votre message :\n"${message}"\n\nÀ bientôt,\nAmir Talbi\nDéveloppeur Full Stack`
    };

    // Envoyer les emails
    await Promise.all([
      transporter.sendMail(ownerMailOptions),
      transporter.sendMail(senderMailOptions)
    ]);

    console.log(`📧 Email sent successfully from ${email}`);

    res.json({
      success: true,
      message: 'Email envoyé avec succès'
    });

  } catch (error) {
    console.error('❌ Error sending email:', error);
    res.status(500).json({
      success: false,
      error: 'Erreur lors de l\'envoi de l\'email. Veuillez réessayer plus tard.'
    });
  }
});

// Gestion des erreurs 404
app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: 'Route non trouvée'
  });
});

// Gestion des erreurs globales
app.use((error, req, res, next) => {
  console.error('❌ Server error:', error);
  res.status(500).json({
    success: false,
    error: 'Erreur interne du serveur'
  });
});

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📧 Email service configured with ${process.env.EMAIL_SERVICE || 'SMTP'}`);
});
