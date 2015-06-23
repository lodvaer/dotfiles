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

mkdir -p ~/.gnupg
ln -f gpg.conf ~/.gnupg/gpg.conf
ln -f zshrc.local ~/.zshrc.local
ln -f gitconfig ~/.gitconfig
ln -f ghci ~/.ghci
ln -f vimrc ~/.vimrc
ln -f gvimrc ~/.gvimrc
mkdir -p ~/.config/herbstluftwm
ln -f herbst_autostart ~/.config/herbstluftwm/autostart
ln -f herbst_panel.sh ~/.config/herbstluftwm/panel.sh
rsync -av --link-dest=$PWD .xkb/ ~/.xkb

cp solarized/xresources/solarized ~/.Xresources
sed s/002b36/001b26/ -i ~/.Xresources

if [[ ! -d ~/.vim/bundle/Vundle.vim ]]; then
	mkdir -p ~/.vim/bundle
	git clone https://github.com/gmarik/Vundle.vim.git \
		~/.vim/bundle/Vundle.vim
	vim +PluginInstall +qa'!'
	pushd ~/.vim/bundle/vimproc.vim
	make -f make -f make_unix.mak
	popd
fi

guihosts=( aspergoid schizoid )

if [[ $guihosts[(I)`hostname`] != 0 && \
		! -d ~/.local/share/fonts/googlefontdirectory ]]; then
	mkdir -p ~/.local/share/fonts
	git clone https://github.com/w0ng/googlefontdirectory
	fc-cache -fv
elif [[ $guihosts[(I)`hostname`] != 0 ]]; then
	cd ~/.local/share/fonts/googlefontdirectory
	git pull
	fc-cache -fv
fi
