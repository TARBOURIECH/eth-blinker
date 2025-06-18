#!/bin/bash
#====================================================
# Nom du script : git_version.sh
# Chemin : /chemin/vers/git_version.sh
# Description : Script interactif pour versionner un projet Git ou faire un commit simple
# Options : Aucun argument requis
# Exemple : ./git_version.sh
# Prérequis : Git installé, dépôt Git initialisé ou initialisable
# Auteur : Sylvain SCATTOLINI
# Date de création : 2025-06-13
# Version : 1.2
#====================================================

# 🔍 Vérifie si Git est installé
if ! command -v git &>/dev/null; then
  echo "❌ La commande 'git' est introuvable."
  read -p "⚙️  Voulez-vous installer 'git' maintenant ? (o/N) : " INSTALL
  if [[ "$INSTALL" =~ ^[oO]$ ]]; then
    sudo apt update && sudo apt install -y git || {
      echo "❌ L'installation a échoué."
      exit 1
    }
  else
    echo "🚫 Installation annulée."
    exit 1
  fi
fi

# 🔐 Configuration pour mémoriser les identifiants
git config --global credential.helper store

# 🔧 Vérifie si on est dans un dépôt Git
if [ ! -d .git ]; then
  echo "❌ Ce dossier n'est pas encore un dépôt Git."
  read -p "➕ Voulez-vous initialiser un dépôt Git ici ? (o/N) : " INIT
  if [[ "$INIT" =~ ^[oO]$ ]]; then
    git init
    echo "✅ Dépôt initialisé."
  else
    echo "🚫 Opération annulée."
    exit 1
  fi
fi

# 🔗 Vérifie si un remote origin est configuré
if ! git remote get-url origin &>/dev/null; then
  echo "❌ Aucun remote 'origin' n’est configuré."
  read -p "🔗 Entrez l’URL de votre dépôt distant (GitHub, GitLab, etc.) : " REMOTE_URL
  git remote add origin "$REMOTE_URL"
  echo "✅ Remote 'origin' ajouté : $REMOTE_URL"
fi

# 🧑 Vérifie si user.name et user.email sont configurés
GIT_USER_NAME=$(git config --global user.name)
GIT_USER_EMAIL=$(git config --global user.email)

if [ -z "$GIT_USER_NAME" ]; then
  read -p "👤 Entrez votre nom Git (ex: Sylvain SCATTOLINI) : " NAME
  git config --global user.name "$NAME"
  echo "✅ Nom configuré globalement : $NAME"
fi

if [ -z "$GIT_USER_EMAIL" ]; then
  read -p "📧 Entrez votre email Git : " EMAIL
  git config --global user.email "$EMAIL"
  echo "✅ Email configuré globalement : $EMAIL"
fi

# 🔍 Affiche les tags existants
REPO_NAME=$(basename -s .git "$(git config --get remote.origin.url)")
echo ""
echo "📦 Dépôt : $REPO_NAME"
echo "📋 Tags existants :"
git tag --sort=-creatordate | while read -r tag; do
  MESSAGE=$(git tag -l --format='%(contents)' "$tag" | head -n 1)
  printf "   - %s : %s\n" "$tag" "$MESSAGE"
done

echo ""
read -p "🔢 Numéro de version (laisser vide pour un simple commit) : " VERSION
read -p "📝 Message de commit/version : " MESSAGE

echo "✅ Préparation des fichiers..."
git add .

if [ -z "$VERSION" ]; then
  git commit -m "$MESSAGE"
  echo "📤 Commit simple effectué sur $REPO_NAME."
else
  git commit -m "Préparation version $VERSION"
  echo "🏷  Création du tag $VERSION..."
  git tag "$VERSION" -m "$MESSAGE"

  read -p "✅ Confirmer le push de la version $VERSION vers $REPO_NAME ? (o/N) : " CONFIRM
  if [[ "$CONFIRM" =~ ^[oO]$ ]]; then
    git push --set-upstream origin "$(git rev-parse --abbrev-ref HEAD)"
    git push origin "$VERSION"
    echo "$(date '+%Y-%m-%d %H:%M') - $VERSION : $MESSAGE" >> .git/version_history.log
    echo "🎉 Version $VERSION enregistrée et poussée avec succès."
  else
    echo "🚫 Push annulé."
    exit 0
  fi
fi