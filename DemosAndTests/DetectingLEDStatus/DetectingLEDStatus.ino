void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  float voltage = (analogRead(A7)*5.0)/4095.0;
  
  Serial.println(voltage);
  delay(1000);
}
