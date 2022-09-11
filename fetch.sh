#!/bin/bash -e


. ./install

echo "Fetching image: ${SRC} ..."
wget -qO src.qcow2 "$SRC"
