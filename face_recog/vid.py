#!/usr/bin/python

import cv2
import serial

ser = serial.Serial('/dev/ttyUSB1', 115200)
face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')

cap = cv2.VideoCapture('aggy_test.mp4')

fourcc = cv2.VideoWriter_fourcc(*'XVID')
out = cv2.VideoWriter('output.mkv', fourcc, 20.0, (720,480))
if not cap.isOpened():
    print("no vid")
    exit()

while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        print("Can't receive frame (stream end?). Exiting ...")
        break
    grey = cv2.cvtColor(frame,cv2.COLOR_BGR2GRAY)
    faces = face_cascade.detectMultiScale(grey, 1.3, 5)
    for (x, y, w, h) in faces:
        cv2.circle(frame, (x+(w//2), y+(h//2)), 5, (255, 0, 255), -1)
#        print(x+(w/2), y+(h/2))
    cv2.line(frame, (0, 180), (720, 180), (255, 0, 255), 5)
    cv2.line(frame, (0, 300), (720, 300), (255, 0, 255), 5)
    cv2.line(frame, (280, 0), (280, 480), (255, 0, 255), 5)
    cv2.line(frame, (440, 0), (440, 480), (255, 0, 255), 5)
#   cv2.rectangle(frame, (280, 180), (440, 300), (255,0,255),5)
    if x+(w//2) < 280:
        ser.write(b'1')
        print("right")
    elif x+(w//2) > 440:
        ser.write(b'2')
        print("left")
    else:
        ser.write(b'3')
        print("x stop")

    if y+(h//2) < 180:
        ser.write(b'1')
        print("up")
    elif y+(h//2) > 300:
        ser.write(b'3')
        print("down")
    else:
        ser.write(b'2')
        print("y stop")

    cv2.waitKey(30)

    out.write(frame)
    cv2.imshow('frame', frame)

    if cv2.waitKey(1) == ord('q'):
        break

cap.release()
ser.close()
cv2.destroyAllWindows()

