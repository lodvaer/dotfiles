#!/bin/zsh

err=0
for i in urxvt rsync vim dmenu_run make; do
	if [[ ! -x $(which $i) ]]; then
		echo Needs $i >&2
		err=1
	fi
done
if [[ $err != 0 ]]; then
	exit $err
fi

git submodule update --init

mkdir -p ~/.zshrc.d
for x in zshrc.d/*; do
	ln -f $x ~/.zshrc.d/"$(basename $x)"
done

mkdir -p ~/.gnupg ~/.local/bin
ln -f zshrc.local ~/.zshrc.local
ln -f ghci ~/.ghci
ln -f vimrc ~/.vimrc
ln -f gvimrc ~/.gvimrc
ln -f git-hscope ~/.local/bin/git-hscope
mkdir -p ~/.config/herbstluftwm
ln -f herbst_autostart ~/.config/herbstluftwm/autostart
ln -f herbst_panel.sh ~/.config/herbstluftwm/panel.sh
rsync -av --link-dest=$PWD .xkb/ ~/.xkb

# Only on hosts where I'm this alias.
if [[ $USER = kitty ]]; then
	ln -f gitconfig ~/.gitconfig
	ln -f gpg.conf ~/.gnupg/gpg.conf
else
	cp gpg.conf ~/.gnupg/gpg.conf
	sed -i s/kitty/$USER/g ~/.gnupg/gpg.conf
fi

cp solarized/xresources/solarized ~/.Xresources
sed s/002b36/001b26/ -i ~/.Xresources

if [[ ! -d ~/.vim/bundle/Vundle.vim ]]; then
	mkdir -p ~/.vim/bundle
	git clone https://github.com/gmarik/Vundle.vim.git \
		~/.vim/bundle/Vundle.vim
	vim +PluginInstall +qa'!'
	pushd ~/.vim/bundle/vimproc.vim
	make -f make_unix.mak
	popd
fi

guihosts=( aspergoid schizoid ghost )

if [[ $guihosts[(I)`hostname`] != 0 && \
		! -d ~/.local/share/fonts/googlefonts ]]; then
	mkdir -p ~/.local/share/fonts
	pushd ~/.local/share/fonts
	git clone https://github.com/google/fonts googlefonts
	fc-cache -fv
	popd
elif [[ $guihosts[(I)`hostname`] != 0 ]]; then
	pushd ~/.local/share/fonts/googlefonts
	git pull
	fc-cache -fv
	popd
fi
