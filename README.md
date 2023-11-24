The original script I used is here <a href=https://github.com/bassmadrigal/scripts/blob/master/slack-mirror-speedtest.sh>slack-mirror-speedtest.sh</a>
<p>
  This script will allow you to find the fastest mirror based on what countries you want, and the protocols. You can either run it with no arguments, which will default to version 15.0, with the country being 'us', and the protocol 'http', or pass your own.
  <br>To pass arguments, it has to be VERSION, then COUNTRY(IES), finally PROTOCOL(S): mirror_test.sh current "ca|us" "http|ftp" for example.
</p>
<p>
  It will then do the following:
  <ul>
    <li>Grab a current list of mirrors from the slackware.com website.</li>
    <li>Back up the old /etc/slackpkg/mirrors file, and replace it with only the options you selected (version, country, protocol).</li>
    <li>Find and uncomment out the fastest one from the list.</li>
  </ul>
</p>
<p>
  This can be used in a script if you want when you finish installing Slackware, and want to update it. I created a script that will run the following:
  <ul>
    <li>Install slackpkg+.</li>
    <li>Find fastest mirror.</li>
    <li>Update Slackware files (and run lilo for any kernel updates).</li>
    <li>Add Alienbob repositories.</li>
    <li>Install multilib from Alienbob repo.</li>
    <li>Turn off the option to select all packages when showing available packages when using slackpkg.</li>
    <li>Install and update sbopkg.</li>
  </ul>
</p>
<br>Thanks to Chatgpt for the sed commands and other help.
