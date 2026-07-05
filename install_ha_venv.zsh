#!/usr/bin/env zsh

VENV_INSTALL_DIR=$(pwd)
VENV_INSTALL_NAME='.venv_ha'

function question(){
    local PROMPT=$1
    local ans='-'
    until [[ $ans == 'y' || $ans == 'n' ]]; do
        printf "%s [y/n]: " "$PROMPT"
        read -r ans
    done
    if [[ $ans == 'y' ]]; then
        return 0
    else
        return 1
    fi
}


if question 'Install Fedora Dependencies'; then
    sudo dnf update
    sudo dnf install python3-pip python3-devel python3-virtualenv autoconf openssl-devel libxml2-devel libxslt-devel libjpeg-turbo-devel libffi-devel systemd-devel zlib-devel pkgconf-pkg-config libavformat-free-devel libavcodec-free-devel libavdevice-free-devel libavutil-free-devel libswscale-free-devel ffmpeg-free-devel libavfilter-free-devel ffmpeg-free gcc gcc-c++ cmake
else
    echo "You Must Install the Required dependencies to continue"
    echo "https://developers.home-assistant.io/docs/development_environment"
    if question 'exit now?'; then
        exit 0
    fi
fi

echo "Cloning Home Assistant Core"

git clone https://github.com/home-assistant/core.git

echo "Creating Python Virtual Environment $VENV_INSTALL_NAME in $VENV_INSTALL_DIR"

python3 -m venv "${VENV_INSTALL_DIR}/${VENV_INSTALL_NAME}"

source "${VENV_INSTALL_DIR}/${VENV_INSTALL_NAME}/bin/activate"

echo "Installing Dependencies"

python3 -m pip install uv

uv pip install \
    -e ./core \
    -r ./core/requirements_all.txt \
    -r ./core/requirements_test.txt \
    colorlog \
    --upgrade

echo "Done."
echo "Source ${VENV_INSTALL_DIR}/${VENV_INSTALL_NAME}/bin/activate"
