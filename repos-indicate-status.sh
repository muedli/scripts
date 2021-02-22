#!/bin/bash

# TODO: If you have time, you could try using the short format.
# https://git-scm.com/docs/git-status#_short_format

: '
This script is meant to be run in a directory that contains Git repos. It 
finds Git repos recursively and prints a message that indicates the status of
each repo it finds.
'

find_repos() {
	
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
				(( REPO_INDEX++ ))
				echo "$REPO_INDEX - $FILE"
				cd $FILE
				indicate_status $FILE
				cd ..
			fi

			# Check subdirectories for Git repos.
			find_repos $FILE
		fi
	done
}

indicate_status() {

	# Set boolean for if repos are good.
	GOOD=1	

	# Check for untracked files.
	if [ $(git status | grep -c "Untracked") -ne 0 ]
	then
		GOOD=0
		echo -en "\033[0;31m"
		echo ":( You have untracked file(s)."
		echo -en "\033[0m"
	fi
	
	# Check for changes that haven't been staged.
	if [ $(git status | grep -c "Changes not staged") -ne 0 ]
	then
		GOOD=0
		echo -en "\033[0;31m"
		echo ":( You have unstaged change(s)."
		echo -en "\033[0m"
	fi

	# Check for changes that haven't been committed.
	if [ $(git status | grep -c "Changes to be committed") -ne 0 ]
	then
		GOOD=0
		echo -en "\033[0;31m"
		echo ":( You have uncommitted change(s)."
		echo -en "\033[0m"
	fi

	# Check for changes that haven't been pushed.
	if [ $(git status | grep -c "Your branch is ahead") -ne 0 ]
	then
		GOOD=0
		echo -en "\033[0;31m"
		echo ":( You have unpushed changes(s)."
		echo -en "\033[0m"
	fi

	# If none of the above conditions are met, we're good to go.
	if [ $GOOD -eq 1 ]
	then
		echo -en "\033[0;32m"
		echo ":) All is well."
		echo -en "\033[0m"
	fi
}

# Get the directory supplied to the script.
DIR=$1

# If no directory has been supplied, use working directory.
if [ -z $DIR ]
then
	DIR="`pwd`"
fi

# For indexing repos.
REPO_INDEX=$(( 0 ))

# Find repos and indicate their status!
find_repos $DIR
