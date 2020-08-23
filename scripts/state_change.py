#!/usr/bin/python3

import cv2
import serial
import os.path
from os import path

# check if bluetooth is connected
#bluetooth_path = Path("/dev/rfcomm0")

# output device
o_ser = serial.Serial('/dev/ttyUSB1', 115200)

# Use intel face haar cascade for face regognition
face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')

# Grab video from webcam
cap = cv2.VideoCapture(0)

# if no cam exit
if not cap.isOpened():
    print("no video")
    exit()

 
# counter for positives
count = 0


   
def main():
    
    
    # state 0 = auto
    # state 1 = man
    state = 0;
    while cap.isOpened():
        # transitions
        if(state == 0):
            try:
                i_ser = serial.Serial('/dev/rfcomm0', 9600)#,timeout=0)
                #on = i_ser.read()
                #print(on)
                #if (on == b'\x20'):
                #i_ser.timeout = None
                state = 1
                #else:
                #    state = 0
            except serial.SerialException as e:
                state = 0
        
        elif(state == 1):
            try:
                i_ser.timeout = 0
                on = i_ser.read()
                #print(on)
                #if (on == b'\x20'):
                #    state = 0
                #else:
                i_ser.timeout = None 
                state = 1
            except serial.SerialException as e:
                exit()
                state = 0
        
        else:
            state = 0
        
        # actions
        if (state == 0):
            image_proc()
        
        elif (state == 1):
            try:
                data = i_ser.read()
                o_ser.write(data)
            except serial.SerialException as e:
                continue
        print(state)
    



# image proc
def image_proc():
    global count
    # if aimed at target
    x_true = 0;
    y_true = 0;

    #set var for captured frames from webcam
    ret, frame = cap.read()
    if not ret:
        print("Can't receive frame (stream end?). Exiting ...")
        exit()

    # save greyscaled frame to grey
    grey = cv2.cvtColor(frame,cv2.COLOR_BGR2GRAY)

    # save array of rectangles of found faces into var faces
    faces = face_cascade.detectMultiScale(grey, 1.3, 5)

    hex_pos = 0x00

    # if no faces dont move
    if len(faces) == 0:
        #print("x stop")
        #print("y stop")
        count = 0

    # var for biggest face calc
    max_object = 0;
    index = -1
    i = 0;
    # Check for biggest face for steady target
    for (x, y, w, h) in faces:
        if w*h > max_object:
            max_object = w*h
            index = i
        i += 1

    # put a dot in the middle of the rectangle  
    if len(faces) != 0:
        x, y, w, h = faces[index][0], faces[index][1], faces[index][2], faces[index][3]
        ny = y + 60;

        cv2.circle(frame, (x+(w//2), ny+(h//2)), 5, (255, 0, 255), -1)

        # Image thresholds for aiming
        print(x+(w/2), y+(h/2))

        # x aim
        if x+(w//2) < 280:
            hex_pos = hex_pos | 0x01
            #print("right")
        elif x+(w//2) > 440:
            hex_pos = hex_pos | 0x02
            #print("left")
        else:
            #print("x stop")
            x_true = 1;

        # y aim
        if ny+(h//2) < 180:
            hex_pos = hex_pos | 0x04
            #print("up")
        elif ny+(h//2) > 300:
            hex_pos = hex_pos | 0x08
            #print("down")
        else:
            #print("y stop")
            y_true = 1;


        if count >= 4 and x_true and y_true:
            hex_pos = hex_pos | 0x10
            #print("fire")

    packet = bytearray()
    packet.append(hex_pos)

    #print(bin(hex_pos))

    o_ser.write(packet)

    count += 1

    # press q to quit recording
    if cv2.waitKey(1) == ord('q'):
        exit()

main()
