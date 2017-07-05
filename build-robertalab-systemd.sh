#!/bin/bash

ROBERTADIR=$(dirname "$0")
cd ${ROBERTADIR}
ROBERTADIR=$(pwd)

if [ -d "${ROBERTADIR}/robertalab-ev3dev" ]; then
    echo "${ROBERTADIR}/robertalab-ev3dev exists, deleting..."
    rm -fr ${ROBERTADIR}/robertalab-ev3dev
fi

echo 'working in directory: ' ${ROBERTADIR}
build_dir=$ROBERTADIR/robertalab-ev3dev
output_dir=$ROBERTADIR/output/robertalab-service
mkdir -p $build_dir

if [ -d "$output_dir" ]; then
    echo "$output_dir exists, deleting..."
    rm -fr $output_dir
fi

mkdir -p $output_dir
cd $build_dir

echo "cloning repository..."
git clone https://github.com/wangtt03/robertalab-ev3dev.git
cd robertalab-ev3dev

image_name="ev3dev/ev3dev-jessie-ev3-generic"
container_name="robertalab-service"

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
docker exec --tty $container_name /bin/bash -c "apt-get install -y devscripts build-essential lintian && \
    apt-get install -y python3-all dh-systemd python3-httpretty && \
    cd /build/robertalab-ev3dev && \
    debuild -us -uc && \
    cp ../*.deb /output/"
