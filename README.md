# Linux Dual-GPU Fan Control Bridge

Ce projet permet de piloter des ventilateurs système (via une puce IT8686/IT8792) en fonction de la température de deux GPU NVIDIA, même si ces derniers ne sont pas exposés nativement dans `lm-sensors`.

## Fonctionnement
Le système utilise un "Mount Bind" pour injecter les températures récupérées via `nvidia-smi` directement dans les registres vides (N/A) des puces de monitoring de la carte mère sous `/sys/class/hwmon`.

## Prérequis
- **Pop!_OS** ou toute distribution basée sur Ubuntu/Debian.
- Pilotes **NVIDIA** installés.
- L'application **Fan Control** (compilée en Rust) située dans `~/fan-control`.

## Structure des fichiers
- `setup-gpu-fans.sh` : Script maître (root) qui localise les puces et effectue les montages système.
- `gpu_bridge.sh` : Script utilisateur qui tourne en arrière-plan pour mettre à jour les températures.
- `install.sh` : Script d'automatisation de l'installation.

## Installation
1. Clonez ce dépôt ou copiez les fichiers.
2. Lancez l'installation :
   ```bash
   chmod +x install.sh
   ./install.sh
