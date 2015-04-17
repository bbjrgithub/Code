#!/bin/sh
# #########################################################################
# lastmod: Calculates the last time a file was modified in days.
#
# Usage:  lastmod [file] 
#
# Example:  lastmod notes
#
#			File "notes" was last modified 3 days ago
#
# Copyright (C) 2015 Bill Banks Jr
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
# #########################################################################



# ######################## MAIN PROGRAM #######################

## Check if at least one and no more than two arguments have been entered.

if [ $# -eq 0 -o $# -gt 1 ]; then
	echo -e "\nUsage:  lastmod [file]\n" 1>&2
	exit 1
fi


file="$1"

## Check if file is valid

if [ ! -f "$file" ]; then
	echo -e "\nlastmod: File \"$file\" not found or a special file.\n"
	exit 1
fi

## Get the time the file was last modified in seconds since Epoch and the
## current time in seconds since Epoch.

file_mod_time=$(stat -c %Y $file)
current_time=$(date +%s)

## Calcuate the days since the file was modified. Adjusts for daylight
## savings time using printf and bc.

mod_day=$(printf "%.0f" $(echo "scale=2; ($current_time - $file_mod_time\
	)/(60*60*24)" | bc) )

if [ $mod_day = 1 ]; then
	echo -e "File \"$file\" was last modified $mod_day day ago"
else
	echo -e "File \"$file\" was last modified $mod_day days ago"
fi
