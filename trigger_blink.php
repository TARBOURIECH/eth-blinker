<?php
/*
Nom du fichier   : trigger_blink.php
Chemin complet   : /var/www/html/trigger_blink.php
Descriptif       : Reçoit une requête POST avec les paramètres durée et intervalle
                   puis lance le script de clignotement en arrière-plan.
Dépendances      : scripts/ethernet_blink.sh, sudo (sans mot de passe pour ce script)
Fonctionnement   : Appelé depuis index.html via fetch POST pour déclencher un clignotement.
Auteur           : Sylvain SCATTOLINI
Version          : 1.0
Date             : 2025-06-18
*/

header('Content-Type: application/json');
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Méthode non autorisée']);
    exit;
}

$data = json_decode(file_get_contents("php://input"), true);
$duration = (int)($data['duration'] ?? 10);
$interval = (int)($data['interval'] ?? 10);

$duration = max(1, $duration);
$interval = max(1, $interval);

$cmd = escapeshellcmd("/var/www/html/scripts/ethernet_blink.sh $duration $interval");
exec("sudo $cmd > /dev/null 2>&1 &");

file_put_contents("/var/log/ethernet_blink.log", "[" . date('Y-m-d H:i:s') . "] 🔁 Clignotement demandé ($duration boucles, $interval sec)\n", FILE_APPEND);
echo json_encode(['status' => 'ok', 'message' => "Clignotement lancé"]);