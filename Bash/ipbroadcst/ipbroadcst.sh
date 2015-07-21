#!/bin/sh
# #########################################################################
# ipbroadcst: Find the broadcast address for an IPv4 address or list of 
# addresses
#
# Usage:  ipbroadcst [IPv4 adress] [netmask] OR ipbroadcst -f [file]
#
# Example: $  ./ipbroadcst 192.168.1.1 255.255.255.0
#
#      	   For IP: 192.168.1.1 and Netmask: 255.255.0.0 --- Broadcast: 
#		   192.168.1.255
#
# Copyright (C) 2015 Bill Banks Jr
# All rights reserved.
#
# Uses regular expression code from Mitch Frazier from http://www.
# linuxjournal.com/content/validating-ip-address-bash-script
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
# #########################################################################



## Calculate broadcast addresses from a file that contains ip addresses and 
## netmasks

function convert_from_file () {

file="$2"

if [ ! -f "$file" ]; then
	echo -e "\nipbroadcst: File \"$file\" not found or a special file.\n"
	exit 1
fi

echo -e "\n---> File being processed: $2\n" 

line_counter=1

## Read all ip addresses and netmasks in a file and calculate the 
## associated broadcast addresses

while IFS=' ' read -r ip_address netmask 
do
	## Regular expression to check if ip address and netmask are vaild

	if [[ $ip_address =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ \
&& $netmask =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then

	## Set the internal field seperator to "." so that Bash parses words as
	## dot seperated

	OIFS=$IFS
	IFS='.'

	## Store each octet of the ip address and netmask as a value in an 
	## array

	ip_address=($ip_address)
	netmask=($netmask)

	## Broadcast address is set to all of the octets that make up the ip 
	## address

	broadc_address=("${ip_address[@]}")

	IFS=$OFIS

	if [ ${netmask[3]} = 0 ]; then
		broadc_address[3]=255
	fi

	if [ ${netmask[2]} = 0 ]; then
		broadc_address[2]=255
	fi

	if [ ${netmask[1]} = 0 ]; then
		broadc_address[1]=255
	fi

	echo -en "Line $line_counter  IP: ${ip_address[0]}.\
${ip_address[1]}.${ip_address[2]}.${ip_address[3]} and Netmask: \
${netmask[0]}.${netmask[1]}.${netmask[2]}.${netmask[3]} --- Broadcast: \
${broadc_address[0]}.${broadc_address[1]}.${broadc_address[2]}.\
${broadc_address[3]}\n"

  	else
		 echo -e "Line $line_counter  ipbroadcst: An invalid ip address\
 or netmask was entered."
	fi

	((line_counter++))

done < "$file"

echo
exit 1
}

# ######################## MAIN PROGRAM #######################

## Check if at least one and no more than two arguments have been entered

if [ $# -eq 0 -o $# -gt 2 ]; then
	echo -e "\nUsage:  ipbroadcst [ip address] [netmask] OR ipbroadcst -f \
[file]\n" 1>&2
	exit 1
fi

## If a filename has been entered, run the function to process the file

if [ $1 = "-f" ]; then
	convert_from_file "$@"
	
## Regular expression to check if entered ip address and netmask are vaild

elif [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ && \
	$2 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
	
	ip_address=$1
	netmask=$2

	## Set the internal field seperator to "." so that Bash parses words
	## as dot seperated

	OIFS=$IFS
	IFS='.'

	## Store each octet of the ip address and netmask as a value in an array

	ip_address=($ip_address)
	netmask=($netmask)

	## Set broadcast address to all of the octets that make up the ip 
	## address

	broadc_address=("${ip_address[@]}")

	IFS=$OFIS

	if [ ${netmask[3]} = 0 ]; then
		broadc_address[3]=255
	fi

	if [ ${netmask[2]} = 0 ]; then
		broadc_address[2]=255
	fi

	if [ ${netmask[1]} = 0 ]; then
		broadc_address[1]=255
	fi

	echo -e "\nFor IP: ${ip_address[0]}.${ip_address[1]}.${ip_address[2]}\
.${ip_address[3]} and Netmask: ${netmask[0]}.\
${netmask[1]}.${netmask[2]}.${netmask[3]} --- Broadcast: \
${broadc_address[0]}.${broadc_address[1]}.${broadc_address[2]}.\
${broadc_address[3]}\n"

else
	echo -e "\nipbroadcst: An invalid option, ip adress or netmask was\
 entered.\n"

fi
