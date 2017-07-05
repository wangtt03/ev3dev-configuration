FROM ev3dev/ev3dev-jessie-ev3-generic

RUN sudo mkdir -p /data/projects/

RUN sudo apt-get update && \
    sudo apt-get install --only-upgrade python3-ev3dev && \
    sudo apt-get install -y python3-pip && \
    sudo apt-get install -y python3-numpy && \
    sudo apt-get install -y python3-scipy && \
    sudo apt-get install -y libpng-dev && \
    sudo apt-get install -y python3-bluez python3-dbus python3-gi

# install qrencode
WORKDIR /data/projects/
RUN sudo wget https://fukuchi.org/works/qrencode/qrencode-3.4.4.tar.gz && \
    tar xvf qrencode-3.4.4.tar.gz && \
    cd qrencode-3.4.4 && \
    ./configure && \
    make && \
    make install && \

COPY ./output/robertalab-service/* /data/projects/robertalab-service/
COPY ./output/brickman/brickman/usr/local/sbin/brickman /usr/local/sbin/
COPY ./output/brickman/brickman/usr/local/share/brickman /usr/local/share/brickman

RUN sudo systemctl unmask openrobertalab.service && \
    sudo systemctl start openrobertalab.service && \
    sudo dpkg -i /data/projects/robertalab-service/openrobertalab_1.7.2+1.0.0_all.deb && \
    sudo systemctl daemon-reload && \
    sudo systemctl restart openrobertalab.service
