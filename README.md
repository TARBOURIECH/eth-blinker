# Ethernet Link Blinker – Interface de diagnostic réseau (Raspberry Pi)

Ce projet permet de déclencher à distance un clignotement de l’interface Ethernet d’un Raspberry Pi (ou autre Linux) afin d’**identifier visuellement** le port correspondant sur un switch (via la LED). Il inclut une interface web responsive et un système de log en temps réel.

---

## 📁 Fichiers principaux

### `index.html`
**Chemin :** `/var/www/html/index.html`  
Interface web responsive :
- Affiche un carré vert/noir selon l’état de l’interface Ethernet.
- Montre les logs en direct.
- Permet de lancer un clignotement avec paramètres (durée + intervalle).

### `ethernet_status.php`
**Chemin :** `/var/www/html/ethernet_status.php`  
Renvoie l’état (`up` / `down`) de l’interface Ethernet + les dernières lignes du fichier de log sous forme JSON.  
Utilisé par `index.html` via AJAX.

### `trigger_blink.php`
**Chemin :** `/var/www/html/trigger_blink.php`  
Reçoit une requête POST (AJAX) avec les paramètres de clignotement, et exécute le script shell correspondant avec `sudo`.

### `ethernet_blink.sh`
**Chemin :** `/var/www/html/scripts/ethernet_blink.sh`  
Script Bash principal.  
Fait clignoter l’interface Ethernet via `ethtool` en alternant lien ON/OFF à intervalle régulier. Chaque action est loguée.

---

## ⚙️ Dépendances

- `apache2`, `php`, `ethtool`
- Droit sudo sans mot de passe pour `www-data` :
  ```
  www-data ALL=(ALL) NOPASSWD: /var/www/html/scripts/ethernet_blink.sh
  ```

---

## 🧠 Fonctionnement global

```
[index.html] 
   ↓ (JS fetch)
[trigger_blink.php] 
   ↓ (sudo exec)
[ethernet_blink.sh] 
   → actionne le lien Ethernet (ON/OFF) 
   → écrit dans /var/log/ethernet_blink.log

[index.html] ← (via fetch)
[ethernet_status.php] ← lit état réseau + logs
```

---

## 🛡️ Sécurité

- Aucune authentification (utilisation en réseau local conseillé)
- L’action est limitée à l’interface Ethernet définie (`eth0`)
- Aucun effet sur le Wi-Fi si `ethtool` est utilisé (préféré à `ip link`)

---

## 👨‍💻 Auteur

Sylvain SCATTOLINI

---

## 🗓️ Version

`1.0` — 2025-06-18
