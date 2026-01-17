#!/bin/bash
# Script de mise à jour des températures GPU pour le bridge hwmon

while true; do
  # Récupération des températures via NVIDIA-SMI
  T1=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits -i 0)
  T2=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits -i 1)
  
  # Mise à jour des fichiers temporaires (utilisés par le mount bind)
  echo $((T1 * 1000)) > $HOME/.cache/gpu_temps/gpu1 2>/dev/null
  echo $((T2 * 1000)) > $HOME/.cache/gpu_temps/gpu2 2>/dev/null
  
  sleep 2
done
