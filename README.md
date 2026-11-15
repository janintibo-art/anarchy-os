# Anarchy OS v1 — véritable base système ARM64

**Attention : ce projet ne doit pas être flashé sur un téléphone Samsung.**

Première étape d'un système expérimental à identité propre : noyau Linux ARM64, rootfs minimal, shell et un programme de diagnostic original écrit en C.

## Ce qui fonctionne (après compilation)
- Image Linux ARM64 destinée à la machine virtuelle QEMU `virt`.
- Console Linux et application native `anarchy` avec les commandes `help`, `info`, `cpu`, `mem`, `net`, `sensors`, `mounts` et `exit`.
- Compilation sur Ubuntu 24.04 ou via Actions (workflow manuel disponible).

## Compiler sur Linux (PC / WSL2)
```bash
sudo apt update
sudo apt install -y build-essential libncurses-dev file wget cpio unzip rsync bc libssl-dev python3 git xz-utils qemu-system-arm
./scripts/build.sh
./scripts/run-qemu.sh
```

Dans la console QEMU, identifiant **root** (pas de mot de passe dans cette version de laboratoire), puis commande `anarchy`.

Pour sortir de QEMU sans interface graphique : `Ctrl+A` puis `X`.

## Publier depuis Termux
```bash
pkg update
pkg install -y git gh unzip
termux-setup-storage
unzip ~/storage/downloads/anarchy-os_v1.zip -d ~/
cd ~/anarchy-os
gh auth status || gh auth login
git init
git add .
git commit -m 'Anarchy OS v1 - base Linux ARM64 QEMU'
git branch -M main
gh repo create anarchy-os --public --source=. --remote=origin --push
```
Pour le workflow, ouvrir GitHub > Actions > Anarchy OS ARM64 QEMU > Run workflow.

## Objectif S20 FE
Le SM-G780F est basé sur Exynos 990 ; la configuration QEMU **ne doit jamais être flashée**. Avant un port sur appareil réel : vérification de la référence, réparation USB, déverrouillage officiel du bootloader si possible, cartographie des partitions, analyse du device tree et adaptation du noyau, des pilotes, du boot/vendor_boot et de l'affichage. Des micrologiciels propriétaires peuvent rester nécessaires. Sauvegarder les images d'origine et prévoir une procédure de restauration avant tout essai.

## Roadmap
- v2 : interface framebuffer et diagnostics plus complets.
- v3 : adaptation du noyau et pilotes au S20 FE (après identification).
- v4 : démarrage sur appareil de test, sans compatibilité APK/EXE garantie.
- v5+ : compatibilité Android (nécessite runtime dédié) et Wine/Box64 (compatibilité partielle), Wi-Fi, Bluetooth et gestion matérielle.

## Remarques
Buildroot sert d'outillage de compilation et de construction de rootfs. L'interface et les programmes Anarchy OS ne sont pas une ROM modifiée. Les sources Linux, Buildroot et leurs licences doivent être respectées lors de la distribution.
