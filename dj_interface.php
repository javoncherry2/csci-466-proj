<html><head><title>Karaoke Queues </title></head>
<body>
<?php

#connects database
require "db_connect.php";

#list current song playing
$song_playing = $pdo->query("SELECT currently_playing FROM DJ;");
$current = $song_playing->fetch();
echo "Currenly Playing: $current[0]";


#if the dj wants to play the next song
if(isset($_POST['delete'])){
	#if deleting from free queue
	if($_POST['delete'] == 'f'){
		$sql = "DELETE FROM OpenQ
			WHERE time = (SELECT MIN(time) FROM OpenQ);";
			
	         #gets title of song that is being played		
		 $sql2 = "Select Song.title 
                 FROM OpenQ 
                 JOIN KaraokeFile ON OpenQ.file_id = KaraokeFile.file_id 
                 JOIN Song ON KaraokeFile.song_id = Song.song_id 
                 ORDER BY OpenQ.time
		 LIMIT 1";
				   }

	




	#if deleting from priority queue
	else{
	#delete by time
	 if(!isset($_GET['sort']) || $_GET['sort'] == 'time'){
		$sql = "DELETE FROM PriorityQ
			WHERE time = (SELECT MIN(time) FROM PriorityQ);";

		 #gets title of song that is being played		
		 $sql2 = "Select Song.title 
             	          FROM PriorityQ 
                          JOIN KaraokeFile ON PriorityQ.file_id = KaraokeFile.file_id 
                          JOIN Song ON KaraokeFile.song_id = Song.song_id 
                          ORDER BY PriorityQ.time
			  LIMIT 1";
	 						     }	
	 #delete by amount_paid
	 else{
	     $sql = "DELETE FROM PriorityQ
		     WHERE amount_paid = (SELECT MAX(amount_paid) FROM PriorityQ);";

	     $sql2 = "Select Song.title 
                      FROM PriorityQ 
                      JOIN KaraokeFile ON PriorityQ.file_id = KaraokeFile.file_id 
                      JOIN Song ON KaraokeFile.song_id = Song.song_id 
                      ORDER BY PriorityQ.amount_paid DESC
		      LIMIT 1";
	     }
	}
	
	#deletes song and updates currently playing
	
	$statement2 = $pdo->query($sql2);
	$song = $statement2->fetch();
	$pdo->exec("UPDATE DJ SET currently_playing = " . $pdo->quote($song[0]));
	$pdo->exec($sql);
	
	#refreshed page for currently playing and keeps sorting
	$sort = $_GET['sort'] ?? 'time';
	#header("Location: ".$_SERVER['PHP_SELF']);
	header("Location: ".$_SERVER['PHP_SELF']."?sort=$sort");
        exit;
	      		   }







#get data from database
$sql = "SELECT User.name, Song.title, Song.main_artist, KaraokeFile.file_id, OpenQ.time
FROM OpenQ
JOIN User ON User.user_id = OpenQ.user_id
JOIN KaraokeFile ON KaraokeFile.file_id = OpenQ.file_id
JOIN Song ON Song.song_id = KaraokeFile.song_id
ORDER BY OpenQ.time;";


$statement= $pdo->query($sql);
$rows = $statement->fetchAll();
$numrows = count($rows);

#label for free queue

echo "<h2 style='text-align:center;'>Free Queue</h2>";

#if nothing is in the queue
if($numrows == 0){
	echo '<p style="text-align:center;">Queue is empty</p>';
		 }
else{
echo "<br> <br>";
echo "<table border=2 style='margin-left:auto; margin-right:auto;'>";

#makes headers
echo "<tr>";
echo "<th>order</th>";
echo "<th>Name</th>";
echo "<th>Song</th>";
echo "<th>Artist</th>";
echo "<th>File ID</th>";
echo "<th>Time requested</th>";
echo "</tr>";

#adds free queue
$j = 1;
foreach($rows as $row){
	echo "<tr>";
	echo "<td>$j</td>";
	echo "<td>$row[0]</td>";
	echo "<td>$row[1]</td>";
	echo "<td>$row[2]</td>";
	echo "<td>$row[3]</td>";
	echo "<td>$row[4]</td>";
	echo "</tr>";
	$j++;
		      }

echo "</table>";
}
echo "<br> <br>";
#level for priority queue
echo "<h2 style='text-align:center;'>Priority Queue</h2>";

#creates second tables

#get data from database


#default sorts by time 
if(!isset($_GET['sort']) || $_GET['sort'] == "time" ){
$sql = "SELECT User.name, Song.title, Song.main_artist, KaraokeFile.file_id, PriorityQ.time, PriorityQ.amount_paid
FROM PriorityQ 
JOIN User ON User.user_id = PriorityQ.user_id 
JOIN KaraokeFile ON KaraokeFile.file_id = PriorityQ.file_id 
JOIN Song ON Song.song_id = KaraokeFile.song_id 
ORDER BY PriorityQ.time;";
						    } 

#if amount paid is selected
else{
$sql = "SELECT User.name, Song.title, Song.main_artist, KaraokeFile.file_id, PriorityQ.time, PriorityQ.amount_paid
FROM PriorityQ 
JOIN User ON User.user_id = PriorityQ.user_id 
JOIN KaraokeFile ON KaraokeFile.file_id = PriorityQ.file_id 
JOIN Song ON Song.song_id = KaraokeFile.song_id 
ORDER BY PriorityQ.amount_paid DESC;";
    }

$statement= $pdo->query($sql);
$rows = $statement->fetchAll();
$numrows = count($rows);


#if there is nothing in the queue
if($numrows == 0){
	echo '<p style="text-align:center;">Queue is empty</p>';
		 }
else{
echo "<table border=2 style='margin-left:auto; margin-right:auto;'>";

#makes headers
echo "<tr>";
echo "<th>order</th>";
echo "<th>Name</th>";
echo "<th>Song</th>";
echo "<th>Artist</th>";
echo "<th>File ID</th>";
echo "<th>Time requested</th>";
echo "<th>Amount Paid</th>";
echo "</tr>";

#adds free queue
$j = 1;
foreach($rows as $row){
	echo "<tr>";
	echo "<td>$j</td>";
	echo "<td>$row[0]</td>";
	echo "<td>$row[1]</td>";
	echo "<td>$row[2]</td>";
	echo "<td>$row[3]</td>";
	echo "<td>$row[4]</td>";
	echo "<td>$row[5]</td>";
	echo "</tr>";
	$j++;
		    }

echo "</table>";
  }


echo "<p style='text-align:center;'>Sort by:</p>";
echo "
<form method=get style='text-align:center;'>
    &nbsp
    <button type='submit' name='sort' value='time'> &nbsp Time &nbsp</button>
    &nbsp;&nbsp;&nbsp
    <button type='submit' name='sort' value='paid'>Amount Paid</button>
</form>
    ";


echo "<br> <br>";
echo "
<form method=post style='text-align:center;'>
    &nbsp
    <button type='submit' style='padding:20px 40px; font-size:18px;' name='delete' value='f'>Play from free</button>
    &nbsp;&nbsp;&nbsp
    <button type='submit' style='padding:20px 40px; font-size:18px;' name='delete' value='p'>Play from paid</button>
</form>
   ";

?>
</body>
</html> 
