#!/bin/bash
# =============================================================================
# Nom du script : ethernet_blink.sh
# Chemin        : /var/www/html/scripts/ethernet_blink.sh
# Description   : Fait clignoter la LED de l'interface Ethernet sans impacter
#                 la connectivité Wi-Fi ni Apache. Utile pour identifier un port.
# Options       : $1 = nombre de clignotements (défaut : 10)
#                 $2 = intervalle en secondes (défaut : 10)
# Exemple       : ./ethernet_blink.sh 5 3
# Dépendances   : ethtool
# Auteur        : Sylvain SCATTOLINI
# Date          : 2025-06-18
# Version       : 1.4
# =============================================================================

#!/bin/bash
# /var/www/html/scripts/ethernet_blink.sh

IFACE="eth0"
DURATION=10
INTERVAL=5
LOG_FILE="/var/log/ethernet_blink.log"

log() {
    echo "[$(date '+%H:%M:%S')] $1" >> "$LOG_FILE"
}
log "🔵 [$IFACE] Clignotement manuel lancé"
for ((i = 0; i < DURATION; i += 2)); do
    log "⚫️ [$IFACE] OFF"
    ip link set "$IFACE" down
    sleep "$INTERVAL"

    log "🟢 [$IFACE] ON"
    ip link set "$IFACE" up
    sleep "$INTERVAL"
done

log "🔵 [$IFACE] Clignotement manuel terminé"