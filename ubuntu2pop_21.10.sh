#!/bin/bash

# root check
if [ "$UID" -ne 0 ]; then
        sudo $0 #If not root we execute ourself as root then exit
        exit
fi

# Setting hostname
sudo hostnamectl set-hostname pop-os

# Importing keys
# Creating folder to avoid folder not found bug
sudo mkdir /root/.gnupg
# Creating new keyring (key box) with Pop!_OS ISO key
sudo gpg --no-default-keyring --keyring ./pop.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 63C46DF0140D738961429F4E204DD8AEC33A7AFF
# Transforming keyring type from key box to key public ring
sudo gpg --no-default-keyring --keyring ./pop.gpg --export > ./system76-ubuntu-pop.gpg
# Moving to trusted.gpg.d folder
sudo mv system76-ubuntu-pop.gpg /etc/apt/trusted.gpg.d/
# Cleanup tmp files
sudo rm pop.gpg* 


# Creating repos
sudo cat > /etc/apt/sources.list.d/pop-os-apps.sources << EOL
X-Repolib-Name: Pop_OS Applications
Enabled: yes
Types: deb
URIs: http://apt.pop-os.org/proprietary
Suites: impish
Components: main
EOL
sudo cat > /etc/apt/sources.list.d/pop-os-release.sources << EOL
X-Repolib-Name: Pop_OS Release Sources
Enabled: yes
Types: deb deb-src
URIs: http://apt.pop-os.org/release
Suites: impish
Components: main
EOL
sudo cat > /etc/apt/sources.list.d/system.sources << EOL
X-Repolib-Name: Pop_OS System Sources
Enabled: yes
Types: deb deb-src
URIs: http://us.archive.ubuntu.com/ubuntu/
Suites: impish impish-security impish-updates impish-backports
Components: main restricted universe multiverse
X-Repolib-Default-Mirror: http://us.archive.ubuntu.com/ubuntu/
EOL

# Deprecating sources.list
sudo rm /etc/apt/sources.list
sudo cat > /etc/apt/sources.list << EOL
## See sources.list(5) for more information, especialy
# Remember that you can only use http, ftp or file URIs
# CDROMs are managed through the apt-cdrom tool.
# deb cdrom:[Pop_OS 21.10 _Impish Indri_ - Release amd64 (20220303)]/ impish main restricted
EOL

# Installing Pop!_OS
sudo apt --yes --allow-downgrades purge gnome-initial-setup
sudo apt update
sudo apt --yes --allow-downgrades dist-upgrade
sudo apt --yes --allow-downgrades install pop-desktop

