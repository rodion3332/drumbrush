This repository contains code for 3 different parts of the project that are meant to be combined:

Arduino > Wekinator > Processing 3

1. Arduino
The Arduino code reads inputs from 6 piezo sensors and sends them to a COM port

2. Wekinator
The Wekinator input program reads the Piezo values from the COM port. The Wekinator program (which as to be open) is used to
train a neural network by recording values from the COM port and providing an output based on the value (the user trains this
through the Wekinator UI)

3. Processing 3
The Processing code imports the live values from Wekinator and applies the output variables created in Wekinator to a 'brush'.
The brush is a png image of a brush stroke which draws at 60 frames per second across the screen (when sound is detected through
a USB microphone). That way the brush only paints when an appropriate amplitude of sound is registered. The brush has 
modifiers such as size, color, and position, which are picked up as outputs from Wekinator. All this happens live. 