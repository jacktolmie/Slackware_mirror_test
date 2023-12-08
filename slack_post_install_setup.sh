#/bin/bash
echo "Change directory to /root/Downloads"
if [[ ! -d "/root/Downloads" ]]; then mkdir /root/Downloads; fi
ROOTDIR=/root/Downloads
cd $ROOTDIR

# Download and install slackpkg+. Change to current version
SLPLVER=1.8.0-noarch-7mt
echo "Download slackpkg+"
wget https://sourceforge.net/projects/slackpkgplus/files/slackpkg%2B-$SLPLVER.txz
echo "Install slackpkg+"
installpkg $ROOTDIR/slackpkg+-$SLPLVER.txz
rm $ROOTDIR/slackpkg+*

# Add mirror to download files/updates. Update version as required
VERSION=15.0 # change to latest version or current

# Multiple protocols or targets require a pipe: "http|ftp" or "us|ca" etc.
PROTOCOL="http"
TARGET="us"

echo "Add a mirror for slackware $VERSION"
wget https://raw.githubusercontent.com/jacktolmie/Slackware_mirror_test/main/mirror_test.sh
chmod +x $ROOTDIR/mirror_test.sh $VERSION
$ROOTDIR/mirror_test.sh $VERSION "$TARGET" "$PROTOCOL"
rm $ROOTDIR/mirror_test.sh*

# Add alienbob repositories to slackpkgplus.conf
echo -e "# Slackware $VERSION - x86_64\nREPOPLUS=( slackpkgplus alienbob multilib restricted )\nMIRRORPLUS['multilib']=https://slackware.uk/people/alien/multilib/$VERSION/\nMIRRORPLUS['alienbob']=https://slackware.uk/people/alien/sbrepos/$VERSION/x86_64\nMIRRORPLUS['restricted']=https://slackware.uk/people/alien/restricted_sbrepos/$VERSION/x86_64" >> /etc/slackpkg/slackpkgplus.conf

# Update GPG and packages.
slackpkg update gpg
slackpkg update
slackpkg upgrade-all

# Run lilo just in case kernel was updated.
lilo

# Get alienbob package listing
slackpkg install alienbob

# Install multilib
mkdir /root/Downloads
cd /root/Downloads
mkdir multilib && cd multilib
lftp -c "open http://www.slackware.com/~alien/multilib/ ; mirror -c -e $VERSION"
cd $VERSION
upgradepkg --reinstall --install-new *.t?z
upgradepkg --install-new slackware64-compat32/*-compat32/*.t?z
printf "\n//Multilib:\n[0-9]+alien\n[0-9]+compat32\n" >> /etc/slackpkg/blacklist

# Change slackpkg.conf to default to not select all packages
echo "Changing selecting all packages from on to off"
sed -i 's/ONOFF=on/ONOFF=off/' /etc/slackpkg/slackpkg.conf

# Get Sbopkg to install from Slackbuilds.org. Change to current verion
SBOVER=0.38.2
cd /root/Downloads
wget https://github.com/sbopkg/sbopkg/releases/download/$SBOVER/sbopkg-$SBOVER-noarch-1_wsr.tgz
installpkg sbopkg-$SBOVER-noarch-1_wsr.tgz

# Update Sbopkg
sbopkg -r
