#!/bin/bash


tmpdir=$(mktemp -d)
cd $tmpdir

git clone git@github.com:Len101218/shortcutsTracker.git
cd - 
cd "$tmpdir/shortcutsTracker/shortcuts"
flutter build linux
sudo mv build/linux/x64/release/bundle/shortcuts /opt
cd -
