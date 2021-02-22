#!/bin/bash

: '
I occassionally fart around with my dotfiles and have to source them. This
messes up my path. This is how I reset it. There might be a better or more
idiomatic way to do this.

You have to change the config file depending on the shell you use.
'

echo "Old PATH: $PATH"
PATH=$(getconf PATH)
echo "Reset PATH: $PATH"
source ~/.zshrc
echo "New PATH: $PATH"
