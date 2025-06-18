<?php
/*
Nom du fichier   : ethernet_status.php
Chemin complet   : /var/www/html/ethernet_status.php
Descriptif       : Fournit un flux JSON contenant l'état de l'interface Ethernet
                   (UP/DOWN) et les dernières lignes du fichier de log.
Dépendances      : /var/log/ethernet_blink.log
Fonctionnement   : Appelé en AJAX depuis index.html toutes les secondes
                   pour afficher l’état et les logs en direct.
Auteur           : Sylvain SCATTOLINI
Version          : 1.0
Date             : 2025-06-18
*/

$iface = "eth0";
$state = trim(@file_get_contents("/sys/class/net/$iface/operstate")) ?: "down";
$logFile = "/var/log/ethernet_blink.log";
$logs = @file($logFile) ?: [];

$lastLogs = array_slice($logs, -15);
$lastLogs = array_map('trim', $lastLogs);

header('Content-Type: application/json');
echo json_encode([
    'link' => $state,
    'logs' => $lastLogs,
]);