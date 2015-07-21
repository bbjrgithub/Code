#!/bin/sh
# ######################################################################### 
# randpass: Generates a random password of at least 8 characters  
#
# Usage:  randpass [length of password]
#
# Example: $  ./randpass 8
#
#          6l#Y4KK5
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


## Check that a password length is entered

if [ $# -eq 0 -o $# -gt 1 ]; then
    echo -e "\nError: No password length entered\n\nUsage:  randpass [length \
of password]\nNote that the length has to be greater than 8.\nExample: \
randpass 10" 1>&2
    exit 1
fi

## Check that the password length is numerical

if [[ $1 != *[0-9]* ]]; then
    echo -e "\nError: Invalid password length entered\n\nUsage:  randpass \
[length of password]\nNote that the length has to be greater than 8.\n\
Example: randpass 10" 1>&2
    exit 1
fi

## Check that the password length is at least 8

if [ $1 -lt "8" ]; then
    echo -e "\nError: Password length not >= 8\n\nUsage:  randpass [length \
of password]\nNote that the length has to be greater than 8.\nExample: \
randpass 10" 1>&2
    exit 1
fi
 

pass_length=$1

## Characters that can be used in the password

pass_chars=({a..z} {A..Z} {0..9} \] \[ \! \" \# \$ \% \& \' \( \) \* \+ \, \. \/ \: \
	\; \< \= \> \? \@ \\ \^ \_ \` \{ \| \} \~ \-)

## Generate password based on password length that was input

for ((c=0; c<$pass_length; c++))
do
    ## Get a random number from /dev/urandom

    rand_num=$(od -vAn -N4 -tu4 < /dev/urandom)

    ## Take advantage of brace expansion to select a random character from the
    ## pass_chars array (See http://wiki.bash-hackers.org/snipplets/rndstr
    ## for reference

    printf '%.1s' "${pass_chars[rand_num%${#pass_chars[@]}]}"
done
echo -e
