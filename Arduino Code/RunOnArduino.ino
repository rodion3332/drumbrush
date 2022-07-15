// Code originally from http://www.instructables.com/id/Arduino-to-Processing-Serial-Communication-withou/
// by https://www.instructables.com/member/thelostspore/
// Code was shared under public domain https://creativecommons.org/licenses/publicdomain/
//modified for Drumbrush by Rodion Galiullin

// This code reads analog inputs from pins A0 and A1 and sends these values out via serial
// You can add or remove pins to read from, but be sure they are separated by commas, and print a
// newline character at the end of each loop()
//
int AnalogPin0 = A0; //Declare an integer variable, hooked up to analog pin 0
int AnalogPin1 = A1; //Declare an integer variable, hooked up to analog pin 1
int AnalogPin2 = A2;
int AnalogPin3 = A3;
int AnalogPin4 = A4;
int AnalogPin5 = A5;

void setup() {
  Serial.begin(9600); //Begin Serial Communication with a baud rate of 9600
}

void loop() {
   //New variables are declared to store the readings of the respective pins
  int Value1 = analogRead(AnalogPin0);
  int Value2 = analogRead(AnalogPin1);
  int Value3 = analogRead(AnalogPin2);
  int Value4 = analogRead(AnalogPin3);
  int Value5 = analogRead(AnalogPin4);
  int Value6 = analogRead(AnalogPin5);
  
  /*The Serial.print() function does not execute a "return" or a space
      Also, the "," character is essential for parsing the values,
      The comma is not necessary after the last variable.*/
  
  Serial.print(Value1, DEC); 
  Serial.print(",");
  Serial.print(Value2, DEC); 
  Serial.print(",");
  Serial.print(Value3, DEC);
  Serial.print(",");
  Serial.print(Value4, DEC);
  Serial.print(",");
  Serial.print(Value5, DEC);
  Serial.print(",");
  Serial.print(Value6, DEC);
  Serial.println();
  //delay(500); // For illustration purposes only. This will slow down your program if not removed 
}
