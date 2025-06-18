#!/bin/bash
# ==============================================================================
# Nom du fichier   : ethernet_blink.sh
# Chemin complet   : /var/www/html/scripts/ethernet_blink.sh
# Descriptif       : Fait clignoter le lien Ethernet (interface eth0) en répétant
#                   ON/OFF avec une fréquence et une durée paramétrables.
# Dépendances      : ethtool, sudo (autorisé sans mot de passe pour ce script)
# Fonctionnement   : Exécuté par trigger_blink.php avec 2 arguments (durée, intervalle).
#                   Logue chaque action dans /var/log/ethernet_blink.log
# Auteur           : Sylvain SCATTOLINI
# Version          : 1.0
# Date             : 2025-06-18
# ==============================================================================

IFACE="eth0"
DURATION=${1:-10}
INTERVAL=${2:-10}
LOG_FILE="/var/log/ethernet_blink.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log "🔁 [$IFACE] Clignotement lancé ($DURATION boucles, $INTERVAL s)"

for ((i = 0; i < DURATION; i++)); do
    log "⚫️ [$IFACE] OFF"
    ip link set "$IFACE" down
    sleep "$INTERVAL"

    log "🟢 [$IFACE] ON"
    ip link set "$IFACE" up
    sleep "$INTERVAL"
done

log "✅ [$IFACE] Clignotement terminé"