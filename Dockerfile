# Using the maintained version of Ubuntu Focal from LinuxServer.io
# Using Ubuntu instead of Alpine because Ubuntu handles UDEV rules
# better and is what this was originally designed for
FROM ghcr.io/linuxserver/baseimage-ubuntu:focal-eaf6125b-ls65

# Creates user abc and adds to cdrom group for access to the disk readers
RUN useradd -m abc -g abc -G cdrom

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Install Python3 if not already installed
RUN apt update && \
    apt install -y python3 && \
    python3 -m ensurepip

# Install the Python requirements for the application
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Update and install base software for media ripping
RUN add-apt-repository ppa:stebbins/handbrake-releases && \
    apt update && \
    apt install -y handbrake-cli libavcodec-extra abcde flac \
    imagemagick glyrc cdparanoia \
    at ffmpeg \
    avahi-daemon \
    libcurl4-openssl-dev libssl-dev \
    libdvd-pkg default-jre-headless \
    git

# Install MakeMKV
RUN add-apt-repository ppa:heyarje/makemkv-beta && \
    apt-get update && \
    apt-get install -y makemkv-bin makemkv-oss ccextractor && \
    apt-get -y autoremove


COPY root/ /
RUN chmod +x /etc/*/*