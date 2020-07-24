#!/usr/bin/python

import cv2 # Computer Vision
import serial # Serial Communication with GoBoard

# Open Port with GoBoard at 115200 Baud
ser = serial.Serial('/dev/ttyUSB1', 115200)

# Use intel face haar cascade for face regognition
face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')

# Grab video from webcam
cap = cv2.VideoCapture(0)


# Honestly have no clue. Use codec or somthing for video recording
#fourcc = cv2.VideoWriter_fourcc(*'XVID')

# Set var and output file for the recording of the captured frames
# at 20 fps and 720x480 resolution
#out = cv2.VideoWriter('output.mkv', fourcc, 20.0, (720,480))

# I think if wecam is not found exit?
if not cap.isOpened():
    print("no vid")
    exit()
        
# counter for positives
count = 0

# while webcam is recording
while cap.isOpened():

    #set var for captured frames from webcam
    ret, frame = cap.read()
    if not ret:
        print("Can't receive frame (stream end?). Exiting ...")
        break

    # save greyscaled frame to grey
    grey = cv2.cvtColor(frame,cv2.COLOR_BGR2GRAY)

    # save array of rectangles of found faces into var faces
    faces = face_cascade.detectMultiScale(grey, 1.3, 5)

    # if no faces dont move
    if len(faces) == 0:
        ser.write(b'2')
        print("x stop")
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

        cv2.circle(frame, (x+(w//2), y+(h//2)+150), 5, (255, 0, 255), -1)
        
        # Image thresholds for aiming
#        print(x+(w/2), y+(h/2))
        if x+(w//2) < 280:
            ser.write(b'1')
            print("right")
        elif x+(w//2) > 440:
            ser.write(b'3')
            print("left")
        else:
            ser.write(b'2')
            print("x stop")
            if count >= 10:
                print("fire")
        count += 1


#       if y+(h//2) < 180:
#           ser.write(b'1')
#           print("up")
#       elif y+(h//2) > 300:
#           ser.write(b'3')
#           print("down")
#       else:
#           ser.write(b'2')
#           print("y stop")



#   Aiming quadrents
    cv2.line(frame, (0, 180), (720, 180), (255, 0, 255), 5)
    cv2.line(frame, (0, 300), (720, 300), (255, 0, 255), 5)
    cv2.line(frame, (280, 0), (280, 480), (255, 0, 255), 5)
    cv2.line(frame, (440, 0), (440, 480), (255, 0, 255), 5)



    # write frame to output file for record
    #out.write(frame)

    # output frame to screen
    cv2.imshow('frame', frame)


    # press q to quit recording
    if cv2.waitKey(1) == ord('q'):
        break

# clean up
cap.release()
ser.close()
cv2.destroyAllWindows()

