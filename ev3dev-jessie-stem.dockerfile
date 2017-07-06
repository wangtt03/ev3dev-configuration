FROM ev3dev/ev3dev-jessie-ev3-generic

RUN sudo apt-get update && \
    sudo apt-get install --only-upgrade python3-ev3dev && \
    sudo apt-get install -y python3-pip && \
    sudo apt-get install -y pkg-config && \
    sudo apt-get install -y python3-numpy && \
    sudo apt-get install -y python3-scipy && \
    sudo apt-get install -y libpng-dev && \
    sudo apt-get install -y python3-bluez python3-dbus python3-gi

COPY ./output/robertalab-service/openrobertalab_1.7.2+1.0.0_all.deb /data/projects/robertalab-service/
COPY ./output/brickman/dist/usr/local/sbin/brickman /usr/local/sbin/
COPY ./output/brickman/dist/usr/local/share/brickman /usr/local/share/brickman
COPY ./output/libqrencode/qrencode /usr/bin/
COPY ./output/libqrencode/libqrencode.so.3 /usr/lib/

RUN sudo dpkg -i /data/projects/robertalab-service/openrobertalab_1.7.2+1.0.0_all.deb
RUN sudo systemctl unmask openrobertalab.service
