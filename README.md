The original script I used is here <a href=https://github.com/bassmadrigal/scripts/blob/master/slack-mirror-speedtest.sh>slack-mirror-speedtest.sh</a>
<br>You can select which countries you want to grab the mirrors from to test the speeds (by country code 'us' 'ca' etc. Allows for multiple (us|ca). The () is required.
<br>Select the protocols you want to use (http, ftp etc. Allows for multiple (http|ftp)). The () is required.
<br>It will then grab the list of servers from slackware.com mirrors list to make sure it is up to date.
<br>It will then backup the old /etc/slackpkg/mirrors file, and insert only the servers from the selected countries and protocols.
<br>It will then test the speeds, and uncomment the fastest server to use for downloading.
<br>Thanks to Chatgpt for the sed commands and other help.
