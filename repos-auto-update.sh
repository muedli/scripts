#!/bin/bash

: '
This script is meant to be run in a directory that contains Git repos. It 
finds Git repos recursively and adds, commits, and pushes changes in them.
'

auto_update() {

    # The first argument to the function is the directory.
    DIR=$1

    # Loop over each file in the directory.
    for FILE in $DIR/*
    do

        # If the file is a directory...
        if [ -d $FILE ]
        then

            # If the directory is a Git repo...
            if [ -d $FILE/.git ]
            then
                echo -en "\033[0;35m"
                echo "Updating $FILE via script."
                echo -en "\033[0m"
                cd $FILE
                git add -A
                git commit -m "Updated via script."
                git push
                cd ../
            fi

            # Auto-update repos in subdirectories.
            auto_update $FILE
        fi
    done
}

# Get the directory supplied to the script.
DIR=$1

# If no directory has been supplied, use working directory.
if [ -z $DIR ]
then
    DIR="`pwd`"
fi

# Auto-update Git repos!
auto_update $DIR
