# Linux Dual-GPU Fan Control Bridge 🚀

Ce projet permet de piloter les ventilateurs d'un ordinateur (via les puces de monitoring de la carte mère) en utilisant les températures de **deux cartes graphiques NVIDIA**.

Cette solution résout un problème courant sous Linux : les applications de gestion de ventilateurs ne voient souvent que le CPU ou les capteurs de la carte mère, ignorant les GPU NVIDIA (qui ne sont pas exposés nativement dans `lm-sensors`).

## 🛠️ Comment ça fonctionne ?

Le système utilise une technique de **"Mount Bind"** au niveau du noyau :

1. Un script récupère les températures des deux GPU via `nvidia-smi`.
2. Ces valeurs sont écrites dans des fichiers de cache locaux.
3. Le système "monte" (superpose) ces fichiers directement sur des registres de température vides (affichant `N/A`) des puces **IT8686** et **IT8792** dans `/sys/class/hwmon`.
4. L'application de contrôle (Fan Control) voit alors les GPU comme des capteurs matériels natifs.

## 📋 Prérequis

* **Système :** Pop!_OS (ou toute distribution Linux avec un noyau récent).
* **Hardware :** Deux GPU NVIDIA (ex: GTX 1080) et des puces de monitoring compatibles (IT8686 / IT8792).
* **Pilotes :** NVIDIA propriétaires installés (`nvidia-smi` fonctionnel).
* **Logiciel de contrôle :** L'application [Fan Control](https://github.com/wiiznokes/fan-control) (version Rust) située dans `~/fan-control`.

## 📂 Structure du Projet

```text
.
├── install.sh              # Script d'installation automatique
└── scripts/
    ├── gpu_bridge.sh       # Script utilisateur de monitoring (arrière-plan)
    └── setup-gpu-fans.sh   # Script système de montage (exécuté au boot)

```

## 🚀 Installation

1. **Cloner le dépôt :**
```bash
git clone https://github.com/ton-username/votre-depot.git
cd votre-depot

```


2. **Lancer l'installation :**
```bash
chmod +x install.sh
./install.sh

```


3. **Redémarrer :** Le script configure une tâche `cron` pour que les capteurs soient prêts dès le démarrage du système.

## ⚙️ Configuration dans l'application

Une fois l'ordinateur redémarré :

1. Lancez votre application **Fan Control**.
2. Les capteurs apparaîtront sous les noms suivants (selon votre configuration) :
* **GPU 1 :** Capteur `temp2` sur la puce `it8792`.
* **GPU 2 :** Capteur `temp6` sur la puce `it8686`.


3. Vous pouvez maintenant créer des courbes de ventilation qui réagissent dynamiquement à la température la plus haute entre votre CPU et vos deux GPU.

## 🧩 Avantages de cette méthode

* **Persistance :** Grâce à la localisation dynamique, les capteurs sont retrouvés même si les numéros `hwmon` changent au redémarrage.
* **Légèreté :** Les scripts consomment moins de 1% de CPU.
* **Compatibilité :** Pas besoin de modifier le code source de vos applications de monitoring préférées.

## ⚠️ Notes importantes

* Le script `install.sh` adapte automatiquement les chemins de fichiers à votre utilisateur actuel.
* Ne modifiez pas le dossier `/scripts` après l'installation, car il sert de source pour les mises à jour du système.

---

### Pourquoi ne pas utiliser un lien symbolique ?

Le système de fichiers `/sys` est virtuel et géré par le noyau. Il refuse la création de liens symboliques même en `sudo`. La méthode `mount --bind` est la seule technique logicielle capable d'injecter des données dans cet espace protégé.
