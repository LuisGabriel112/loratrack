/***
 *  Este ejemplo combina la funcionalidad LoRaWAN OTAA con la recolección de datos GPS para RAK3172.
 *  Se une a la red en modo OTAA, clase A, región EU868.
 *  El dispositivo envía datos GPS cada 20 segundos.
 ***/

#include <TinyGPSPlus.h>
TinyGPSPlus gps;

#define OTAA_PERIOD   (20000)

/*************************************

   Configuración de la banda LoRaWAN:
     RAK_REGION_EU433
     RAK_REGION_CN470
     RAK_REGION_RU864
     RAK_REGION_IN865
     RAK_REGION_EU868
     RAK_REGION_US915
     RAK_REGION_AU915
     RAK_REGION_KR920
     RAK_REGION_AS923

 *************************************/
#define OTAA_BAND     (RAK_REGION_US915)
#define OTAA_DEVEUI   {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x88}
#define OTAA_APPEUI   {0x0E, 0x0D, 0x0D, 0x01, 0x0E, 0x01, 0x02, 0x0E}
#define OTAA_APPKEY   {0x2B, 0x7E, 0x15, 0x16, 0x28, 0xAE, 0xD2, 0xA6, 0xAB, 0xF7, 0x15, 0x88, 0x09, 0xCF, 0x4F, 0x3E}

/** Buffer de paquetes para enviar */
uint8_t collected_data[64] = { 0 };

void recvCallback(SERVICE_LORA_RECEIVE_T * data)
{
    if (data->BufferSize > 0) {
        Serial.println("¡Algo recibido!");
        for (int i = 0; i < data->BufferSize; i++) {
            Serial.printf("%x", data->Buffer[i]);
        }
        Serial.print("\r\n");
    }
}

void joinCallback(int32_t status)
{
    Serial.printf("Estado de unión: %d\r\n", status);
}

void sendCallback(int32_t status)
{
    if (status == 0) {
        Serial.println("Enviado con éxito");
    } else {
        Serial.println("Envío fallido");
    }
}

