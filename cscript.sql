-- =========================================================
-- CSCI 466 Karaoke Management System
-- Part 4 - Creates the Database (DDL)
-- =========================================================

--drop tables if they exist
DROP TABLE IF EXISTS Contributed;
DROP TABLE IF EXISTS Requested_Songs;
DROP TABLE IF EXISTS PriorityQ;
DROP TABLE IF EXISTS OpenQ;
DROP TABLE IF EXISTS DJ;
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
    genre VARCHAR(50) NOT NULL,
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
--        DJ       ====
--=====================
CREATE TABLE DJ(
    dj_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150),
    currently_playing VARCHAR(150)
               );

--=====================
--    PriorityQ    ====
--=====================
CREATE TABLE PriorityQ(
priority_id INT AUTO_INCREMENT PRIMARY KEY,
file_id INT NOT NULL,
user_id INT NOT NULL,
dj_id INT NULL,
amount_paid DECIMAL(8,2) NOT NULL DEFAULT 0.00,
`time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (file_id) REFERENCES KaraokeFile(file_id),
FOREIGN KEY (user_id) REFERENCES User(user_id),
FOREIGN KEY(dj_id) REFERENCES DJ(dj_id)
                      );

--=====================
--   Open Queue    ====
--=====================
CREATE TABLE OpenQ(
open_id INT AUTO_INCREMENT PRIMARY KEY,
file_id INT NOT NULL,
user_id INT NOT NULL,
dj_id INT NULL,
`time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (file_id) REFERENCES KaraokeFile(file_id),
FOREIGN KEY (user_id) REFERENCES User(user_id),
FOREIGN KEY(dj_id) REFERENCES DJ(dj_id)

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
    PRIMARY KEY(contributor_id, song_id, contributiontype_id),
    FOREIGN KEY(contributor_id) REFERENCES Contributor(contributor_id)
    ON DELETE CASCADE,
    FOREIGN KEY(song_id) REFERENCES Song(song_id)
    ON DELETE CASCADE,
    FOREIGN KEY(contributiontype_id) REFERENCES ContributionType( contributionType_id)
    ON DELETE CASCADE
                      );
    
 
