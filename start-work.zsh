#!/bin/zsh

# Open applications.
open /Applications/Firefox.app
open /System/Applications/Notes.app
open /System/Applications/Reminders.app
open /Applications/Slack.app
open /Applications/IntelliJ\ IDEA.app
open /Applications/iTerm.app

# Update repos and navigate to Rosetta's directory.
cd ~/Documents/repositories/phet/
./perennial/bin/pull-all.sh
./perennial/bin/clone-all-missing-repos.sh
