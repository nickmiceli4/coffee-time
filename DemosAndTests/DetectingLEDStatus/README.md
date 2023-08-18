# Demo:
## Detecting on/off status of LED

### Reason for Demo
The purpose of this demo is to show that I can determine whether an LED is on or off by reading the voltage coming through it using the Arduino. This concept will be applied
to the project to check the coffee maker's power LED (to determine if the machine is turned on), and to know when the brewing LED turns off (to know when the coffee is ready).

### Description of Circuit
The circuit has a push button connected to the 5 volt power supply of the Arduino through a 220 Ohm resistor. The other side of the button is connected to ground through an LED;
therefore, the LED can be turned on by pressing the button. The anode of the LED is also connected to the A0 analog pin on the Arduino which allows the voltage to be read.

### Arduino Sketch
The sketch for this demo reads the voltage flowing through the LED once every second, then depending on if the voltage is above or below a certain threshold the code prints
that the LED is on or off. The demo video shows that the output changes from "LED is off" to "LED is on" appropriately when the button is pressed and the LED is turned on.
