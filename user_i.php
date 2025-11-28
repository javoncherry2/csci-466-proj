<?php
require 'db_connect.php';

$signupMessage = '';   // message to show after signing up

/*-----------------------------------------
  1. HANDLE SIGNUP FORM (POST)
------------------------------------------*/
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['signup'])) {

    // Read values from the form (POST)
    $file_id     = isset($_POST['file_id']) ? (int)$_POST['file_id'] : 0;
    $user_id     = isset($_POST['user_id']) ? (int)$_POST['user_id'] : 0;
    $queue_type  = isset($_POST['queue_type']) ? $_POST['queue_type'] : 'open';
    $amount_paid = isset($_POST['amount_paid']) ? $_POST['amount_paid'] : 0;

    if ($file_id > 0 && $user_id > 0) {
        try {
            if ($queue_type === 'priority') {
                // Insert into PriorityQ
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
                // Insert into OpenQ
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

// Search text and search type
$q         = isset($_GET['q']) ? $_GET['q'] : '';
$search_by = isset($_GET['search_by']) ? $_GET['search_by'] : 'title';

// Sorting
$allowedSort = ['title', 'main_artist', 'genre', 'version'];
$sort   = isset($_GET['sort']) ? $_GET['sort'] : 'title';
$order  = isset($_GET['order']) ? $_GET['order'] : 'asc';

if (!in_array($sort, $allowedSort)) {
    $sort = 'title';
}
if ($order === 'desc') {
    $order = 'DESC';
} else {
    $order = 'ASC';
}

/*-----------------------------------------
  3. BUILD SEARCH QUERY
------------------------------------------*/

// Base SQL: every row is a Song + one of its KaraokeFile versions
$sql = "
SELECT
    Song.song_id,
    Song.title,
    Song.main_artist,
    Song.genre,
    KaraokeFile.file_id,
    KaraokeFile.version,
    KaraokeFile.file_name
";

if ($search_by === 'contributor') {
    // also select the contribution type
    $sql .= ",
    ContributionType.type AS contribution_type
";
}

$sql .= "
FROM Song
JOIN KaraokeFile ON Song.song_id = KaraokeFile.song_id
";

$params = [];

// If we are searching by contributor, always join the contributor tables
if ($search_by === 'contributor') {
    $sql .= "
        JOIN Contributed      ON Song.song_id = Contributed.song_id
        JOIN Contributor      ON Contributed.contributor_id = Contributor.contributor_id
        JOIN ContributionType ON Contributed.contributiontype_id = ContributionType.contributionType_id
    ";

    if ($q !== '') {
        $sql .= " WHERE Contributor.name LIKE :q";
        $params[':q'] = "%" . $q . "%";
    }

} else {
    // title / artist searches
    if ($q !== '') {
        if ($search_by === 'artist') {
            $sql .= " WHERE Song.main_artist LIKE :q";
        } else { // title by default
            $sql .= " WHERE Song.title LIKE :q";
        }
        $params[':q'] = "%" . $q . "%";
    }
}


// Add ORDER BY for sorting
$sql .= " ORDER BY " . $sort . " " . $order;

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
  6. PREPARE SORT LINKS (no helper function)
------------------------------------------*/

// We will compute what the next sort order should be for each column
$currentSort  = $sort;
$currentOrder = $order; // "ASC" or "DESC"

// For each column, if you're currently sorting by it ascending, next click = DESC, else ASC
$titleOrder       = ($currentSort === 'title'       && $currentOrder === 'ASC') ? 'desc' : 'asc';
$artistOrder      = ($currentSort === 'main_artist' && $currentOrder === 'ASC') ? 'desc' : 'asc';
$genreOrder       = ($currentSort === 'genre'       && $currentOrder === 'ASC') ? 'desc' : 'asc';
$versionOrder     = ($currentSort === 'version'     && $currentOrder === 'ASC') ? 'desc' : 'asc';

// Keep current search inputs in links
$qEncoded         = urlencode($q);
$searchByEncoded  = urlencode($search_by);
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
<form method="get" action="user_i.php">
    <input type="text" name="q" placeholder="Search by title, artist, contributor"
           value="<?php echo htmlspecialchars($q); ?>">

    <select name="search_by">
        <option value="title"      <?php if($search_by === 'title') echo 'selected'; ?>>Title</option>
        <option value="artist"     <?php if($search_by === 'artist') echo 'selected'; ?>>Main Artist</option>
        <option value="contributor"<?php if($search_by === 'contributor') echo 'selected'; ?>>Contributor</option>
    </select>

    <button type="submit">Search</button>
</form>

<!-- RESULTS TABLE -->
<?php if (count($results) > 0): ?>
    <table border="1" cellpadding="6" cellspacing="0">
        <tr>
    <th>
        <a href="user_i.php?q=<?php echo $qEncoded; ?>&search_by=<?php echo $searchByEncoded; ?>&sort=title&order=<?php echo $titleOrder; ?>">
            Title
        </a>
    </th>
    <th>
        <a href="user_i.php?q=<?php echo $qEncoded; ?>&search_by=<?php echo $searchByEncoded; ?>&sort=main_artist&order=<?php echo $artistOrder; ?>">
            Artist
        </a>
    </th>
    <th>
        <a href="user_i.php?q=<?php echo $qEncoded; ?>&search_by=<?php echo $searchByEncoded; ?>&sort=genre&order=<?php echo $genreOrder; ?>">
            Genre
        </a>
    </th>
    <th>
        <a href="user_i.php?q=<?php echo $qEncoded; ?>&search_by=<?php echo $searchByEncoded; ?>&sort=version&order=<?php echo $versionOrder; ?>">
            Version
        </a>
    </th>
    <th>File</th>

    <?php if ($search_by === 'contributor'): ?>
        <th>Contribution</th>
    <?php endif; ?>

    <th>Sign Up</th>
</tr>
        <?php foreach ($results as $row): ?>
            <tr>
                <td><?php echo htmlspecialchars($row['title']); ?></td>
                <td><?php echo htmlspecialchars($row['main_artist']); ?></td>
                <td><?php echo htmlspecialchars($row['genre']); ?></td>
                <td><?php echo htmlspecialchars($row['version']); ?></td>
                <td><?php echo htmlspecialchars($row['file_name']); ?></td>
          <?php if ($search_by === 'contributor'): ?>
                <td><?php echo htmlspecialchars($row['contribution_type']); ?></td>
          <?php endif; ?>
                <td>
                    <!-- SIGNUP FORM FOR THIS SPECIFIC FILE/VERSION -->
                    <form method="post" action="user_i.php">
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