void setup()
{
    Serial.begin(115200, RAK_AT_MODE);
    Serial1.begin(9600);

    Serial.println("Ejemplo RAKwireless LoRaWan OTAA con GPS");
    Serial.println("------------------------------------------------------");

  // Habilita la alimentación para el sensor externo
    pinMode(PB5, OUTPUT);
    digitalWrite(PB5, HIGH);
    while (Serial1.available()) {
        Serial1.read();
    }

    if(api.lorawan.nwm.get() != 1)
    {
        Serial.printf("Establecer el modo de trabajo del dispositivo nodo %s\r\n",
            api.lorawan.nwm.set(1) ? "Éxito" : "Fallo");
        api.system.reboot();
    }

    // OTAA Device EUI MSB primero
    uint8_t node_device_eui[8] = OTAA_DEVEUI;
    // OTAA Application EUI MSB primero
    uint8_t node_app_eui[8] = OTAA_APPEUI;
    // OTAA Application Key MSB primero
    uint8_t node_app_key[16] = OTAA_APPKEY;

    if (!api.lorawan.appeui.set(node_app_eui, 8)) {
        Serial.printf("LoRaWan OTAA - ¡la configuración de la aplicación EUI es incorrecta! \r\n");
        return;
    }
    if (!api.lorawan.appkey.set(node_app_key, 16)) {
        Serial.printf("LoRaWan OTAA - ¡la configuración de la clave de la aplicación es incorrecta! \r\n");
        return;
    }
    if (!api.lorawan.deui.set(node_device_eui, 8)) {
        Serial.printf("LoRaWan OTAA - ¡la configuración del dispositivo EUI es incorrecta! \r\n");
        return;
    }

    if (!api.lorawan.band.set(OTAA_BAND)) {
        Serial.printf("LoRaWan OTAA - ¡la configuración de la banda es incorrecta! \r\n");
        return;
    }
    if (!api.lorawan.deviceClass.set(RAK_LORA_CLASS_A)) {
        Serial.printf("LoRaWan OTAA - ¡la configuración de la clase de dispositivo es incorrecta! \r\n");
        return;
    }
    if (!api.lorawan.njm.set(RAK_LORA_OTAA))	// Establecer el modo de unión a la red a OTAA
    {
        Serial.printf("LoRaWan OTAA - ¡la configuración del modo de unión a la red es incorrecta! \r\n");
        return;
    }
    if (!api.lorawan.join())	// Unirse a la pasarela
    {
        Serial.printf("LoRaWan OTAA - ¡fallo al unirse! \r\n");
        return;
    }

    /** Esperar a que la unión sea exitosa */
    while (api.lorawan.njs.get() == 0) {
        Serial.print("Esperar a la unión LoRaWAN...");
        api.lorawan.join();
        delay(10000);
    }

    if (!api.lorawan.adr.set(true)) {
        Serial.printf("LoRaWan OTAA - ¡la configuración de la tasa de datos adaptativa es incorrecta! \r\n");
        return;
    }
    if (!api.lorawan.rety.set(1)) {
        Serial.printf("LoRaWan OTAA - ¡la configuración del número de reintentos es incorrecta! \r\n");
        return;
    }
    if (!api.lorawan.cfm.set(1)) {
        Serial.printf("LoRaWan OTAA - ¡la configuración del modo de confirmación es incorrecta! \r\n");
        return;
    }

    /** Comprobar el estado de LoRaWan */
    Serial.printf("El ciclo de trabajo es %s\r\n", api.lorawan.dcs.get()? "ON" : "OFF");	// Comprobar el estado del ciclo de trabajo
    Serial.printf("El paquete es %s\r\n", api.lorawan.cfm.get()? "CONFIRMADO" : "NO CONFIRMADO");	// Comprobar el estado de confirmación
    uint8_t assigned_dev_addr[4] = { 0 };
    api.lorawan.daddr.get(assigned_dev_addr, 4);
    Serial.printf("La dirección del dispositivo es %02X%02X%02X%02X\r\n", assigned_dev_addr[0], assigned_dev_addr[1], assigned_dev_addr[2], assigned_dev_addr[3]);	// Comprobar la dirección del dispositivo
    Serial.printf("El periodo de enlace ascendente es %ums\r\n", OTAA_PERIOD);
    Serial.println("");
    api.lorawan.registerRecvCallback(recvCallback);
    api.lorawan.registerJoinCallback(joinCallback);
    api.lorawan.registerSendCallback(sendCallback);
}

void uplink_routine()
{
    float gps_lat = gps.location.lat();
    float gps_lng = gps.location.lng();
    float gps_speed = gps.speed.mps();

    /** Carga útil del enlace ascendente */
    uint8_t data_len = 0;

    // Añadir latitud (4 bytes)
    memcpy(collected_data + data_len, &gps_lat, 4);
    data_len += 4;

    // Añadir longitud (4 bytes)
    memcpy(collected_data + data_len, &gps_lng, 4);
    data_len += 4;

    // Añadir velocidad (2 bytes - convertir float a uint16_t después de escalar)
    uint16_t scaled_speed = (uint16_t)(gps_speed * 100); // Escalar a cm/s
    memcpy(collected_data + data_len, &scaled_speed, 2);
    data_len += 2;

    Serial.println("Paquete de datos:");
    for (int i = 0; i < data_len; i++) {
        Serial.printf("0x%02X ", collected_data[i]);
    }
    Serial.println("");

    /** Enviar el paquete de datos */
    if (api.lorawan.send(data_len, (uint8_t *) & collected_data, 2, true, 1)) {
        Serial.println("Se solicitó el envío");
    } else {
        Serial.println("Envío fallido");
    }
}

void loop()
{
    static uint64_t last = 0;
    static uint64_t elapsed;

    while (Serial1.available() > 0) {
        gps.encode(Serial1.read());
    }

    if ((elapsed = millis() - last) > OTAA_PERIOD) {
        uplink_routine();

        last = millis();
    }
    api.system.sleep.all(OTAA_PERIOD);
}