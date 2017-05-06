#!/bin/sh

ubuntu_version="`lsb_release -r | awk '{print $2}'`";
ubuntu_major_version="`echo $ubuntu_version | awk -F. '{print $1}'`";

# Work around bad cached lists on Ubuntu 12.04
if [ "$ubuntu_version" = "12.04" ]; then
    apt-get clean;
    rm -rf /var/lib/apt/lists;
fi

# Disable release-upgrades
sed -i.bak 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades;

# Update the package list
apt-get -y update;
apt-get -y upgrade;
# update package index on boot
cat <<EOF >/etc/init/refresh-apt.conf;
description "update package index"
start on networking
task
exec /usr/bin/apt-get -y update
EOF

# Manage broken indexes on distro disc 12.04.5
if [ "$ubuntu_version" = "12.04" ]; then
    apt-get -y install libreadline-dev dpkg;
fi

# Disable periodic activities of apt
cat <<EOF >/etc/apt/apt.conf.d/10disable-periodic;
APT::Periodic::Enable "0";
EOF

apt-get -y update
apt-get -y upgrade
apt-get -y install -f
apt-get -y install parted htop lubuntu-desktop git

cat > /etc/lightdm/lightdm.conf <<EOF
[SeatDefaults]
autologin-user=vagrant
autologin-user-timeout=0
# Check https://bugs.launchpad.net/lightdm/+bug/854261 before setting a timeout
user-session=Lubuntu
greeter-session=lightdm-gtk-greeter
EOF

# Upgrade all installed packages incl. kernel and kernel headers
apt-get -y dist-upgrade;
reboot;
sleep 60;
