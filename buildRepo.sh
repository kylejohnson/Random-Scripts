#!/bin/sh

# This script is for building a debian / ubuntu repo from a directory full of packages.

REPO=/var/www/repo/

cd $REPO && rm -f Packages.gz Packages Release && apt-ftparchive packages . > Packages && apt-ftparchive release . > Release && rm -f Release.gpg && gpg --no-tty --batch --trust-model always -abs -o Release.gpg Release && gzip -c Packages > Packages.gz
