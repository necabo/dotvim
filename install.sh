#!/bin/bash

if ! ( hash git 2>/dev/null )
then
    echo Please install git
    exit 1
fi


declare -a PLUGINS=(
    "https://github.com/tpope/vim-sensible"                     # sensible
    "https://github.com/vim-airline/vim-airline"                # light status
    "https://github.com/vim-airline/vim-airline-themes"         # airline themes
    "https://github.com/tpope/vim-fugitive"                     # git
    "https://github.com/vim-syntastic/syntastic"                # syntax checks
    "https://github.com/wagnerf42/vim-clippy"                   # rust clippy
    "https://github.com/scrooloose/nerdtree"                    # find files
    "https://github.com/Xuyuanp/nerdtree-git-plugin"            # add git status for filetree
    "https://github.com/tpope/vim-surround"                     # wrap blocks
    "https://github.com/SirVer/ultisnips"                       # snippet base
    "https://github.com/honza/vim-snippets"                     # snippets
    "https://github.com/jiangmiao/auto-pairs"                   # close brackets
    "https://github.com/junegunn/fzf"                           # fuzzy find
    "https://github.com/kien/ctrlp.vim"                         # even more
    "https://github.com/tpope/vim-commentary"                   # bulk comments
    "https://github.com/prabirshrestha/async.vim"               # used for rust plugin
    "https://github.com/prabirshrestha/vim-lsp"                 # used for rust plugin
    "https://github.com/prabirshrestha/asyncomplete.vim"        # used for rust plugin
    "https://github.com/prabirshrestha/asyncomplete-lsp.vim"    # used for rust plugin
    "https://github.com/rust-lang/rust.vim.git"                 # lots of neat rust features
    "https://github.com/Valloric/YouCompleteMe"                 # autocompletion
    "https://github.com/ludovicchabant/vim-gutentags"           # tag file management
    "https://github.com/majutsushi/tagbar"                      # tagbar

    "https://github.com/NLKNguyen/papercolor-theme"             # color scheme

    "https://github.com/necab0/vimsence"                        # discord rich presence
)

GIT_CLONE="git clone --depth 1"
VIMRC=~/.vimrc
DOTVIM=~/.vim

echo "Should I drop all existing plugins?"
read -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    rm -rf $DOTVIM/autoload/pathogen.vim
    mkdir $DOTVIM/autoload
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    rm -rf $DOTVIM/bundle/*
fi

echo "If you proceed I will wipe your $VIMRC"
read -p "Are you sure? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    rm $VIMRC
    ln -s $DOTVIM/vimrc $VIMRC
    for URL in "${PLUGINS[@]}"
    do
        PLUGIN=`printf -- "%s" "${URL##*/}"`
        if [ -d "./bundle/$PLUGIN" ]; then
           echo Already installed: $PLUGIN
        else
            echo Installing plugin: $PLUGIN
            $GIT_CLONE $URL ./bundle/$PLUGIN
        fi
    done
fi

# YouCompleteMe installation (configure for other languages)
cd $DOTVIM/bundle/YouCompleteMe
git submodule update --init --recursive
./install.sh --rust-completer
