const Fastify = require('fastify')
const fastifyPlugin = require('fastify-plugin')
const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
const websocket = require('@fastify/websocket')
const cors = require('@fastify/cors')

const JWT_SECRET = process.env.JWT_SECRET || 'c2e0233ad3e7eb1c6ca1ba3c6773e55e1dc190f93867d2a0f671759af0d3370b' // ¡Cambia esto!

async function dbConnector (fastify, options) {
  fastify.register(require('@fastify/mongodb'), {
    forceClose: true,
    url: 'mongodb://127.0.0.1:27017/comunicationProtocols'
  })
}

const dbPlugin = fastifyPlugin(dbConnector)
async function app (fastify, options) {
  fastify.register(dbPlugin)
  fastify.register(websocket)
  fastify.register(cors, {
  origin: (requestOrigin, cb) => {
    const allowedOrigins = [
      'http://127.0.0.1:5500', // Django (si está en localhost)
      'http://localhost:2400', // Flutter (si usas el navegador para Flutter web
    ];

    if (!requestOrigin || allowedOrigins.includes(requestOrigin)) {
      cb(null, true); // Permitir la solicitud
    } else {
      console.log('Origen bloqueado por CORS:', requestOrigin);
      cb(new Error('Origen no permitido'), false);
    }
  },
  methods: ['GET', 'POST', 'PUT'], // Métodos HTTP permitidos
  allowedHeaders: ['Content-Type', 'Authorization'], // Encabezados permitidos
  credentials: true, // Permite cookies (si las usas)
})

  fastify.post('/login', async (request, reply) => {
    const {Username} = request.body;
    const collection = fastify.mongo.db.collection('CreatedUsers'); // Usa la colección correcta

    // Mejorar la búsqueda: Usar un índice en el campo 'username'
    const user = await collection.findOne({ Username: Username});

    if (!user) {
      reply.code(405).send({ message: 'Credenciales inválidas' });
      return;
    }

    // Authentication successful, send a success message
    reply.send({ message: 'Inicio de sesión exitoso' });
});

  // WebSocket Route
  fastify.get('/ws', { websocket: true }, (connection, req) => {
    console.log(`Alguien conectado vía WebSocket`)
    connection.socket.on('message', message => {
      // Procesa las coordenadas (¡Valida y sanitiza!)
      try {
        const coords = JSON.parse(message)
        console.log(`Recibido coordenadas:`, coords)
        // Aquí puedes guardar las coordenadas en MongoDB
        fastify.mongo.db.collection('coordinates').insertOne({
          latitude: coords.latitude,
          longitude: coords.longitude,
          timestamp: new Date()
        })

        // Envía las coordenadas a todos los clientes conectados (opcional)
        for (const client of fastify.websocketServer.clients) {
          if (client !== connection.socket && client.readyState === 1) {
            client.send(message)
          }
        }
      } catch (error) {
        console.error("Error al procesar el mensaje WebSocket:", error)
      }
    })

    connection.socket.on('close', () => {
      console.log(`Alguien desconectado del WebSocket`)
    })
  })

  // History Route
   fastify.get('/history', async (request, reply) => {
    // Obtiene el historial de coordenadas del usuario desde MongoDB
    const history = await fastify.mongo.db.collection('coordinates')
      .find()
      .sort({ timestamp: -1 }) // Ordena por fecha descendente
      .limit(100) // Limita a los 100 registros más recientes
      .toArray();

    reply.send(history);
  });
}

const start = async () => {
  const fastify = Fastify({
    logger: true
  })
  try {
    await fastify.register(app)
    await fastify.listen({ port: 5500 })
  } catch (err) {
    fastify.log.error(err)
    process.exit(1)
  }
}

start()