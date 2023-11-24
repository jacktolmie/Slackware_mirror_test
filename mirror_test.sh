#!/bin/bash

# mirror_test.sh
# Originally written for Ubuntu by Lance Rushing <lance_rushing@hotmail.com>
# Dated 9/1/2006
# Taken from http://ubuntuforums.org/showthread.php?t=251398
# This script is covered under the GNU Public License: http://www.gnu.org/licenses/gpl.txt

# Modified for Slackware by Jeremy Brent Hansen <jebrhansen -at- gmail.com>
# Modified 2015/11/06

# Modified 2016/05/13 by Jose Bovet Derpich jose.bovet@gmail.com

# Modified 2023/11/19 by FuzzyBottom.
#----------------------------------------------------------------
# Slackware
#----------------------------------------------------------------
# Added by FuzzyBottom. All sed commands were from chatgpt. Way above my abilities ;)

# Change to current slackware version or current. Optional: Pass arguments when calling to add version at script call (./mirror_test.sh 15.0 "ca|us" "http|ftp" (Version, countries, protocols)).
version=15.0 # You can also use current
if [[ $1 != "" ]]
    then version=$1
fi

# Select country(ies) mirrors from /etc/slackpkg/mirrors as desired. Use | to separate them eg: "us|ca"
target="us"
if [[ $2 !=  "" ]]
    then target=$2
fi

# Select protocol(s) to use. Use | to separate them eg: "http|ftp"
protocol="http"
if [[ $3 != "" ]]
    then protocol=$3
fi

# Fetch and filter mirrors based on selected countries and protocol
curl -s https://mirrors.slackware.com/mirrorlist/ | grep -E "^($target)" | sed -E "s/^($target)\s*//; s:<a[^>]*>([^<]*)</a>:\1:" | grep -E "^($protocol)" >> server.txt

# Read mirror list into a variable
MIRRORS=$(<server.txt)
cp /etc/slackpkg/mirrors /etc/slackpkg/mirrors.old
> /etc/slackpkg/mirrors
for MIRROR in $MIRRORS; do
    echo "#${MIRROR}slackware64-$version" | sed 's/ *$//' >> /etc/slackpkg/mirrors
done

rm server.txt
# End added by FuzzyBottom

# File to test the speed (adjust as needed)
FILE="slackware/kernels/huge.s/bzImage"

# Number of seconds before the test is considered a failure
TIMEOUT="5"

# String to store results in
RESULTS=""

# Set color variables for output formatting
RED="\e[31m"
GREEN="\e[32m"
NC="\e[0m"  #No color

for MIRROR in $MIRRORS; do
    echo -n "Testing $MIRROR "
    URL="$MIRROR$FILE"
    SPEED=$(curl --max-time $TIMEOUT --silent --output /dev/null --write-out %{speed_download} "$URL")

    if (( $(echo "$SPEED < 10000.000" | bc -l) )); then
        echo -e "${RED}Fail${NC}"
    else 
        SPEED="$(numfmt --to=iec-i --suffix=B --padding=7 "$SPEED")ps"
        echo -e "${GREEN}$SPEED${NC}"
        RESULTS+="\t$SPEED\t$MIRROR\n"
    fi
done

echo -e "\nResults:"
echo -e "$RESULTS" | sort -hr

# Added by FuzzyBottom.
# Find the fastest mirror to remove comment from mirrors list.
FASTEST=$(echo "$MIRRORS" | awk -v prot="$protocol" -v version="$version" '!/#/ && $0 ~ prot { print $0 }' | sort -hr | head -n 1)

# Remove trailing white spaces.
FASTEST="${FASTEST%"${FASTEST##*[![:space:]]}"}"

sed -i "s|^#$FASTEST|${FASTEST//#/}|g" /etc/slackpkg/mirrors

# End added by FuzzyBottom.
