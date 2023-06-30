#!/bin/bash
#Final Script Assignment Connor Tremblay 200451942

#This function showslabeled data showing CPU manufacturer and model, CPU architecture, CPU core count
#CPU maximum speed in a human friendly format
#Sizes of caches (L1, L2, L3) in a human friendly format

#Function #1
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


