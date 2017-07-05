#!/bin/bash

BRICKMANDIR=$(dirname "$0")
cd ${BRICKMANDIR}
BRICKMANDIR=$(pwd)

if [ -d "${BRICKMANDIR}/brickman" ]; then
    echo "${BRICKMANDIR}/brickman exists, deleting..."
    rm -fr ${BRICKMANDIR}/brickman
fi

echo 'working in directory: ' ${BRICKMANDIR}
build_dir=$BRICKMANDIR/brickman
mkdir -p $build_dir
cd $build_dir

echo "cloning repository..."
git clone https://github.com/wangtt03/brickman.git
cd brickman
git checkout -b ev3dev-jessie origin/ev3dev-jessie
git submodule update --init --recursive

dist_dir=$BRICKMANDIR/brickman/brickman/dist
if [ -d "$dist_dir" ]; then
    echo "$dist_dir exists, deleting..."
    rm -fr $dist_dir
fi
mkdir -p $dist_dir

./docker/setup.sh $dist_dir armel
docker exec --tty brickman_armel make install

output_dir=$BRICKMANDIR/output/brickman
if [ -d "$output_dir" ]; then
    echo "$output_dir exists, deleting..."
    rm -fr $output_dir
fi
mkdir -p $output_dir

cp -r $dist_dir/dist $output_dir
