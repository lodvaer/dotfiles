#!/bin/sh

set -eu

err=0
for i in rsync vim make; do
	if [ ! -x "$(which $i)" ]; then
		echo Needs $i >&2
		err=1
	fi
done
if [ -n "${DISPLAY:-}" ]; then
	for i in st dmenu_run xdotool xclip; do
		if [ ! -x "$(which $i)" ]; then
			echo Probably needs $i >&2
			err=1
		fi
	done
fi
if [ $err -ne 0 ]; then
	exit $err
fi

git submodule update --init

mkdir -p ~/.zshrc.d
for x in zshrc.d/*; do
	ln -f "$x" ~/.zshrc.d/"$(basename "$x")"
done

for x in sv/*; do
	mkdir -p ~/$x
	ln -f $x/* ~/$x
done

mkdir -p ~/.gnupg ~/.local/bin
ln -f zshrc.local ~/.zshrc.local
ln -f ghci ~/.ghci
ln -f vimrc ~/.vimrc
ln -f gvimrc ~/.gvimrc
ln -f rtorrent.rc ~/.rtorrent.rc
mkdir -p ~/.config/herbstluftwm
ln -f herbst_autostart ~/.config/herbstluftwm/autostart
ln -f herbst_panel.sh ~/.config/herbstluftwm/panel.sh
mkdir -p ~/.config/dunst
ln -f dunstrc ~/.config/dunst/dunstrc
ln -f gpg.conf ~/.gnupg/gpg.conf
ln -f tmux.conf ~/.tmux.conf
rsync -av --link-dest=$PWD .xkb/ ~/.xkb

for f in bin/*; do
	ln -f $f ~/.local/bin
done

# Only on hosts where I'm this alias.
if [ "$(id -u -n)" = kitty ]; then
	ln -f gitconfig ~/.gitconfig
fi

if [ ! -d ~/.vim/bundle/repos/github.com/Shougo/dein.vim ]; then
	mkdir -p ~/.vim/bundle/repos/github.com/Shougo
	git clone https://github.com/Shougo/dein.vim.git \
		~/.vim/bundle/repos/github.com/Shougo/dein.vim
	vim +'call dein#install()' +qa'!'
fi

if [ -n "${DISPLAY:-}" -a ! -d ~/.local/share/fonts/googlefonts ]; then
	mkdir -p ~/.local/share/fonts
	cd ~/.local/share/fonts
	git clone https://github.com/google/fonts googlefonts
	git clone https://github.com/powerline/fonts powerline-fonts
	fc-cache -fv
	cd - >/dev/null
elif [ -n "${DISPLAY:-}" ]; then
	olddir="$PWD"
	cd ~/.local/share/fonts
	p=.git/refs/heads/master
	old="`cat googlefonts/$p``cat powerline-fonts/$p`"
	cd googlefonts
	git pull
	cd - >/dev/null
	cd powerline-fonts
	git pull
	cd - >/dev/null
	if [ "`cat googlefonts/$p``cat powerline-fonts/$p`" != "$old" ]; then
		fc-cache -fv
	fi
	cd "$olddir"
fi
