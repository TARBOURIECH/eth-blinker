<?php
// /var/www/html/ethernet_status.php
// Version 1.0 – Fournit l’état de eth0 et les derniers logs

header('Content-Type: application/json');

$iface = "eth0";
$state = trim(@file_get_contents("/sys/class/net/$iface/operstate")) ?: "down";
$logFile = "/var/log/ethernet_blink.log";
$logs = @file($logFile) ?: [];

$lastLogs = array_slice($logs, -15);
$lastLogs = array_map('trim', $lastLogs);

echo json_encode([
    'link' => $state,
    'logs' => $lastLogs,
]);