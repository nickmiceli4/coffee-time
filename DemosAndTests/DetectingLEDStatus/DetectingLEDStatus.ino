void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  float voltage = (analogRead(A0)*5.0)/1024.0;
  
  if(voltage >= 2.75){
    Serial.print("LED is on\n");
  } else{
    Serial.print("\rLED is off\n");
  }
  delay(1000);
}
