#!/bin/bash
#
# This script is for the bash lab on variables, dynamic data, and user input
# Download the script, do the tasks described in the comments
# Test your script, run it on the production server, screenshot that
# Send your script to your github repo, and submit the URL with screenshot on Blackboard

# Get the current hostname using the hostname command and save it in a variable
OUTPUT="$(hostname)"
# Tell the user what the current hostname is in a human friendly way
echo "Hey there!, the hostname is ... ${OUTPUT} :)"
# Ask for the user's student number using the read command
studentnum="Enter your student number!"
read -p "$studentnum" studentnumber1
# Use that to save the desired hostname of pcNNNNNNNNNN in a variable, where NNNNNNNNN is the student number entered by the user

# If that hostname is not already in the /etc/hosts file, change the old hostname in that file to the new name using sed or something similar and
#     tell the user you did that
 sed -i "s/$OUTPUT/$studentnumber1/" /etc/hosts
echo "We changed your hostname to $studentnumber1"


# If that hostname is not the current hostname, change it using the hostnamectl command and
#     tell the user you changed the current hostname and they should reboot to make sure the new name takes full effect
hostnamectl set-hostname $studentnumber1
echo "Current hostname had been changed. Please reboot to make sure the new name takes full effect"
