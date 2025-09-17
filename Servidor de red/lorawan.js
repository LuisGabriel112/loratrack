const fastify = require('fastify')({ logger: true }); // Enable logging
const lorawan = require('lorawan-packet'); // You might need a specific LoRaWAN library
const crypto = require('crypto'); // For encryption/decryption

// Configuration
const appEUI = 'TU_AppEUI'; // Replace with your AppEUI
const appKey = 'TU_AppKey'; // Replace with your AppKey (VERY SENSITIVE)

// Define the route for receiving LoRaWAN data
fastify.post('/lorawan/up', async (request, reply) => {
  try {
    // 1. Receive LoRaWAN packet from gateway (from the request body)
    const lorawanPacket = request.body; // Assuming gateway sends JSON in the request body

    // 2. Identify the device (DevEUI)
    const devEUI = lorawanPacket.DevEUI; // Assuming DevEUI is included

    // 3. OTAA Process (Simplified) -  This is the core of the challenge
    //    -  In a real OTAA, you'd need to handle Join Requests/Accepts
    //    -  For simplicity, we'll assume the keys are pre-provisioned (NOT SECURE in production)

    // 4.  Derive session keys (NwkSKey, AppSKey) -  This is a critical step in OTAA
    //    -  This example is highly simplified and NOT secure.  You need to follow the LoRaWAN specification for key derivation.
    const nwkSKey = crypto.createHmac('sha256', appKey).update(devEUI + 'nwk').digest('hex');
    const appSKey = crypto.createHmac('sha256', appKey).update(devEUI + 'app').digest('hex');

    // 5. Decrypt the payload (assuming it's encrypted with AppSKey)
    const encryptedPayload = Buffer.from(lorawanPacket.payload, 'base64'); // Assuming payload is base64 encoded

    const iv = Buffer.alloc(16, 0); // Initialization Vector (should be unique per message in real usage!)
    const decipher = crypto.createDecipheriv('aes-128-ctr', Buffer.from(appSKey, 'hex'), iv);
    let decryptedPayload = decipher.update(encryptedPayload);
    decryptedPayload = Buffer.concat([decryptedPayload, decipher.final()]);

    console.log(`Decrypted payload from DevEUI ${devEUI}:`, decryptedPayload.toString('utf8'));

    // Send a response back to the gateway
    reply.send({ message: 'Data received and processed' }); // Or send a more meaningful response

    // **Important:**  In a real system, you'd:
    //    - Store the derived session keys (NwkSKey, AppSKey) securely, associated with the DevEUI
    //    - Use the frame counter (FCnt) to prevent replay attacks.
    //    - Implement proper error handling.

  } catch (error) {
    console.error('Error processing message:', error);
    reply.status(500).send({ error: 'Failed to process data' });  // Send an error response
  }
});

// Start the server
const start = async () => {
  try {
    await fastify.listen({ port: 3000 }); // Listen on port 3000 (or your preferred port)
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};
start();


/*// Importa los módulos necesarios
const mqtt = require('mqtt');
const lorawan = require('lorawan-packet'); // Podrías necesitar una biblioteca LoRaWAN específica
const crypto = require('crypto'); // Para encriptación/desencriptación

// Configuración
const mqttBrokerUrl = 'mqtt://localhost'; // O tu broker MQTT en la nube
const mqttTopic = 'lorawan/up'; // Topic al que tu gateway publica

// Cliente MQTT
const mqttClient = mqtt.connect(mqttBrokerUrl);

mqttClient.on('connect', () => {
  console.log('Conectado al broker MQTT');
  mqttClient.subscribe(mqttTopic);
});

mqttClient.on('message', (topic, message) => {
  try {
    // 1. Recibe el paquete LoRaWAN del gateway
    const lorawanPacket = JSON.parse(message.toString()); // Asumiendo que el gateway envía JSON

    // 2. Identifica el dispositivo (DevEUI)
    const devEUI = lorawanPacket.DevEUI; // Asumiendo que el DevEUI está incluido

    // 3. Proceso OTAA (Simplificado) - Este es el núcleo del desafío
    //    - En un OTAA real, necesitarías manejar las Solicitudes/Aceptaciones de Unión
    //    - Para simplificar, asumiremos que las claves están pre-provisionadas (¡NO SEGURO en producción!)

    const appEUI = 'TU_AppEUI'; // Reemplaza con tu AppEUI
    const appKey = 'TU_AppKey'; // Reemplaza con tu AppKey (MUY SENSIBLE)

    // 4. Deriva las claves de sesión (NwkSKey, AppSKey) - Este es un paso crítico en OTAA
    //    - Este ejemplo está muy simplificado y NO es seguro. Necesitas seguir la especificación LoRaWAN para la derivación de claves.
    const nwkSKey = crypto.createHmac('sha256', appKey).update(devEUI + 'nwk').digest('hex');
    const appSKey = crypto.createHmac('sha256', appKey).update(devEUI + 'app').digest('hex');

    // 5. Desencripta la carga útil (asumiendo que está encriptada con AppSKey)
    const encryptedPayload = Buffer.from(lorawanPacket.payload, 'base64'); // Asumiendo que la carga útil está codificada en base64
    const iv = Buffer.alloc(16, 0); // Vector de inicialización (¡debería ser único por mensaje en uso real!)
    const decipher = crypto.createDecipheriv('aes-128-ctr', Buffer.from(appSKey, 'hex'), iv);
    let decryptedPayload = decipher.update(encryptedPayload);
    decryptedPayload = Buffer.concat([decryptedPayload, decipher.final()]);

    console.log(`Carga útil desencriptada del DevEUI ${devEUI}:`, decryptedPayload.toString('utf8'));

    // **Importante:** En un sistema real, harías:
    //    - Almacenar las claves de sesión derivadas (NwkSKey, AppSKey) de forma segura, asociadas con el DevEUI
    //    - Usar el contador de trama (FCnt) para prevenir ataques de repetición.
    //    - Implementar un manejo de errores adecuado.

  } catch (error) {
    console.error('Error al procesar el mensaje:', error);
  }
});

mqttClient.on('error', (error) => {
  console.error('Error de MQTT:', error);
});*/ 