# Removing things that are in Ubuntu, that are not in Pop (Except essential packages and kernels)
sudo apt --yes --allow-downgrades purge anacron apport-gtk apturl-common branding-ubuntu crda dmz-cursor-theme ethtool fonts-beng fonts-beng-extra fonts-deva fonts-deva-extra fonts-gargi fonts-gubbi fonts-gujr fonts-gujr-extra fonts-guru fonts-guru-extra fonts-indic fonts-kacst fonts-kacst-one fonts-kalapi fonts-khmeros-core fonts-knda fonts-lao fonts-lklug-sinhala fonts-lohit-beng-assamese fonts-lohit-beng-bengali fonts-lohit-deva fonts-lohit-gujr fonts-lohit-guru fonts-lohit-knda fonts-lohit-mlym fonts-lohit-orya fonts-lohit-taml fonts-lohit-taml-classical fonts-lohit-telu fonts-mlym fonts-nakula fonts-navilu fonts-orya fonts-orya-extra fonts-pagul fonts-sahadeva fonts-samyak-deva fonts-samyak-gujr fonts-samyak-mlym fonts-samyak-taml fonts-sarai fonts-sil-abyssinica fonts-sil-padauk fonts-smc fonts-smc-anjalioldlipi fonts-smc-chilanka fonts-smc-dyuthi fonts-smc-gayathri fonts-smc-karumbi fonts-smc-keraleeyam fonts-smc-manjari fonts-smc-meera fonts-smc-rachana fonts-smc-raghumalayalamsans fonts-smc-suruma fonts-smc-uroob fonts-taml fonts-telu fonts-telu-extra fonts-teluguvijayam fonts-thai-tlwg fonts-tibetan-machine fonts-tlwg-garuda fonts-tlwg-garuda-ttf fonts-tlwg-kinnari fonts-tlwg-kinnari-ttf fonts-tlwg-laksaman fonts-tlwg-laksaman-ttf fonts-tlwg-loma fonts-tlwg-loma-ttf fonts-tlwg-mono fonts-tlwg-mono-ttf fonts-tlwg-norasi fonts-tlwg-norasi-ttf fonts-tlwg-purisa fonts-tlwg-purisa-ttf fonts-tlwg-sawasdee fonts-tlwg-sawasdee-ttf fonts-tlwg-typewriter fonts-tlwg-typewriter-ttf fonts-tlwg-typist fonts-tlwg-typist-ttf fonts-tlwg-typo fonts-tlwg-typo-ttf fonts-tlwg-umpush fonts-tlwg-umpush-ttf fonts-tlwg-waree fonts-tlwg-waree-ttf fonts-yrsa-rasa fprintd gamemode gamemode-daemon gdb gir1.2-gmenu-3.0 gnome-session-canberra gsettings-ubuntu-schemas gstreamer1.0-libav gstreamer1.0-packagekit gstreamer1.0-plugins-ugly hplip hplip-data humanity-icon-theme irqbalance iw kerneloops liba52-0.7.4 libaacs0 libass9 libavfilter7 libavformat58 libbabeltrace1 libbdplus0 libblas3 libbluray2 libboost-regex1.74.0 libbs2b0 libc6-dbg libcairo-gobject-perl libcairo-perl libchromaprint1 libdebuginfod-common libdebuginfod1 libdvdread8 libextutils-depends-perl libextutils-pkgconfig-perl libfftw3-double3 libflite1 libfprint-2-2 libgamemode0 libgamemodeauto0 libgfortran5 libglib-object-introspection-perl libglib-perl libgme0 libgnome-menu-3-0 libgtk3-perl libimagequant0 libinih1 libipt2 liblapack3 libldap-common liblilv-0-0 libmpeg2-4 libmspack0 libmysofa1 libnorm1 libnotify-bin libopencore-amrnb0 libopencore-amrwb0 libopenmpt0 libpam-fprintd libpam-pwquality libpam-sss libpgm-5.3-0 libpocketsphinx3 libpostproc55 librabbitmq4 libreoffice-ogltrans libreoffice-pdfimport libreoffice-style-breeze librubberband2 libsane-hpaio libsasl2-modules libsasl2-modules-gssapi-mit libserd-0-0 libsidplay1v5 libsord-0-0 libsource-highlight-common libsource-highlight4v5 libsphinxbase3 libsratom-0-0 libsrt1.4-gnutls libssh-gcrypt-4 libu2f-udev libudfread0 libvidstab1.1 libwmf0.2-7 libwmf0.2-7-gtk libxmlsec1-openssl libzimg2 libzmq5 mailcap memtest86+ mime-support mousetweaks network-manager-config-connectivity-ubuntu open-vm-tools open-vm-tools-desktop os-prober packagekit-tools pocketsphinx-en-us power-profiles-daemon publicsuffix python3-olefile python3-pexpect python3-pil python3-ptyprocess python3-renderpm python3-reportlab python3-reportlab-accel session-migration spice-vdagent squashfs-tools ubuntu-mono ubuntu-report unattended-upgrades whoopsie xcursor-themes xul-ext-ubufox yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound zerofree thunderbird* remmina* transmission-* gnome-mines gnome-mahjongg update-manager update-notifier* gnome-characters cheese usb-creator-* deja-dup software-properties-gtk gnome-logs rhythmbox* shotwell* aisleriot gnome-sudoku gnome-todo* ubuntu-session ubuntu-settings ubuntu-wallpapers* ubuntu-release-upgrader-gtk

# Removing all traces of snap
sudo apt --yes --allow-downgrades purge snapd
rm -rf $HOME/snap/

# Installing things that are in Pop!_OS that are not in Ubuntu
sudo apt --yes --allow-downgrades install dctrl-tools dkms fonts-arphic-ukai fonts-arphic-uming fonts-noto-cjk-extra fonts-noto-core fonts-noto-ui-core python3-software-properties system76-acpi-dkms system76-dkms system76-io-dkms   

# Installing missing language packs
LOCALE_CODE=$(locale | grep LANG= | cut -d = -f 2 | cut -d _ -f 1)
MISSING_LANGUAGE_PACKAGES=$(check-language-support -l $LOCALE_CODE)
sudo apt --yes --allow-downgrades install $MISSING_LANGUAGE_PACKAGES

# Fixing bug with updates of libfwupd2
sudo apt --yes --allow-downgrades install fwupd libfwupd2

# Cleanup apt
sudo apt --yes --allow-downgrades autoremove
sudo apt --yes --allow-downgrades dist-upgrade
sudo apt --yes --allow-downgrades autoremove

# os-prober might have been deleted, like in my case
sudo apt --yes --allow-downgrades install os-prober
sudo update-grub

# Resetting Categories in Pop! Menu, because of a bug that changes it
gsettings reset org.gnome.desktop.app-folders folder-children

# Assigning the Pop Robot avatar to our user login screen
for user in $(sudo ls /var/lib/AccountsService/users | grep -v gdm); do
   sudo cp /usr/share/pixmaps/faces/pop-robot.png /var/lib/AccountsService/icons/$user
   sed -i "s+/home/$user/.face+/var/lib/AccountsService/icons/$user+g" /var/lib/AccountsService/users/$user
done

# Reboot message
echo "##################"
echo "# PLEASE REBOOT! #"
echo "##################"
