<?php
// /var/www/html/set_link.php

header('Content-Type: application/json');
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Méthode non autorisée']);
    exit;
}

$data = json_decode(file_get_contents("php://input"), true);
$state = $data['state'] ?? null;

$iface = "eth0";
$allowed = ['up', 'down'];

if (!in_array($state, $allowed)) {
    echo json_encode(['error' => 'État non valide']);
    exit;
}

// Arrêt du clignotement s’il y en a un
file_put_contents("/tmp/stop_blinking.flag", "1");

$cmd = "sudo ip link set $iface $state";
exec($cmd . ' > /dev/null 2>&1');

file_put_contents("/var/log/ethernet_blink.log", "[" . date('Y-m-d H:i:s') . "] 🔧 [$iface] forcé $state\n", FILE_APPEND);
echo json_encode(['status' => 'ok', 'message' => "Lien mis à $state (et clignotement stoppé)"]);