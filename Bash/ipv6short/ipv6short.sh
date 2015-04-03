#!/bin/sh
# ######################################################################### 
# ipv6short: Converts an IPv6 address to shorter notation   
#
# Usage:  ipv6short [ip address] 
#
# Example: ipv6short 5210:8ff9:0000:0000:184a:41dd:0048:1852
#
#          Shortened Address: 5210:8ff9::184a:41dd:48:1852
#
# Copyright (c) 2015, Bill Banks Jr
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright 
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
# contributors may be used to endorse or promote products derived from this
# software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# ##########################################################################




# ###################### MAIN PROGRAM ######################


## Check if an argument has been entered

if [ $# -eq 0 -o $# -gt 1 ]; then
	echo -e "\nUsage:  ipv6shortener [ip adress]\n" 1>&2
	exit 1
fi

	
## Regular expression to check if entered address is a valid IPv6 address

ipv6_digit="[A-Fa-f0-9]{4,4}"

if [[ $1 =~ ^($ipv6_digit\:){7,7}$ipv6_digit$ ]]; then
	echo -e "\nEntered Address - $1"
else
	echo -e "\n\"$1\" is an invalid address. Exiting.\n"
	exit 1
fi


## Set the internal field seperator to ":" so that Bash parses each colon 
## seperated part of the ip address

OIFS=$IFS
IFS=':'

## Store each group of 4 hexadecimal digts of the ip address as a value in 
## an array

ip_address=($1)

		
## IPv6 ADDRESS TO SHORTER NOTATION - STEP 1: REMOVE LEADING ZEROES

## If a group of digits in the ip address is "0000" set that group to "0" 
## which removes the leading zeros from that group, else remove the leading 
## zeros from the group

for (( count=0; count<8; count+=1 ))
do
	if [[ ${ip_address[count]} = '0000' ]]; then
		ip_address[count]=$(echo "0")
	else	
		ip_address[count]=$(echo "${ip_address[count]}" | sed 's/^[0]*//')
	fi
done


## Uncomment the below to show the format of the address after STEP 1 has
## been run

#echo -e "\nShortened Address (leading zeros removed) - ${ip_address[0]} \
#${ip_address[1]} ${ip_address[2]} ${ip_address[3]} ${ip_address[4]} \
#${ip_address[5]} ${ip_address[6]} ${ip_address[7]}"



## IPv6 ADDRESS TO SHORTER NOTATION - STEP 2: REMOVE CONSECUTIVE SECTIONS OF
## ZEROES

## If one of the digits in the ip address is "0" or "::" or " " then check
## if the next digit is"0" If so, set the current digit to " " and the next
## digit to "::" If not, check if the previous digit is "0" or "::" or " " 
## and set the counter to end the loop, The loop runs only once so that only
## the first group of consecutive zeros is the address are compressed and 
## replaced with a "::"

consec_zero_counter=0

for (( count=0; count<8; count+=1 ))
do
	if [[ ${ip_address[count]} = '0' || ${ip_address[count]} = '::' || \
		${ip_address[count]} = '' && $consec_zero_counter -eq 0 ]] ; then
				
		if [[ ${ip_address[count+1]} = '0' ]]; then	
			ip_address[count]=$(echo "")
			ip_address[count+1]=$(echo "::")
		fi

	elif [[ ${ip_address[count]} != '0' || ${ip_address[count]} != '::' \
			|| ${ip_address[count]} != ''  ]]; then 

			if [[ ${ip_address[count-1]} = '0' || ${ip_address[count-1]} \
				= '::' || ${ip_address[count-1]} = ''  ]]; then
				consec_zero_counter=1	 
			fi
	fi
done


## Uncomment the below to show the format of the address after STEP 2 has
## been run

#echo -e "\nShortened Address (consecutive zeros removed) - \
#${ip_address[0]} ${ip_address[1]} ${ip_address[2]} ${ip_address[3]} \
#${ip_address[4]} ${ip_address[5]} ${ip_address[6]} ${ip_address[7]}"


##  Add the ":" character back to delimit the ip address

for (( count=0; count<8; count+=1 ))
do
	if [[ ${ip_address[count]} != '' ]]; then
		ipaddr_string+="${ip_address[count]}:"
	fi
done


## Uncomment the below to show format of address after ":"'s have been
## added back in

#echo -e "\nShortened Address (\":\" added back to delimit the address) \
#- ${ipaddr_string}"	


## If part of the address has ":::" or a larger amount of ":"'s, replace it
## with "::"

ipaddr_string=$(echo "${ipaddr_string}" | sed 's/:::*/::/g')


## Remove the extra ":" from the IPv6 address

ipaddr_string=$(echo "${ipaddr_string}"  | sed 's/:$//g')

echo -e "\nShortened Address - $ipaddr_string\n"
