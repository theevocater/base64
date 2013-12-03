#!/bin/bash

. /usr/local/share/chruby/chruby.sh
export RUBIES=($HOME/.rubies/*)
chruby 2.0.0
ruby main.rb
