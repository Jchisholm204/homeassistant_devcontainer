# homeassistant_devcontainer
Development Container Framework for working with a Home Assistant Server.
Home Assistant directories are ignored. 
Configuration files should be stored in their own repositories.

# Requirements
- Home Assistant Server on the local network
- IP of Home Assistant
- [Home Assistant SAMBA Share Addon](https://github.com/home-assistant/addons/blob/master/samba/DOCS.md)
- Username and Password configured in the SAMBA addon.

# Usage Instructions
## 1. Clone the Repository
Clone this repository to your development platform (HAOS VM host or personal computer) with:
```sh
git clone https://github.com/Jchisholm204/homeassistant_devcontainer.git
```

## 2. Configure Script Defaults
*Optional:* Configure the default values for running the script.
Parameters can be changed at runtime.

Defaults are set at the top of the `env.sh` script:

```sh
HA_SAMBA_USERNAME='homeassistant'
HA_SAMBA_PASSWORD='password'
HA_SAMBA_IP='192.168.75.21'
HA_MOUNT_DIRS=('config', 'backup', 'media', 'share', 'addons', 'addon_configs')
```

- Username: The username set in the SAMBA share addon
- Password: The password set in the SAMBA share addon (can be configured at launch)
- IP: IP of the Home Assistant (Virtual) Machine (can be configured at launch)
- Mount Dirs: ZSH Style list of HA directories to mount

## 3. Mounting Directories
Once run, the Home Assistant configuration directories will be automatically mounted.

```sh
env.sh mount
```

Launch options can also be specified:
```sh
env.sh mount <optional: password> <optional: ip>
```

## 4. Unmounting Directories

```sh
env.sh umount
```
