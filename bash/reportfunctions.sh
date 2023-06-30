#!/bin/bash
#Final Script Assignment Connor Tremblay 200451942

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

#This function showslabeled data showing CPU manufacturer and model, CPU architecture, CPU core count
#CPU maximum speed in a human friendly format
#Sizes of caches (L1, L2, L3) in a human friendly format

echo "Function #1 - CPU Report"
#This function states some information about your computers CPU.
function cpureport {
#Searches for CPU informartion and uses grep to show line including model name
#Gets rid of the space before the line
lscpu | grep 'Model name' | awk '{$1=$1}1'
echo "CPU Cores: $(grep -c ^processor /proc/cpuinfo)"

#Searches for specified key wordsand remove the space before line
cachesize=$(lscpu | grep 'L1d\|L2\|L3\|L1i' | awk '{$1=$1}1')
#list all cache sizes in a friendly manor
echo -e "Cache Sizes:\n$cachesize"
}
cpureport
#End




#This function will show some information about the computer (manufactuer, serial number, 
function computerreport {

echo "Function #2 - Computer Report"
#Uses sudo privileges and uses dmidecode to display some system information
#filtered using grep and saves in a variable
sudo dmidecode | grep -A3 '^System Information'

#Displays the systems serialnumber and saves in a variable
snum=$(sudo dmidecode -s system-serial-number)
echo -e "System Serial Number: $snum"
}
computerreport
#End




#This function will show information regarding the firmware ditribution 
function osreport {

echo "Function #3 - Distro Info"
#Searches for defined information and saves to variable
distroinfo=$(cat /etc/os-release | grep "PRETTY_NAME\|NAME")

#replaces some text to be presented more friendly
distroinfo=$(sed "s/PRETTY_NAME/DISTRO VERSION/" <<< "$distroinfo")
distroinfo=$(sed "s/NAME/DISTRO/" <<< "$distroinfo")

echo "$distroinfo"
}
osreport
#END


#This Function shows some info about the computers memory (suppose to be in the form of a table, but I am having difficulties..)
function ramreport {

echo "Function #4 - RAM Report"
#shows total memory
grep MemTotal /proc/meminfo
free

}
ramreport
#END


function videoreport {
echo "Function #5 - Video Report"
#creates a variable, using sudo permissions finds information along side grep definitions
videoinfo=$(sudo lshw -C video | grep 'description\|product\|vendor')
#echo report
echo -e "Video Report: \n $videoinfo"

}
videoreport
#END

#This function shows some storage information
function diskreport {
echo "Function #6 - Disk Report"
#Finds information and creates colums using the names provided 
lsblk -io KNAME,TYPE,SIZE,MODEL

}
diskreport
#END

function networkreport {
echo "Function #6 - Network Report"
#Searches for network information and 
lshw -class network | grep '

}
networkreport
#END

