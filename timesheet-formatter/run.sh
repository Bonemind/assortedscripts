#!/usr/bin/env bash

# load rvm ruby
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

bundle exec ruby main.rb -w -m -d timesheet
