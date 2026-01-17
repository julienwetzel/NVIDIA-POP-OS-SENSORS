#!/bin/bash
# Localisation dynamique et montage des capteurs virtuels

sleep 10  # Attente de l'initialisation des drivers

# 1. Localisation des dossiers hwmon par nom de puce
H_IT8686=$(grep -l "it8686" /sys/class/hwmon/hwmon*/name | head -n 1 | rev | cut -d/ -f2 | rev)
H_IT8792=$(grep -l "it8792" /sys/class/hwmon/hwmon*/name | head -n 1 | rev | cut -d/ -f2 | rev)

# 2. Préparation de l'espace de stockage
USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)
[ -z "$USER_HOME" ] && USER_HOME="/home/jwl" # Fallback pour ton utilisateur spécifique

mkdir -p $USER_HOME/.cache/gpu_temps
chown -R $(ls -ld $USER_HOME | awk '{print $3":"$4}') $USER_HOME/.cache/gpu_temps

# 3. Montages Bind
if [ -n "$H_IT8792" ]; then
    mount --bind $USER_HOME/.cache/gpu_temps/gpu1 /sys/class/hwmon/$H_IT8792/temp2_input
fi

if [ -n "$H_IT8686" ]; then
    mount --bind $USER_HOME/.cache/gpu_temps/gpu2 /sys/class/hwmon/$H_IT8686/temp6_input
fi

# 4. Lancement du script de monitoring
su - jwl -c "$USER_HOME/gpu_bridge.sh &"
