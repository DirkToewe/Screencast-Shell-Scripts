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

if [ "$#" -ne 1 ]
  then
    echo "\033[31mOne argument required: Screencast name\033[0m"
    exit
fi
target="$1 $(date +%d.%m.%Y\ %H:%M).mkv"
avconv \
  -f pulse -ac 2 -ar 44100 \
  -i alsa_output.pci-0000_00_14.2.analog-stereo.monitor \
  -f pulse -ac 2 -ar 44100 \
  -i alsa_input.usb-Samson_Technologies_Samson_C01U-00-C01U.analog-stereo \
  -f x11grab \
  -show_region 1 \
  -s hd720 \
  -i :0.0+0,0 \
  -map 0:0 \
  -map 1:0 \
  -map 2:0 \
  -ab 256k \
  -ar 44100 \
  -acodec libvorbis \
  -vcodec huffyuv \
  -r:v 30 \
  -threads auto \
  "$target"

# LINE 26: alternatively to 'avconv' from the library LibAV, 'ffmpeg' can be used
# LINE 27-28: Record the computer's output, two channel source (-ac 2) sampled with ~44kHz (-ar)
# LINE 29-30: Record the computer's microphone, two channel source (-ac 2) sampled with ~44kHz (-ar) (The audio device's name needs to be #             adjusted, find audio sources and their properties by: $ pactl list sources)
# LINE 31: Record the screen. 
# LINE 32: Draws a frame around the region being recorded.
# LINE 33: The size of the recorded region
# LINE 34: Recorded screen number and position of the recorded region
#          "-i :0.0+x,y" The 0.0 (first "desktop") and the x and y offset of the recorded frame. Keep in mind that multiple screens
#          are still one "desktop" for X11
# LINE 35-37: Probably the coolest part of the recording script: Map the channels 0,1,2 (Audio Out,Microphone,Video) to the output. #             Microphone and Audio Out are recorded on separate audio tracks and can be merged with a video editing tool
# LINE 38: The recording/output audio bitrate
# LINE 39: The recording/output audio frequency
# LINE 40: The audio codec
# LINE 41: The video codec. huffyuv is fast and afaik lossless but requires a lot of a lot of disk space
# LINE 42: Video frame rate
# LINE 43: Allows for multithreading

# For more info, please consuld the LibAV documentation: https://libav.org/avconv.html

# FIND OUT AUDIO SOURCES AND THEIR ATTRIBUTES BY: $ pactl list sources
# "-ac": number of audio channels
# "-ar": the audio sample rate (you can use k for *1000)
# "-ab": the audio bitrate (you can use k for *1000)
# "-s": the resultion of the recorded frame
# "-i :0.0+x+y" The 0.0 (first "desktop") and the x and y offset of the recorded frame
# "map 0:0" take the first output from 0:0 (first input)
# "-r:v": the frame rate
