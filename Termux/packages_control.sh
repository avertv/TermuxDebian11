#!/bin/bash
#color
RED='\033[1;31m'
GREEN='\033[1;32m'
PURPLE='\033[0;35m'
BLUE='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

options=(1 "install packages"
         2 "update all after install"
         3 "install packages"
         4 "update all after uninstall")

while choice=$(dialog --title "$TITLE" \
                 --menu "What we do today" 10 40 3 "${options[@]}" \
                 2>&1 >/dev/tty)

do
case $choice in
1)
proot-distro login debian -- curl -s -J -O https://raw.githubusercontent.com/bbk14/TermuxDebian/main/Termux/Debian/install.sh
proot-distro login debian -- bash install.sh
;;
2)
#check if Lampac is installed
if proot-distro login debian -- [ -d "/home/lampac" ]
then
cat <<EOT >> noteT.sh
#LampacStart
echo ""
echo -e "${NC}${GREEN}Lampac running in background ip:9118"
echo -e "${RED}about Lampac: https://github.com/immisterio/Lampac"
echo -e "${BLUE}connect to Lampac session:"
echo -e " ${YELLOW}tmux attach -t Lampac${NC}"
#LampacEnd
EOT
cat <<EOT >> noteD.sh
#LampacStart
echo""
echo -e "${NC}${BLUE}change Lampac config:"
echo -e " ${YELLOW}nano /home/lampac/init.conf${NC}"
#LampacEnd
EOT
echo "tmux new-session -s Lampac -d "proot-distro login debian -- bash /root/lampac_updater.sh"" >> ~/.bashrc
fi
#check if Jackett is installed
if proot-distro login debian -- [ -d "/home/Jackett" ]
then
cat <<EOT >> noteT.sh
#JackettStart
echo ""
echo -e "${NC}${GREEN}Jackett running in background ip:9117"
echo -e "${RED}about Jackett: https://github.com/Jackett/Jackett"
echo -e "${BLUE}connect to Lampac session:"
echo -e " ${YELLOW}tmux attach -t Jackett${NC}"
#JackettEnd
EOT
cat <<EOT >> noteD.sh
#JackettStart
echo""
echo -e "${NC}${BLUE}change APIKey Jackett:"
echo -e " ${YELLOW}nano /root/.config/Jackett/ServerConfig.json${NC}"
#JackettEnd
EOT
echo "tmux new-session -s Jackett -d "proot-distro login debian -- /home/Jackett/./jackett"" >> ~/.bashrc
fi
#check if Torrserver is installed
if proot-distro login debian -- [ -d "/home/torrserver" ]
then
cat <<EOT >> noteT.sh
#TorrserverStart
echo ""
echo -e "${NC}${GREEN}Torrserver running in background ip:8091"
echo -e "${RED}about Torrserver: https://github.com/YouROK/TorrServer"
echo -e "${BLUE}connect to Torrserver session:"
echo -e " ${YELLOW}tmux attach -t Torrserver${NC}"
#TorrserverEnd
EOT
echo "tmux new-session -s Jackett -d "proot-distro login debian -- /home/torrserver/torrserver -p 8091"" >> ~/.bashrc
fi
#check if Midnight Commander is installed
if proot-distro login debian -- [ -d "/etc/mc" ]
then
cat <<EOT >> noteT.sh
#MidnightCommanderStart
echo ""
echo -e "${NC}${BLUE}run Midnight Commander:"
echo -e " ${YELLOW}proot-distro login debian -- mc${NC}"
#MidnightCommanderEnd
EOT
fi
sed -i "/#DebianStart/,/#DebianEnd:/d" noteT.sh
cat <<EOT >> noteT.sh
#DebianStart
echo ""
echo -e "${NC}${BLUE}start Debian for more settings:"
echo -e " ${YELLOW}proot-distro login debian${NC}"
#DebianEnd
EOT
sed -i "/#GreetingStart/,/#GreetingEnd:/d" .bashrc
cat <<EOT >> .bashrc
#GreetingStart
bash note.sh
bash packages_control.sh
#GreetingEnd
EOT
;;
3)
proot-distro login debian -- curl -s -J -O https://raw.githubusercontent.com/bbk14/TermuxDebian/main/Termux/Debian/uninstall.sh
proot-distro login debian -- bash uninstall.sh
;;
4)
#check if Lampac is installed
if proot-distro login debian -- [ -d "/home/lampac" ]
then
echo ""
else
sed -i "/#LampacStart/,/#LampacEnd:/d" noteT.sh
sed -i "/#LampacStart/,/#LampacEnd:/d" noteD.sh
sed -i '/-t Lampac/d' .bashrc
fi
#check if Jackett is installed
if proot-distro login debian -- [ -d "/home/Jackett" ]
then
echo ""
else
sed -i "/#JackettStart/,/#JackettEnd:/d" noteT.sh
sed -i "/#JackettStart/,/#JackettEnd:/d" noteD.sh
sed -i '/-t Jackett/d' .bashrc
fi
#check if Torrserver is installed
if proot-distro login debian -- [ -d "/home/torrserver" ]
then
echo ""
else
sed -i "/#TorrserverStart/,/#TorrserverEnd:/d" noteT.sh
sed -i '/-t Torrserver/d' .bashrc
fi
#check if Midnight Commander is installed
if proot-distro login debian -- [ -d "/etc/mc" ]
then
echo ""
else
sed -i "/#MidnightCommanderStart/,/#MidnightCommanderEnd:/d" noteT.sh
fi
sed -i "/#DebianStart/,/#DebianEnd:/d" noteT.sh
cat <<EOT >> noteT.sh
#DebianStart
echo ""
echo -e "${NC}${BLUE}start Debian for more settings:"
echo -e " ${YELLOW}proot-distro login debian${NC}"
#DebianEnd
EOT
sed -i "/#GreetingStart/,/#GreetingEnd:/d" .bashrc
cat <<EOT >> .bashrc
#GreetingStart
bash note.sh
bash packages_control.sh
#GreetingEnd
EOT
;;

esac
done
clear