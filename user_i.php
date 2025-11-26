<?php
require 'db_connect.php';

// 1) Read GET/POST data
// 2) Run queries if needed
// 3) Prepare data for HTML
?>
<!DOCTYPE html>
<html>
<head>
    <title>Karaoke Search & Signup</title>
    <link rel="stylesheet" href="style.css"> <!-- optional -->
</head>
<body>

<h1>Search Songs</h1>

<!-- search form goes here -->

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


<!-- results table goes here -->

    

<!-- messages for signup success/error go here -->

</body>
</html>

