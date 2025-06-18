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



if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Méthode non autorisée']);
    exit;
}

exec('sudo /var/www/html/scripts/ethernet_blink.sh > /dev/null 2>&1 &');
echo json_encode(['status' => 'ok', 'message' => 'Clignotement lancé']);