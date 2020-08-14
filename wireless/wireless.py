#!/usr/bin/python3

import numpy
import serial

i_ser = serial.Serial('/dev/rfcomm0', 9600)
o_ser = serial.Serial('/dev/ttyUSB1', 115200)

while i_ser.is_open:
    try:
        data = i_ser.read() 
    except serial.SerialException as e:
        print("Connection Dropped")
        exit()

    o_ser.write(data)
