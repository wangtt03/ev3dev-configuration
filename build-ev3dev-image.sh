#!/bin/bash

EV3DEVDIR=$(dirname "$0")
cd ${EV3DEVDIR}
EV3DEVDIR=$(pwd)

rm -fr $EV3DEVDIR/output/*

./build-robertalab-systemd.sh
./build-brickman.sh
./build-qrencode.sh

docker build -t csdiregistry.azurecr.io/ev3dev-jessie-ev3-stem -f ev3dev-jessie-stem.dockerfile .

build_dir=${EV3DEVDIR}/brickstrap
if [ -d "$build_dir" ]; then
    echo "$build_dir exists, deleting..."
    rm -fr $build_dir
fi
mkdir -p $build_dir
cd $build_dir

brickstrap create-tar csdiregistry.azurecr.io/ev3dev-jessie-ev3-stem ev3dev.tar
brickstrap create-image ev3dev.tar ev3dev.img

azcopy \
    --source $build_dir \
    --destination https://csdistg.blob.core.windows.net/ev3images \
    --dest-key vv2ZKUmod9oqdKBI7oWnMcPcd5HP0S6VIva8U9QQL/s6SLG1i55la6dKV7qLeMiX6FyxIQFTldGeyOeDCE7JsQ== \
    --include "ev3dev.img"
