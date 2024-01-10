#!/bin/bash


tmpdir=$(mktemp -d)
cd $tmpdir

git clone git@github.com:Len101218/shortcutsTracker.git
cd - 
cd "$tmpdir/shortcutsTracker/shortcuts"
flutter build linux
sudo install -m 755 -d /usr/local/bin/shortcuts_dir
sudo cp -r build/linux/x64/release/bundle/* /usr/local/bin/shortcuts_dir
sudo ln -s /usr/local/bin/shortcuts_dir/shortcuts /usr/local/bin/shortcuts
cd -
