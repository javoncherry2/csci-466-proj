<?php
require 'db_connect.php';

$signupMessage = '';   // message to show after signing up

/*-----------------------------------------
  1. HANDLE SIGNUP FORM (POST)
------------------------------------------*/
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['signup'])) {
    $file_id     = (int)($_POST['file_id'] ?? 0);
    $user_id     = (int)($_POST['user_id'] ?? 0);
    $queue_type  = $_POST['queue_type'] ?? 'open';
    $amount_paid = $_POST['amount_paid'] ?? 0;

    if ($file_id > 0 && $user_id > 0) {
        try {
            if ($queue_type === 'priority') {
                // insert into
                $sqlInsert = "
                    INSERT INTO PriorityQ (file_id, user_id, amount_paid, dj_id)
                    VALUES (:file_id, :user_id, :amount_paid, NULL)
                ";
                $stmtInsert = $pdo->prepare($sqlInsert);
                $stmtInsert->execute([
                    ':file_id'     => $file_id,
                    ':user_id'     => $user_id,
                    ':amount_paid' => $amount_paid
                ]);
                $signupMessage = "Signed up for Priority Queue!";
            } else {
                // insert into
                $sqlInsert = "
                    INSERT INTO OpenQ (file_id, user_id, dj_id)
                    VALUES (:file_id, :user_id, NULL)
                ";
                $stmtInsert = $pdo->prepare($sqlInsert);
                $stmtInsert->execute([
                    ':file_id' => $file_id,
                    ':user_id' => $user_id
                ]);
                $signupMessage = "Signed up for Free Queue!";
            }
        } catch (PDOException $e) {
            $signupMessage = "Error signing up: " . $e->getMessage();
        }
    } else {
        $signupMessage = "Please select a user and a valid song/version.";
    }
}

/*-----------------------------------------
  2. READ SEARCH + SORT PARAMETERS (GET)
------------------------------------------*/
$q         = $_GET['q'] ?? '';
$search_by = $_GET['search_by'] ?? 'title';

$allowedSort = ['title', 'main_artist', 'genre', 'version'];
$sort   = $_GET['sort'] ?? 'title';
$order  = $_GET['order'] ?? 'asc';

if (!in_array($sort, $allowedSort)) {
    $sort = 'title';
}
$order = ($order === 'desc') ? 'DESC' : 'ASC';

/*-----------------------------------------
  3. BUILD SEARCH QUERY
------------------------------------------*/
// base SQL
$sql = "
SELECT
    Song.song_id,
    Song.title,
    Song.main_artist,
    Song.genre,
    KaraokeFile.file_id,
    KaraokeFile.version,
    KaraokeFile.file_name
FROM Song
JOIN KaraokeFile ON Song.song_id = KaraokeFile.song_id
";

$params = [];

// add join & where based on search type
if ($q !== '') {
    if ($search_by === 'artist') {
        $sql .= " WHERE Song.main_artist LIKE :q";
        $params[':q'] = "%$q%";
    } elseif ($search_by === 'title') {
        $sql .= " WHERE Song.title LIKE :q";
        $params[':q'] = "%$q%";
    } elseif ($search_by === 'contributor') {
        $sql .= "
            JOIN Contributed ON Song.song_id = Contributed.song_id
            JOIN Contributor ON Contributed.contributor_id = Contributor.contributor_id
            WHERE Contributor.name LIKE :q
        ";
        $params[':q'] = "%$q%";
    }
}

// add ORDER BY for sorting
$sql .= " ORDER BY $sort $order";

/*-----------------------------------------
  4. EXECUTE SONG SEARCH
------------------------------------------*/
$stmt = $pdo->prepare($sql);
$stmt->execute($params);
$results = $stmt->fetchAll(PDO::FETCH_ASSOC);

/*-----------------------------------------
  5. FETCH USERS FOR DROPDOWN
------------------------------------------*/
$userStmt = $pdo->query("SELECT user_id, name FROM User ORDER BY name");
$users = $userStmt->fetchAll(PDO::FETCH_ASSOC);

