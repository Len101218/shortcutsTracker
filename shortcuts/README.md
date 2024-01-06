# shortcuts

This is the Flutter source code for this project.

## Installation

### Linux
To install clone this repo and execute: 

`
$ flutter build --release
`

The binary is builded and can be found in `./build/linux/release/bundle/shortcuts`.


In the end add it to the path (in my case `/opt` is in the PATH):


`ln -s /opt/shortcuts $(pwd)/build/linux/release/bundle/shortcuts`

### Windows, ...
As it is flutter, one should be able to build it also on "all" other architectures, but this is untested and no installation guide is given.
