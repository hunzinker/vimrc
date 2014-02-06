#!/usr/bin/env sh

git submodule foreach git pull origin master

cd ~/.vim/bundle/command-t/ruby/command-t
ruby extconf.rb
make