/*-----------------------------------------
  6. HELPER FOR SORT LINKS
------------------------------------------*/
function sortLink($column, $label) {
    $currentSort  = $_GET['sort']  ?? 'title';
    $currentOrder = $_GET['order'] ?? 'asc';
    $newOrder = ($currentSort === $column && $currentOrder === 'asc') ? 'desc' : 'asc';

    $q         = urlencode($_GET['q']         ?? '');
    $search_by = urlencode($_GET['search_by'] ?? 'title');

    echo "<a href=\"?q=$q&search_by=$search_by&sort=$column&order=$newOrder\">$label</a>";
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Karaoke Search & Signup</title>
    <link rel="stylesheet" href="style.css"> <!-- optional -->
</head>
<body>

<h1>Search Songs</h1>

<?php if ($signupMessage): ?>
    <p><strong><?php echo htmlspecialchars($signupMessage); ?></strong></p>
<?php endif; ?>

<!-- SEARCH FORM -->
<form method="get" action="user_interface.php">
    <input type="text" name="q" placeholder="Search by title, artist, contributor"
           value="<?php echo isset($_GET['q']) ? htmlspecialchars($_GET['q']) : ''; ?>">

    <select name="search_by">
        <option value="title"      <?php if(($_GET['search_by'] ?? '') === 'title') echo 'selected'; ?>>Title</option>
        <option value="artist"     <?php if(($_GET['search_by'] ?? '') === 'artist') echo 'selected'; ?>>Main Artist</option>
        <option value="contributor"<?php if(($_GET['search_by'] ?? '') === 'contributor') echo 'selected'; ?>>Contributor</option>
    </select>

    <button type="submit">Search</button>
</form>

<!-- RESULTS TABLE -->
<?php if (count($results) > 0): ?>
    <table border="1" cellpadding="6" cellspacing="0">
        <tr>
            <th><?php sortLink('title', 'Title'); ?></th>
            <th><?php sortLink('main_artist', 'Artist'); ?></th>
            <th><?php sortLink('genre', 'Genre'); ?></th>
            <th><?php sortLink('version', 'Version'); ?></th>
            <th>File</th>
            <th>Sign Up</th>
        </tr>

        <?php foreach ($results as $row): ?>
            <tr>
                <td><?php echo htmlspecialchars($row['title']); ?></td>
                <td><?php echo htmlspecialchars($row['main_artist']); ?></td>
                <td><?php echo htmlspecialchars($row['genre']); ?></td>
                <td><?php echo htmlspecialchars($row['version']); ?></td>
                <td><?php echo htmlspecialchars($row['file_name']); ?></td>
                <td>
                    <!-- SIGNUP FORM FOR THIS SPECIFIC FILE/VERSION -->
                    <form method="post" action="user_interface.php">
                        <input type="hidden" name="file_id" value="<?php echo (int)$row['file_id']; ?>">

                        <label>
                            User:
                            <select name="user_id" required>
                                <option value="">-- Select User --</option>
                                <?php foreach ($users as $u): ?>
                                    <option value="<?php echo (int)$u['user_id']; ?>">
                                        <?php echo htmlspecialchars($u['name']); ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </label>
                        <br>

                        <label>
                            Queue:
                            <select name="queue_type">
                                <option value="open">Free Queue</option>
                                <option value="priority">Priority Queue</option>
                            </select>
                        </label>
                        <br>

                        <label>
                            Amount Paid (for priority):
                            <input type="number" step="0.01" name="amount_paid" value="0.00">
                        </label>
                        <br>

                        <button type="submit" name="signup" value="1">Sign Up</button>
                    </form>
                </td>
            </tr>
        <?php endforeach; ?>
    </table>
<?php else: ?>
    <p>No songs found. Try a different search.</p>
<?php endif; ?>

</body>
</html>
