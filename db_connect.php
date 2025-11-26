<?php
$host = 'courses';                // NIU host for MariaDB
$dbname = 'z2033811';             // <-- replace with member 2's Z-ID database name
$username = 'z2033811';           // <-- usually same as dbname
$password = '2006Apr20';      // <-- replace with real password

$dsn = "mysql:host=$host;dbname=$dbname;charset=utf8mb4";

try {
    $pdo = new PDO($dsn, $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Database connection failed: " . $e->getMessage());
}
?>
