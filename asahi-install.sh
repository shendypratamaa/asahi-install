# =============================================================================
printf '\033c'
echo "========================================================================="
echo "================= shendypratamaa/asahi-install.sh ======================="
echo "========================================================================="

pacman -Syu
loadkeys us
timedatectl set-ntp true

ln -sfv /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf
locale-gen

echo -n "Hostname : "; read HOSTNAME
echo $HOSTNAME > /etc/hostname
echo '' > /etc/hosts
echo "127.0.0.1         localhost" >> /etc/hosts
echo "::1               localhost" >> /etc/hosts
echo "127.0.1.1         $HOSTNAME.local $HOSTNAME" >> /etc/hosts

pacman -S xorg-server xorg-xinit xorg-xsetroot xorg-xev libx11 libxinerama libxft vim tmux gcc \
    picom dunst libnotify xdg-user-dirs git stow lazygit git-delta neofetch tree sudo which bc \
    mpv sxiv fzf man-db zathura zathura-pdf-poppler ffmpeg ffmpegthumbnailer imagemagick ueberzug \
    python-pywal xwallpaper unclutter xclip maim xdotool sxhkd pacman-contrib upower \
    zsh bat exa fd ripgrep jq htop dhcpcd ufw zip unzip unrar lf make cmake trash-cli \
    bluez bluez-utils pulseaudio pulseaudio-alsa pulseaudio-bluetooth pulsemixer \
    ttf-hack-nerd ttf-jetbrains-mono noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra \
    thunar firefox \

echo -n "Username : "; read USER_NAME
useradd -m -G wheel -s /bin/zsh $USER_NAME
passwd $USER_NAME
echo "$USER_NAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER_PATH_INSTALLATION=/home/$USER_NAME/asahi-user-install.sh
sed '1,/^#_USER_PATH$/d' asahi-install.sh > $USER_PATH_INSTALLATION
chown $USER_NAME:$USER_NAME $USER_PATH_INSTALLATION
chmod +x $USER_PATH_INSTALLATION

echo "========================================================================="
echo "==== go to your user account and executed asahi-user-installation.sh ===="
echo "========================================================================="
echo "====================== Pre-installtion complete ========================="
echo "========================================================================="
rm -f ./asahi-install.sh
sleep 2;  exit;

# =============================================================================

#_USER_PATH
printf '\033c'
echo "========================================================================="
echo "================= shendypratamaa/asahi-install.sh ======================="
echo "========================================================================="

# ARCH(dotfiles)
read -p "do you want to install shendypratmaaa/.dotfiles [Y/n] " ANSWER
if [ -z "$ANSWER" ] || [ "$ANSWER" = "y" ]; then

    rm -rf $(fd . -t d) && rm -rf .*

    mkdir -p  applications data desktop docs downloads music pictures share video .local/share .cache/tmp .cache/zsh

    cd $HOME && git clone https://github.com/shendypratamaa/.arch

    directory=(
        X11
        git
        lazygit
        neofetch
        sxiv
        wallpaper
        zathura
        zsh
        gtk-3.0
        dunst
        sxhkd
        local
        lf
        picom
        pipe
        tmux
    )

    initfile=(
        .vimrc
        .zprofile
    )

    cd ~/.arch && stow -v "${directory[@]}"

    for file in "${initfile[@]}"; do
        ln -sfv ~/.arch/$file  ~/
    done

    ln -sfv ~/.arch/user-dirs.dirs ~/.config

    if [ -d $HOME/.config/zsh ]; then
        mkdir -p $HOME/.config/zsh/plugins
        cd ~/.config/zsh/plugins &&
            git clone https://github.com/zsh-users/zsh-autosuggestions
            git clone https://github.com/zsh-users/zsh-syntax-highlighting
            git clone https://github.com/zsh-users/zsh-completions
    fi
    sleep 2
fi

# SUCKLESS(dmenu,dwm,st)
printf '\033c'
echo "========================================================================="
echo "================= shendypratamaa/asahi-install.sh ======================="
echo "========================================================================="
read -p "do you want to install shendypratama/suckless [Y/n]" ANSWER
if [ "$ANSWER" = "y" ] || [ -z "$ANSWER" ]; then
    cd ~/.local/share/
	git clone https://github.com/shendypratamaa/suckless
	sudo make -C ~/.local/share/suckless/dmenu install
	sudo make -C ~/.local/share/suckless/dwm install
	sudo make -C ~/.local/share/suckless/st install
	sleep 2
fi

# NVIM-BASE(neovim-config)
printf '\033c'
echo "========================================================================="
echo "================= shendypratamaa/asahi-install.sh ======================="
echo "========================================================================="
read -p "do you want to install shendypratama/nvim-base [Y/n]" ANSWER
if [ "$ANSWER" = "y" ] || [ -z "$ANSWER" ]; then
    cd ~/.config &&
        git clone https://github.com/shendypratamaa/nvim-base
        mv $HOME/.config/nvim-base $HOME/.config/nvim
	sleep 2
fi

# Neovim Build From Source + NVIM-BASE
echo "========================================================================="
echo "================= shendypratamaa/asahi-install.sh ======================="
echo "========================================================================="
echo "===== when you install nvim-base you need neovim + packer + nodejs ======"
echo "========================================================================="
read -p "do you want to install neovim build from source + packer + node(nvm) [Y/n] " ANSWER
if [ "$A NSWER" = "y" ] || [ -z "$ANSWER" ]; then
	#neovim
        sudo pacman -S base-devel cmake unzip ninja tree-sitter curl
        cd ~/.local/share
        git clone https://github.com/neovim/neovim
        cd neovim && make CMAKE_BUILD_TYPE=Release
        git checkout v0.8.0 && sudo make install

	#node
	cd $HOME/.local/share && git clone https://github.com/nvm-sh/nvm
	source ~/.arch/.zprofile
	. ~/.local/share/nvm/nvm.sh
	nvm install 16.18.1
	nvm use node
	nvm alias default
	npm install --global nodemon yarn nativefier

	#packer
	git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
	nvim -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
	nvim -c 'TSUpdate' -c 'Mason'
    sleep 2
fi

# AUR HELPER(yay)
printf '\033c'
echo "========================================================================="
echo "================= shendypratamaa/asahi-install.sh ======================="
echo "========================================================================="
read -p "do you want to install aur helper (yay) [Y/n] " ANSWER
if [ "$ANSWER" = "y" ] || [ -z "$ANSWER" ]; then
    cd $HOME && git clone https://aur.archlinux.org/yay.git;
    cd ~/yay && makepkg -si;
    rm -rf $HOME/yay;
    rm -rf $HOME/.cache/go-build;
    sleep 2
fi

sed -i "s/shendy/$(whoami)/g" $HOME/.xinitrc
rm -f ./asahi-user-install.sh

# finish
printf '\033c'
echo "========================================================================="
echo "===================== User-installtion complete ========================="
echo "========================================================================="
read -p "do you want to relog this config [Y/n] " ANSWER
if [ "$ANSWER" = "y" ] || [ -z "$ANSWER" ]; then
    systemctl reboot -i
fi
