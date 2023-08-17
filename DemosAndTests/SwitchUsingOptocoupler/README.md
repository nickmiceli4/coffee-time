# Demo: 
## Activate Push Button Switch using Optocoupler

### Reason for Demo
The purpose of this demo is to show that a push button switch can be activated ("pushed") using an Optocoupler. The concept demonstrated here will later be used
to activate the switches on the coffee maker via the Arduino.

### Explanation of Circuit
The circuit begins with an LED being activated by a push button. One side of the button is connected to 5v of power through a 220 Ohm resistor. The other side is
connected to ground through an LED. This allows the LED to be turned on by pressing the button. 

Then an Optocoupler is added to the circuit. The 1 pin on the Optocoupler is connected to the 2 pin on the Arduino through a 220 Ohm resistor, and the 2 Pin on the Optocoupler is connected to ground.
This allows the Arduino to tell the Optocoupler when to activate. Then, the 4 and 5 pins on the Optocoupler are connected to the ground and power sides of the switch respectively. 

### Arduino Sketch
The Arduino code simply tells the Optocoupler to alternate between off and on every two seconds, and because it is wired to the button this turns the LED on and off as well.
Therefore this demo shows that the Optocoupler can activate a button without actually needing to press it.
