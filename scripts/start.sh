#!/bin/bash

rfcomm watch hci0 &

while true; do
	./state_change.py
done

