#!/bin/bash

# --- Couleurs ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}--- Installation du Dual-GPU Fan Control Bridge ---${NC}"

# 1. Définition des variables
USER_NAME=$USER
USER_HOME=$HOME
PROJECT_ROOT=$(pwd)
BIN_PATH="/usr/local/bin/setup-gpu-fans.sh"
BRIDGE_SRC="$PROJECT_ROOT/scripts/gpu_bridge.sh"
BRIDGE_DEST="$USER_HOME/gpu_bridge.sh"
SETUP_SRC="$PROJECT_ROOT/scripts/setup-gpu-fans.sh"

# 2. Vérification des fichiers
if [[ ! -f "$BRIDGE_SRC" ]] || [[ ! -f "$SETUP_SRC" ]]; then
    echo -e "${RED}Erreur : Scripts sources introuvables dans le dossier /scripts${NC}"
    exit 1
fi

# 3. Préparation du cache
echo -e "${BLUE}[1/4]${NC} Création des dossiers de cache..."
mkdir -p "$USER_HOME/.cache/gpu_temps"

# 4. Installation du script de monitoring utilisateur
echo -e "${BLUE}[2/4]${NC} Installation du script de monitoring GPU..."
cp "$BRIDGE_SRC" "$BRIDGE_DEST"
chmod +x "$BRIDGE_DEST"
# Mise à jour du chemin interne du cache dans le script utilisateur
sed -i "s|TOKEN_USER_HOME|$USER_HOME|g" "$BRIDGE_DEST"

# 5. Installation du script système (root)
echo -e "${BLUE}[3/4]${NC} Installation du bridge système..."
sudo cp "$SETUP_SRC" "$BIN_PATH"
sudo chmod +x "$BIN_PATH"
# Mise à jour des variables utilisateur dans le script root
sudo sed -i "s|TOKEN_USER_NAME|$USER_NAME|g" "$BIN_PATH"
sudo sed -i "s|TOKEN_USER_HOME|$USER_HOME|g" "$BIN_PATH"

# 6. Configuration de la persistance via Cron
echo -e "${BLUE}[4/4]${NC} Ajout de la tâche Cron au démarrage..."
(sudo crontab -l 2>/dev/null | grep -v "setup-gpu-fans.sh" ; echo "@reboot $BIN_PATH") | sudo crontab -

# 7. Installation du raccourci bureau (.desktop)
echo -e "${BLUE}[5/5]${NC} Installation du raccourci bureau..."
DESKTOP_PATH="$USER_HOME/.local/share/applications/fan-control.desktop"
mkdir -p "$USER_HOME/.local/share/applications"

cp "$PROJECT_ROOT/assets/fan-control.desktop" "$DESKTOP_PATH"

# Remplacement dynamique du chemin vers l'exécutable
sed -i "s|Exec=.*|Exec=$USER_HOME/fan-control/target/release/fan-control|g" "$DESKTOP_PATH"

# Donner les droits d'exécution au raccourci
chmod +x "$DESKTOP_PATH"

echo -e "${GREEN}--- Installation terminée ! ---${NC}"
echo -e "Veuillez redémarrer votre machine."
