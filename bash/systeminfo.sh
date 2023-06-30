#!/bin/bash

#Connor Tremblay 200451942

#Source original file
source ~/COMP2101/bash/reportfunctions.sh

#Tests for root using if/else statument and "EUID" and exits if flase.
if [[ "$EUID" = 0 ]]; then
    echo "Proceed..."
else
    sudo -k 
    if sudo true; then
        echo "Correct Password"
    else
        echo "Wrong Password, This script must be run as root. GoodBye :)"
        exit 1
    fi
fi

#List of functions
cpureport
computerreport
osreport
ramreport
videoreport
diskreport
networkreport
