#!/bin/bash

LIBQRENCODEDIR=$(dirname "$0")
cd ${LIBQRENCODEDIR}
LIBQRENCODEDIR=$(pwd)

if [ -d "${LIBQRENCODEDIR}/libqrencode" ]; then
    echo "${LIBQRENCODEDIR}/libqrencode exists, deleting..."
    rm -fr ${LIBQRENCODEDIR}/libqrencode
fi

echo 'working in directory: ' ${LIBQRENCODEDIR}
build_dir=$LIBQRENCODEDIR/libqrencode
output_dir=$LIBQRENCODEDIR/output/libqrencode
mkdir -p $build_dir

if [ -d "$output_dir" ]; then
    echo "$output_dir exists, deleting..."
    rm -fr $output_dir
fi
mkdir -p $output_dir

cd $build_dir

image_name="ev3dev/ev3dev-jessie-ev3-generic"
container_name="libqrencode"

echo "delete old container..."
docker rm --force $container_name >/dev/null 2>&1 || true

echo "run new container to build..."
docker run \
    --volume "$build_dir:/build" \
    --volume "$output_dir:/output" \
    --workdir /build \
    --name $container_name \
    --tty \
    --detach \
    $image_name tail

echo "setup container build environment..."
# docker exec --tty $container_name apt-get install -y devscripts build-essential lintian
docker exec --tty $container_name /bin/bash -c "sudo apt-get install -y build-essential && \
    sudo apt-get install -y libpng-dev && \
    sudo apt-get install -y pkg-config && \
    cd /build && \
    sudo wget https://fukuchi.org/works/qrencode/qrencode-3.4.4.tar.gz && \
    tar xvf qrencode-3.4.4.tar.gz && \
    cd qrencode-3.4.4 && \
    ./configure && \
    make && \
    make install && \
    cp ./libs/libqrencode.so.3 /output/ && \
    cp ./libs/qrencode /output/"
