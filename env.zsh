#!/usr/bin/env zsh

# Home Assistant Devcontainer Setup

HA_SAMBA_USERNAME='homeassistant'
HA_SAMBA_PASSWORD='password'
HA_SAMBA_IP='192.168.75.21'
HA_MOUNT_DIRS=('config', 'backup', 'media', 'share', 'addons', 'addon_configs')

function finddir_basedir(){
    # Helper function to find the base repository directory (pure)
    # Returns by echo, return value indicates git (0) or fallback (1)
    if [[ $(git rev-parse --is-inside-work-tree 2>& /dev/null) == true ]]; then
        # Return through stdo (fd=1)
        printf "%s" $(git rev-parse --show-toplevel)
        return 0
    else
        # Compatibility layer for tarballs
        printf "WARNING: Git repository not detected.\n" >& 2
        printf "Using: %s as the top level directory.\n" $(pwd) >& 2
        # Return through stdo (fd=1)
        printf "%s" $(pwd)
        return 1
    fi
}


function ha_mount_dirs(){
    local ha_samba_username=$1
    local ha_samba_password=$2
    local ha_samba_ip=$3
    local ha_mount_dirs=(${(s:,:)4})

    local basedir=$(finddir_basedir)
    if [[ $? -ne 0 ]]; then
        printf "Git repo not detected.. Using %s as the top level directory." $basedir
    fi

    for dir in ${ha_mount_dirs}
    do
        local target_dir="${basedir}/${dir}"
        if [[ ! -d $target_dir ]]; then
            echo "Creating Dir $target_dir"
            mkdir -p $target_dir
        fi
        echo "Mounting ${target_dir}"
        sudo mount -t cifs \
            -o username=$ha_samba_username,password=$ha_samba_password,uid=1000,gid=1000,file_mode=0664,dir_mode=0755 \
            //${HA_SAMBA_IP}/${dir} ${target_dir}
    done
}

function ha_unmount_dirs(){
    local ha_mount_dirs=(${(s:,:)1})

    local basedir=$(finddir_basedir)
    if [[ $? -ne 0 ]]; then
        printf "Git repo not detected.. Using %s as the top level directory." $basedir
    fi

    for dir in ${ha_mount_dirs}
    do
        local target_dir="${basedir}/${dir}"
        sudo umount $target_dir
    done

}

option_select=$1
option_password=$2
option_ip=$3

if [[ $option_password == '' ]]; then
    echo "Password not specified. Using Default."
    option_password=$HA_SAMBA_PASSWORD
fi

if [[ $option_ip == '' ]]; then
    option_ip=$HA_SAMBA_IP
fi

if [[ $option_select == 'mount' ]]; then
    ha_mount_dirs $HA_SAMBA_USERNAME $option_password $option_ip "${(j:,:)HA_MOUNT_DIRS}"
fi

if [[ $option_select == 'umount' ]]; then
    echo "Unmounting Dirs..."
    ha_unmount_dirs "${(j:,:)HA_MOUNT_DIRS}"
fi


