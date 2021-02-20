#!/bin/bash

: '
This script is meant to be run in a directory that contains Git repos. It 
finds Git repos recursively and prints a message that indicates the status of
each repo it finds.
'

check_status() {
	
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
				(( NUM_REPOS++ ))
				echo $FILE
				cd $FILE
				indicate_status $FILE
				cd ..
			fi

			# Check subdirectories for Git repos.
			check_status $FILE
		fi
	done
}

indicate_status() {

	# Set boolean for if repos are good.
	GOOD=1	

	# Check for modified files.
	if [ $(git status | grep -c "modified") -ne 0 ]
	then
		GOOD=0
		echo -en "\033[0;31m"
		echo ":( There exist modified files."
		echo -en "\033[0m"
	fi

	# Check for untracked files.
	if [ $(git status | grep -c "Untracked") -ne 0 ]
	then
		GOOD=0
		echo -en "\033[0;31m"
		echo ":( There exist untracked files."
		echo -en "\033[0m"
	fi

	# Check for changes that haven't been staged.
	if [ $(git status | grep -c "Changes not staged") -ne 0 ]
	then
		GOOD=0
		echo -en "\033[0;31m"
		echo ":( You have unstaged changes."
		echo -en "\033[0m"
	fi

	# Check for changes that haven't been committed.
	if [ $(git status | grep -c "Changes to be committed") -ne 0 ]
	then
		GOOD=0
		echo -en "\033[0;31m"
		echo ":( You have uncommitted changes."
		echo -en "\033[0m"
	fi

	# Check for changes that haven't been pushed.
	if [ $(git status | grep -c "Your branch is ahead") -ne 0 ]
	then
		GOOD=0
		echo -en "\033[0;31m"
		echo ":( You have an unpushed commit."
		echo -en "\033[0m"
	fi

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

# For counting number of repos checked.
NUM_REPOS=$(( 0 ))

# Call the function!
check_status $DIR

# Print number of repos checked.
echo "${NUM_REPOS} repos checked."
