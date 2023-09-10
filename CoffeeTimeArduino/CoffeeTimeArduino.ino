void(* resetFunc) (void) = 0;
#include "WiFi.h"

#define WIFI_NETWORK "weefee"
#define WIFI_PASSWORD "ALNM9899"
#define WIFI_TIMEOUT_MS 20000

#define POWER_LED A0
#define BREWING_LED A1
#define HEAT_LED A2
#define WATER_LED A3

#define BREW_BUTTON 2
#define LID_SWITCH 3
#define POWER_BUTTON 4
#define RED_LED_PIN 9
#define BLUE_LED_PIN 10
#define GREEN_LED_PIN 11
#define MUG_READ 12

WiFiServer server(80);
WiFiClient client;

String machineStatus = "READY";
bool mugPlaced = false;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  while(!Serial){
    delay(100);
  }
  connectWiFi();
  server.begin();

  pinMode(BREW_BUTTON, OUTPUT);
  pinMode(LID_SWITCH, OUTPUT);
  pinMode(POWER_BUTTON, OUTPUT);
  pinMode(RED_LED_PIN, OUTPUT);
  pinMode(BLUE_LED_PIN, OUTPUT);
  pinMode(GREEN_LED_PIN, OUTPUT);
  pinMode(MUG_READ, INPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  client = server.available();
  checkForMug();

  if(client){
    Serial.println("client connected");
    if(client.available()){
      String request = client.readStringUntil('\r');
      Serial.println(request);
      // App is requesting to Brew
      if(request.indexOf("/brew/1") != -1){ 
        //CHANGE BACK AHJHHHHHHHHHHhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh. !
        if(mugPlaced){
          //Send message for no mug and restart
          writeToClient("NO_MUG");
          goto disconnect;
        }
        //Check power LED
        bool powerLEDOn = updateLEDStatus(0);
        //If off press power button
        if(!powerLEDOn){
          digitalWrite(POWER_BUTTON, HIGH);
          delay(100);
          digitalWrite(POWER_BUTTON, LOW);
        }
        //Check water LED 
        bool waterLEDOn = updateLEDStatus(3);
        //If on send message and reset
        if(waterLEDOn){
          writeToClient("ADD_WATER");
          goto disconnect;
        } else{
          //Check heat LED
          bool heatLEDOn = updateLEDStatus(2);
          //If heating notify app and wait for next client
          if(heatLEDOn){
            writeToClient("HEATING");
            getNewClient();
          }
          //Wait for heating LED to turn off.           CHANGE BACK KABDSHFKABKFBEQAKBFSKBHAEFKBAEFKDBNAOKBFKFBKABEFKBAKF
          //while(heatLEDOn){
          //  delay(500);
           // heatLEDOn = updateLEDStatus(2);
          //}
          //Toggle Lid
          delay(3000);
          digitalWrite(LID_SWITCH, HIGH);
          delay(500);
          digitalWrite(LID_SWITCH, LOW);
          //Press brew button
          delay(2000);
          digitalWrite(BREW_BUTTON, HIGH);
          delay(500);
          digitalWrite(BREW_BUTTON, LOW);
          //Once off say brewing
          writeToClient("BREWING");
          getNewClient();

          bool brewLEDOn = updateLEDStatus(1);

          while(brewLEDOn){
            delay(500);
            brewLEDOn = updateLEDStatus(1);
          }
          //once brewing light off say done
          writeToClient("DONE_BREWING");
          //power off
          digitalWrite(POWER_LED, HIGH);
          delay(500);
          digitalWrite(POWER_LED, LOW);
        }
      } else if (request.indexOf("/brew/0") != -1){
        writeToClient("READY");
      }
    }
disconnect:
    Serial.println("client disconnected");
  }

  delay(1000);
}

void writeToClient(String machineStatus){
  while(client.available()){
    char c = client.read();
    Serial.print(c);
  }
  Serial.print("\nDone Reading\n");
  client.println("HTTP/1.1 200 OK");
  client.println("Content-Type: application/json;charset=utf-8");
  client.println("Server: Arduino");
  client.println("Connnection: close");
  client.println();
  client.print("{\"time\":\"");
  client.print(millis() / 1000);
  client.print("\",\"machineStatus\":\"");
  client.print(machineStatus);
  client.print("\"}");
  client.println();
  client.stop();
}

void getNewClient(){
  for(int i = 0; i < 10; i++){
    //Check for new client
    client = server.available();
    //If client is found then return
    if(client){
      return;
    }
    delay(1000);
  }
  // If no new client is found after 10 seconds reset sketch
  resetFunc();
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
    resetFunc();
  }else{
    Serial.print("\nConnected, IP: ");
    Serial.println(WiFi.localIP());
  }
}

void checkForMug(){
  bool checkMug = digitalRead(MUG_READ);
  // The mug status was changed since we last checked
  if(checkMug != mugPlaced){
    // update global mug status
    mugPlaced = checkMug;
    if(checkMug){
      // Blink LED Green twice
      int brightness = 0;
      int fadeAmount = 5;

      for(int i = 0; i < 4;){
        analogWrite(GREEN_LED_PIN, brightness);
        brightness += fadeAmount;
        if(brightness <= 0 || brightness >= 255){
          fadeAmount = -fadeAmount;
          i++;
        }
        delay(7);
      }

      analogWrite(GREEN_LED_PIN, 0);
    } else{
      // Blink LED Red twice
      int brightness = 0;
      int fadeAmount = 5;

      for(int i = 0; i < 4;){
        analogWrite(RED_LED_PIN, brightness);
        brightness += fadeAmount;
        if(brightness <= 0 || brightness >= 255){
          fadeAmount = -fadeAmount;
          i++;
        }
        delay(7);
      }

      analogWrite(RED_LED_PIN, 0);
    }
  }
}

// Param LED: 0 for Power, 1 for Brewing, 2 for Heating, 3 for Water
bool updateLEDStatus(int LED){
  //TODO: read LED voltage to determine if on.
  if(LED == 0){
    return true;
  } else if (LED == 1){
    return false;
  } else if (LED == 2){
    return true;
  } else{
    return false;
  }
}
