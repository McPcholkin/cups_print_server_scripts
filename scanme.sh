#!/bin/sh
outscan="scan-`date +"%Y-%m-%d_%H-%M-%S"`"
scanimage --progress --mode Color --format=tiff --resolution 300 > /tmp/image.tiff
convert /tmp/image.tiff -crop 2500x3500+0 /srv/share/Scanner/${outscan}.jpg
rm /tmp/image.tiff
exit 0
