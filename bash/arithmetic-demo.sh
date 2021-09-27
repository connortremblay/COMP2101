#!/bin/bash
#
# this script demonstrates doing arithmetic

# Task 1: Remove the assignments of numbers to the first and second number variables. Use one or more read commands to get 3 numbers from the user.
# Task 2: Change the output to only show:
#    the sum of the 3 numbers with a label
#    the product of the 3 numbers with a label
prompt="enter 3 numbers"
read -p "$prompt" firstnum 
read -p "$prompt" secondnum
read -p "$prompt" thirdnum 
echo "user gave us $firstnum $secondnum $thirdnum"
sum=$((firstnum + secondnum + thirdnum))
dividend=$((firstnum / secondnum))
fpdividend=$(awk "BEGIN{printf \"%.2f\", $firstnum/$secondnum}")

cat <<EOF
$firstnum plus $secondnum plus $thirdnum is $sum
$firstnum divided by $secondnum is $dividend
  - More precisely, it is $fpdividend
EOF
