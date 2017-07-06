#!/bin/bash

EV3DEVDIR=$(dirname "$0")
cd ${EV3DEVDIR}
EV3DEVDIR=$(pwd)

echo "clean output directory..."
rm -fr $EV3DEVDIR/output/*

echo "build robertalab systemd service..."
./build-robertalab-systemd.sh

echo "build brickman..."
./build-brickman.sh

echo "build qrencode..."
./build-qrencode.sh

echo "build docker image..."
docker build -t csdiregistry.azurecr.io/ev3dev-jessie-ev3-stem -f ev3dev-jessie-stem.dockerfile .

build_dir=${EV3DEVDIR}/brickstrap
if [ -d "$build_dir" ]; then
    echo "$build_dir exists, deleting..."
    rm -fr $build_dir
fi
mkdir -p $build_dir
cd $build_dir

echo "create tar file from docker image..."
brickstrap create-tar csdiregistry.azurecr.io/ev3dev-jessie-ev3-stem ev3dev.tar
echo "create bootimage from tar..."
brickstrap create-image ev3dev.tar ev3dev.img
imageName=ev3dev_`date +%Y_%m_%d_%H_%M_%S`
mv ev3dev.img $imageName.img
tar -czvf $imageName.tar.gz $imageName.img

echo "update bootimage to azure storage..."
azcopy \
    --source $build_dir \
    --destination https://csdistg.blob.core.windows.net/ev3images \
    --dest-key vv2ZKUmod9oqdKBI7oWnMcPcd5HP0S6VIva8U9QQL/s6SLG1i55la6dKV7qLeMiX6FyxIQFTldGeyOeDCE7JsQ== \
    --include "$imageName.tar.gz"
