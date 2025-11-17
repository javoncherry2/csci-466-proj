--script file
--creates tables and inserts song

--drop tables if they exist
DROP TABLE IF EXISTS Contributed;
DROP TABLE IF EXISTS Requested_Songs;
DROP TABLE IF EXISTS DJ;
DROP TABLE IF EXISTS PriorityQ;
DROP TABLE IF EXISTS OpenQ;
DROP TABLE IF EXISTS KaraokeFile;
DROP TABLE IF EXISTS Song;
DROP TABLE IF EXISTS Contributor;
DROP TABLE IF EXISTS User;

--=====================
--       User      ====
--=====================
CREATE TABLE User(
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
                 );

--=====================
--    Contributer  ====
--=====================
CREATE TABLE Contributor(
    contributor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
                        );

--=====================
--       SONG      ====
--=====================
CREATE TABLE Song(
    song_id INT PRIMARY KEY AUTO_INCREMENT,
    main_artist VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(150) NOT NULL
                );

--=====================
--   KaraokeFile   ====
--=====================
CREATE TABLE KaraokeFile(
  file_id INT AUTO_INCREMENT PRIMARY KEY,
  song_id INT NOT NULL,
  version VARCHAR(255) NOT NULL,
  file_name VARCHAR(255) NOT NULL,
  FOREIGN KEY (song_id) REFERENCES Song(song_id)
                        );

--=====================
--   Open Queue    ====
--=====================
CREATE TABLE OpenQ(
  open_id INT AUTO_INCREMENT PRIMARY KEY,
  file_id INT NOT NULL,
  `time` TIMESTAMP NOT NULL,
  FOREIGN KEY (file_id) REFERENCES KaraokeFile(file_id)
                  );

--=====================
--    PriorityQ    ====
--=====================
CREATE TABLE PriorityQ(
  priority_id INT AUTO_INCREMENT PRIMARY KEY,
  file_id INT NOT NULL,
  `time` TIMESTAMP NOT NULL,
  FOREIGN KEY (file_id) REFERENCES KaraokeFile(file_id)
                      );

--=====================
--        DJ       ====
--=====================
CREATE TABLE DJ(
    dj_id INT AUTO_INCREMENT PRIMARY KEY,
    open_id INT,
    priority_id INT,
    name VARCHAR(150),
    currently_playing VARCHAR(150), 
    FOREIGN KEY(priority_id) REFERENCES PriorityQ(priority_id),
    FOREIGN KEY(open_id) REFERENCES OpenQ(open_id)
               );

--=====================
-- REQUESTED SONGS ====
--=====================
CREATE TABLE Requested_Songs(
  user_id INT,
  song_id INT,
  paid BOOLEAN,
  PRIMARY KEY (user_id, song_id),
  FOREIGN KEY(user_id) REFERENCES User(user_id),
  FOREIGN KEY(song_id) REFERENCES Song(song_id)
                            );

--=====================
-- CONTRIBUTOR ========
--=====================
CREATE TABLE Contributed( 
    contributor_id INT,
    song_id INT,
    contribution VARCHAR(150),
    PRIMARY KEY(contributor_id, song_id),
    FOREIGN KEY(contributor_id) REFERENCES Contributor(contributor_id)
    ON DELETE CASCADE,
    FOREIGN KEY(song_id) REFERENCES Song(song_id)
    ON DELETE CASCADE
                        );

--inserts base songs into database
INSERT INTO Song
(main_artist, type, title)
 VALUES
('The Weeknd', 'Pop', 'Blinding Lights'),
('The Weeknd', 'Pop', 'Save Your Tears'),
('Taylor Swift', 'Pop', 'Anti-Hero'),
('Taylor Swift', 'Pop', 'Love Story'),
('Ed Sheeran', 'Pop', 'Shape of You'),
('Ed Sheeran', 'Pop', 'Perfect'),
('Drake', 'Hip-Hop', 'God\'s Plan'),
('Drake', 'Hip-Hop', 'One Dance'),
('Bruno Mars', 'R&B', '24K Magic'),
('Bruno Mars', 'R&B', 'That\'s What I Like'),
('Billie Eilish', 'Alternative', 'Bad Guy'),
('Imagine Dragons', 'Rock', 'Believer'),
('Imagine Dragons', 'Rock', 'Demons'),
('Ariana Grande', 'Pop', '7 Rings'),
('Rihanna', 'Pop', 'Diamonds'),
('Rihanna', 'Pop', 'Umbrella'),
('Beyoncé', 'Pop', 'Halo'),
('Post Malone', 'Pop', 'Circles'),
('Harry Styles', 'Pop', 'As It Was'),
('Bad Bunny', 'Latin', 'Titi Me Pregunto'),
('Eminem', 'Hip-Hop', 'Lose Yourself'),
('Coldplay', 'Alternative', 'Viva La Vida'),
('Queen', 'Rock', 'Bohemian Rhapsody'),
('Olivia Rodrigo', 'Pop', 'Drivers License'),
('Shakira', 'Latin', 'Hips Don\'t Lie'),
('Dua Lipa', 'Pop', 'Levitating'),
('Travis Scott', 'Hip-Hop', 'Sicko Mode'),
('SZA', 'R&B', 'Kill Bill'),
('Kendrick Lamar', 'Hip-Hop', 'HUMBLE.'),
('Adele', 'Pop', 'Rolling in the Deep');
                       








