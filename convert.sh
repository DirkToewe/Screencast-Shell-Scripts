#!/bin/sh

# Copyright 2014 Dirk Toewe
#
# This file is part of Dirk Toewe's Screencast Shell Scripts.
#
# The Screencast Shell Scripts are free software: you can redistribute
# it and/or modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
# 
# Game of Pyth is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with the Shell Scripts. If not, see <http://www.gnu.org/licenses/>.

# CONVERTS THE VIDEO TO A COMPRESSED FORMAT. I USALLY GO FOR VP8 AS CODEC SINCE IT IS ROYALTY FREE.
warning(){
  echo "\033[31m$1\033[0m"
}
# MAIN()
# check input
if [ "$#" -ne 1 ]
  then
    warning "One argument required: Source file"
    exit
fi
src=$1
# input file existence check
if [ ! -f "$src" ]
  then
    warning "Source file not found: \"$src\""
    exit
fi
target=${src%.*}.webm
# overwrite check
if [ -f "$target" ]
  then
    warning "Target file already exists: \"$target\""
    while true; do
      read -p "Overwrite? [y\N]" yn
      case $yn in
        [Yy]  ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer with [y]es or [n]o";;
      esac
    done
fi
nthreads=$(nproc)
echo "Source: \"$src\""
echo "Target: \"$target\""
echo "Threads: $nthreads"
avconv \
  -i "$src" \
  -map 0:0 \
  -map 0:1 \
  -map 0:2 \
    -c copy \
    -vcodec libvpx \
    -s hd1080 \
    -qmin 0 \
    -qmax 16 \
    -crf 4 \
    -b:v 16M \
    -deadline best \
    -threads "$nthreads" \
    "$target"
