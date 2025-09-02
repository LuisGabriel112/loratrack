const fastify = require('fastify')({ logger: true });
const mqtt = require('mqtt');
const crypto = require('crypto');

// Configuración
const mqttBroker = 'mqtt://localhost:1883';
const fastifyPort = 3000; // Puerto en el que Fastify escuchará las solicitudes

// Base de Datos de Dispositivos (¡Reemplaza con una base de datos real!)
const devices = {
    '5E9D1E0857CF25F1': { // DevEUI
        appEUI: '5E9D1E0857CF25F1', // AppEUI
        appKey: 'F921D50CD7D02EE3C5E6142154F274B2' // AppKey
    }
};

// Funciones Auxiliares
function generateSessionKeys(appKey, appNonce, devNonce, netID, devAddr) {
    // **IMPORTANTE:** Implementa el algoritmo de derivación de claves de LoRaWAN aquí
    // (Este es un ejemplo simplificado, ¡NO USAR EN PRODUCCIÓN!)
    const nwkSKey = crypto.randomBytes(16).toString('hex').toUpperCase();
    const appSKey = crypto.randomBytes(16).toString('hex').toUpperCase();
    return { nwkSKey, appSKey };
}

// Inicialización del Cliente MQTT
const mqttClient = mqtt.connect(mqttBroker);

mqttClient.on('connect', () => {
    console.log('Conectado al broker MQTT');
});

mqttClient.on('error', (err) => {
    console.error('Error en MQTT:', err);
});

// **IMPORTANTE:** Define una ruta para recibir los mensajes del gateway REALIZAR
//METODO COMPLETO
fastify.post('/lorawan/gateway', async (request, reply) => {
    const gatewayData = request.body; // Los datos del gateway estarán en el cuerpo de la solicitud
    console.log('Mensaje recibido del gateway:', gatewayData);

    // **IMPORTANTE:** Implementa la lógica para procesar los mensajes del gateway
    // Deserializar el mensaje (formato Semtech UDP o el formato que use tu gateway)
    // Identificar el tipo de mensaje (JOIN_REQUEST, UPLINK, etc.)

    // **Ejemplo Simplificado (Solo para Ilustración):**
    // Asumiendo que el gateway envía el MHDR en un campo llamado "mhdr"
    const mhdr = gatewayData.mhdr;

    if (mhdr === '00') { // 00 indica Join Request (¡Esto es una simplificación!)
        // Proceso de Unión OTAA
        handleJoinRequest(gatewayData); // Pasa los datos del gateway a la función
    } else {
        // Proceso de Mensaje Uplink
        handleUplinkMessage(gatewayData); // Pasa los datos del gateway a la función
    }

    reply.send({ status: 'ok' }); // Envía una respuesta al gateway
});

// Funciones para Manejar los Diferentes Tipos de Mensajes

function handleJoinRequest(gatewayData) {
    console.log('Procesando Join Request...');

    // **IMPORTANTE:** Implementa la lógica para extraer DevEUI, AppEUI y DevNonce del mensaje
    // (Esto requiere conocer el formato del Join Request de LoRaWAN)
    // Asumiendo que el gateway envía estos datos en campos llamados "devEUI", "appEUI" y "devNonce"
    const devEUI = gatewayData.devEUI; // Reemplaza con la lógica de extracción real
    const appEUI = gatewayData.appEUI; // Reemplaza con la lógica de extracción real
    const devNonce = gatewayData.devNonce; // Reemplaza con la lógica de extracción real

    // Autenticación del Dispositivo
    if (devices[devEUI] && devices[devEUI].appEUI === appEUI) {
        console.log('Dispositivo autenticado');

        // Generación de Claves de Sesión
        const { appKey } = devices[devEUI];
        const { nwkSKey, appSKey } = generateSessionKeys(appKey, 'appNonce', devNonce, 'netID', 'devAddr');

        console.log('NwkSKey:', nwkSKey);
        console.log('AppSKey:', appSKey);

        // **IMPORTANTE:** Implementa la lógica para crear y enviar el Join Accept
        // (Esto requiere conocer el formato del Join Accept de LoRaWAN)
        console.log('Enviando Join Accept...');
        // ...

        // Almacena las claves de sesión para el dispositivo
        devices[devEUI].nwkSKey = nwkSKey;
        devices[devEUI].appSKey = appSKey;

    } else {
        console.log('Dispositivo no autenticado');
        // **IMPORTANTE:** Implementa la lógica para rechazar la solicitud de unión
        // ...
    }
}

function handleUplinkMessage(gatewayData) {
    console.log('Procesando Mensaje Uplink...');

    // **IMPORTANTE:** Implementa la lógica para extraer DevEUI, datos encriptados, etc.
    // Asumiendo que el gateway envía estos datos en campos llamados "devEUI" y "encryptedPayload"
    const devEUI = gatewayData.devEUI; // Reemplaza con la lógica de extracción real
    const encryptedPayload = gatewayData.encryptedPayload; // Reemplaza con la lógica de extracción real

    // Desencriptación del Mensaje
    if (devices[devEUI] && devices[devEUI].nwkSKey && devices[devEUI].appSKey) {
        const { nwkSKey, appSKey } = devices[devEUI];

        // **IMPORTANTE:** Implementa la lógica para desencriptar el payload
        // (Esto requiere conocer el algoritmo de desencriptación de LoRaWAN)
        const decryptedPayload = '...'; // Reemplaza con la lógica de desencriptación real

        // Publicación de Datos en MQTT
        const deviceId = devEUI;
        const data = {
            temperature: 25.5,
            humidity: 60.2
        };
        const topic = `lorawan/devices/${deviceId}/data`;
        mqttClient.publish(topic, JSON.stringify(data));

        console.log(`Datos publicados en MQTT: ${topic}`);

    } else {
        console.log('Dispositivo no autenticado o claves de sesión no disponibles');
        // **IMPORTANTE:** Implementa la lógica para rechazar el mensaje
        // ...
    }
}

// Ejecutar el servidor Fastify
const start = async () => {
    try {
        await fastify.listen({ port: fastifyPort });
    } catch (err) {
        fastify.log.error(err);
        process.exit(1);
    }
};

start();

console.log('Servidor LoRaWAN iniciado con Fastify');