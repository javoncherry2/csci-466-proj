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
DROP TABLE IF EXISTS ContributionType;

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
--  Contribution type =
--=====================
CREATE TABLE ContributionType(
    contributionType_id INT PRIMARY KEY,
    type VARCHAR(100) NOT NULL
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
UNIQUE (file_name), 
FOREIGN KEY (song_id) REFERENCES Song(song_id)

                        );

--=====================
--   Open Queue    ====
--=====================
CREATE TABLE OpenQ(
open_id INT AUTO_INCREMENT PRIMARY KEY,
file_id INT NOT NULL,
user_id INT NOT NULL,
`time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (file_id) REFERENCES KaraokeFile(file_id),
FOREIGN KEY (user_id) REFERENCES User(user_id)

                  );

--=====================
--    PriorityQ    ====
--=====================
CREATE TABLE PriorityQ(
priority_id INT AUTO_INCREMENT PRIMARY KEY,
file_id INT NOT NULL,
user_id INT NOT NULL,
amount_paid DECIMAL(8,2) NOT NULL DEFAULT 0.00,
`time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (file_id) REFERENCES KaraokeFile(file_id),
FOREIGN KEY (user_id) REFERENCES User(user_id)
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
    contributiontype_id INT,
    PRIMARY KEY(contributor_id, song_id),
    FOREIGN KEY(contributor_id) REFERENCES Contributor(contributor_id)
    ON DELETE CASCADE,
    FOREIGN KEY(song_id) REFERENCES Song(song_id)
    ON DELETE CASCADE,
    FOREIGN KEY(contributiontype_id) REFERENCES ContributionType( contributionType_id)
    ON DELETE CASCADE
                      );
    
                    

-- =========================================================
-- CSCI 466 Karaoke Management System
-- Part 5 - Sample Data (DML)
-- =========================================================

-- USE karaoke_db;

--=====================
-- USER ===============
--=====================


INSERT INTO User (user_id, name) VALUES
('1', 'Joe Mama'),
('2', 'Javon Cherry'),
('3', 'Hamzah Subhani'),
('4', 'Morgan Hill'),
('5', 'Jamie Fox'),
('6','Chris Stone'),
('7', 'Pat Riley'),
('8', 'Riley Brooks'),
('9', 'Cameron Diaz'),
('10', 'Robin Parker');



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

INSERT INTO ContributionType (contributionType_id, type)
VALUES
    (1, 'Singer'),
    (2, 'Writer'),
    (3, 'Producer');


INSERT INTO KaraokeFile (song_id, version, file_name) VALUES
(1, 'Original', 'blinding_lights_v1.mp4'),
(2, 'Original', 'save_your_tears_v1.mp4'),
(3, 'Original', 'anti_hero_v1.mp4'),
(4, 'Original', 'love_story_v1.mp4'),
(5, 'Original', 'shape_of_you_v1.mp4'),
(6, 'Original', 'perfect_v1.mp4'),
(7, 'Original', 'gods_plan_v1.mp4'),
(8, 'Original', 'one_dance_v1.mp4'),
(9, 'Original', '24k_magic_v1.mp4'),
(10, 'Original', 'thats_what_i_like_v1.mp4'),
(11, 'Original', 'bad_guy_v1.mp4'),
(12, 'Original', 'believer_v1.mp4'),
(13, 'Original', 'demons_v1.mp4'),
(14, 'Original', '7_rings_v1.mp4'),
(15, 'Original', 'diamonds_v1.mp4'),
(16, 'Original', 'umbrella_v1.mp4'),
(17, 'Original', 'halo_v1.mp4'),
(18, 'Original', 'circles_v1.mp4'),
(19, 'Original', 'as_it_was_v1.mp4'),
(20, 'Original', 'titi_me_pregunto_v1.mp4')
(21, 'Original', 'lose_yourself_v1.mp4'),
(22, 'Original', 'viva_la_vida_v1.mp4'),
(23, 'Original', 'bohemian_rhapsody_v1.mp4'),
(24, 'Original', 'drivers_license_v1.mp4'),
(25,'Original','hips_dont_lie_v1.mp4'),
(26, 'Original', 'levitating_v1.mp4'),
(27, 'Original', 'sicko_mode_v1.mp4'),
(28, 'Original', 'kill_bill_v1.mp4'),
(29, 'Original', 'humble_v1.mp4'),
(30, 'Original', 'rolling_in_the_deep_v1.mp4');



-- =========================================================
-- OPEN QUEUE                                 ==============
-- =========================================================
INSERT INTO OpenQ (file_id, user_id) VALUES
(1, 1),
(4, 2),
(7, 3),
(10, 4),
(12, 5);


-- =========================================================
-- PRIORITY QUEUE                               ============
-- =========================================================
INSERT INTO PriorityQ (file_id, user_id, amount_paid) VALUES
INSERT INTO PriorityQ (file_id, user_id, amount_paid, time) VALUES
(2, 6, 5.00,  '2025-11-19 10:14:40'),
(6, 7, 3.50,  '2025-11-19 08:32:12'),
(9, 8, 10.00, '2025-11-19 15:47:55'),
(15, 9, 7.00, '2025-11-19 21:05:03'),
(20, 10, 4.00,'2025-11-19 04:58:19');









