#!/bin/bash

EV3DEVDIR=$(dirname "$0")
cd ${EV3DEVDIR}
EV3DEVDIR=$(pwd)

rm -fr $EV3DEVDIR/output/*

./build-robertalab-systemd.sh
./build-brickman.sh
./build-qrencode.sh

docker build -t ev3dev/ev3dev-jessie-ev3-stem -f ev3dev-jessie-stem.dockerfile

if [ -d "${EV3DEVDIR}/brickstrap" ]; then
    echo "${EV3DEVDIR}/brickstrap exists, deleting..."
    rm -fr ${EV3DEVDIR}/brickstrap
fi

build_dir=${EV3DEVDIR}/brickstrap
mkdir -p $build_dir
cd $build_dir

git clone https://github.com/wangtt03/brickstrap.git
rm -f ev3dev.tar
rm -f ev3dev.img
./brickstrap/src/brickstrap.sh create-tar csdiregistry.azurecr.io/ev3dev-jessie-ev3-base-my2 ev3dev.tar
./brickstrap/src/brickstrap.sh create-image ev3dev.tar ev3dev.img
