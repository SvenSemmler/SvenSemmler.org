#!/bin/bash

OS_TYPE="$(uname)"

if [ "$OS_TYPE" = "Darwin" ]; then
    echo "Running on macOS"

    source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
    source /opt/homebrew/opt/chruby/share/chruby/auto.sh
    chruby ruby-3.1.7

elif [ "$OS_TYPE" = "Linux" ]; then
    echo "Running on Linux"

    source ~/.bashrc
    rbenv global 3.1.7
else
    echo "Unknown OS: $OS_TYPE"
fi

ruby -v
bundle exec jekyll serve
