#include "WiFi.h"

#define WIFI_NETWORK "JNMHome"
#define WIFI_PASSWORD "Patsfans68!"
#define WIFI_TIMEOUT_MS 20000

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
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  while(!Serial){
    delay(100);
  }
  connectWiFi();
}

void loop() {
  // put your main code here, to run repeatedly:

}
