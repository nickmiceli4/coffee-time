#include "WiFi.h"

#define WIFI_NETWORK "JNMHome"
#define WIFI_PASSWORD "Patsfans68!"
#define WIFI_TIMEOUT_MS 20000

WiFiServer server(80);
int tmSec = 0;

bool heatLED = false;
bool powerLED = false;
bool brewLED = false;
bool waterLED = false;

String machineStatus = "READY";

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  while(!Serial){
    delay(100);
  }
  connectWiFi();
  server.begin();
}

void loop() {
  // put your main code here, to run repeatedly:
  WiFiClient client = server.available();
  if(client){
    Serial.println("client connected");
    boolean currentLineBlank = true;
    while(client.connected()){
      if(client.available()){
        char c = client.read();
        Serial.write(c);
        if(c == '\n' && currentLineBlank){
          client.println("HTTP/1.1 200 OK");
          client.println("Content-Type: application/json;charset=utf-8");
          client.println("Server: Arduino");
          client.println("Connnection: close");
          client.println();
          client.print("{\"time\":\"");
          client.print(tmSec);
          client.print("\",\"machineStatus\":\"");
          client.print(machineStatus);
          client.print("\"}");
          client.println();
          break;
        }
        if(c == '\n'){
          currentLineBlank = true;
        } else if(c != '\r'){
          currentLineBlank = false;
        }
      }
    }
    client.stop();
    Serial.println("client disconnected");
  }

  delay(1000);
  tmSec++;
  if(tmSec == 60){
    machineStatus = "HEATING";
  }else if(tmSec == 75){
    machineStatus = "BREWING";
  }else if(tmSec == 90){
    machineStatus = "DONE_BREWING";
  }else if (tmSec == 105){
    machineStatus = "ADD_WATER";
  }
}

void connectWiFi(){
  Serial.print("Connecting to WiFi");
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_NETWORK, WIFI_PASSWORD);

  unsigned long startAttemptTime = millis();

  while(WiFi.status() != WL_CONNECTED && millis() - startAttemptTime < WIFI_TIMEOUT_MS){
    Serial.print(".");
    delay(500);
  }

  if(WiFi.status() != WL_CONNECTED){
    Serial.println("\nFailed to connect...");
  }else{
    Serial.print("\nConnected, IP: ");
    Serial.println(WiFi.localIP());
  }
}

String updateLEDStatus(){
    //TODO: read LED voltage to determine if on.
    return "POWER_OFF";
}
