-- =========================================================
-- CSCI 466 Karaoke Management System
-- Part 5 - Inserts Sample Data (DML)
-- =========================================================

-- USE karaoke_db;

--=====================
--Inserts into USER ==
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

--=====================
--Inserts into Song ==
--=====================
INSERT INTO Song
(main_artist, genre, title)
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


--================================
--Inserts into Contribution type ==
--================================
INSERT INTO ContributionType (contributionType_id, type)
VALUES
    (1, 'Writer'),
    (2, 'Singer'),
    (3, 'Instrumentalist');


--=================================
-- Inserts into Contributor ====
--=================================
INSERT INTO Contributor 
VALUES
(1, 'Abel Tesfaye'),  
(2, 'Patrick Greenaway'),
(3, 'Taylor Swift'),
(4, 'Jack Antonoff'),
(5, 'Ed Sheeran'),
(6, 'Drake'),
(7, 'Bruno Mars'),
(8, 'Billie Eilish'),
(9, 'Dan Reynolds'),
(10, 'Ben McKee'),
(11, 'Ariana Grande'),
(12, 'Rihanna'),
(13, 'Beyoncé'),
(14, 'Post Malone'),
(15, 'Harry Styles'),
(16, 'Paul Epworth'),
(17, 'Benito Martinez'),
(18, 'Eminem'),
(19, 'Chris Martin'),
(20, 'Jay-Z'),
(21, 'Jonny Buckland'),
(22, 'Freddie Mercury'),
(23, 'Olivia Rodrigo'),
(24, 'Shakira'),
(25, 'Dua Lipa'),
(26, 'Travis Scott'),
(27, 'Solána Imani Rowe'),
(28, 'Aubrey Graham'),
(29, 'Carter Lang'),
(30, 'Michael Williams II'),
(31, 'Kendrick Lamar'),
(32, 'Adele');

--==============================
-- Inserts into Contributed ====
--==============================
INSERT INTO Contributed
VALUES
/* The Weeknd */
(1, 1, 1),
(1, 1, 2),
(2, 1, 1),
(1, 2, 1),
(1, 2, 2),
(2, 2, 1),

/* Taylor Swift */
(3, 3, 1),
(3, 3, 2),
(4, 3, 1),
(3, 4, 1),
(3, 4, 2),
(4, 4, 1),

/* Ed Sheeran */
(5, 5, 1),
(5, 5, 2),
(5, 6, 1),
(5, 6, 2),

/* Drake */
(6, 7, 1),
(6, 7, 2),
(6, 8, 1),
(6, 8, 2),

/* Bruno Mars */
(7, 9, 1),
(7, 9, 2),
(7, 10, 1),
(7, 10, 2),

/* Billie Eilish */
(8, 11, 1),
(8, 11, 2),

/* Imagine Dragons */
(9, 12, 2),
(10, 12, 3),
(9, 13, 2),
(10, 13, 3),

/* Ariana Grande */
(11, 14, 1),
(11, 14, 2),

/* Rihanna */
(12, 15, 1),
(12, 15, 2),
(12, 16, 1),
(12, 16, 2),
(20, 16, 2),

/* Beyoncé */
(13, 17, 1),
(13, 17, 2),

/* Post Malone */
(14, 18, 1),
(14, 18, 2),

/* Harry Styles */
(15, 19, 1),
(15, 19, 2),

/* Ben McKee */
(17, 20, 1),
(17, 20, 2),

/* Eminem */
(18, 21, 1),
(18, 21, 2),

/* Coldplay */
(19, 22, 2),
(21, 22, 3),

/* Queen */
(22, 23, 2),
(22, 23, 1),

/* Olivia Rodrigo */
(23, 24, 1),
(23, 24, 2),

/* Shakira */
(24, 25, 1),
(24, 25, 2),

/* Dua Lipa */
(25, 26, 1),
(25, 26, 2),

/* Travis Scott */
(26, 27, 1),
(26, 27, 2),
(28, 27, 3),

/* SZA */
(27, 28, 1),
(27, 28, 2),
(29, 28, 3),

/* Kendrick Lamar */
(31, 29, 1),
(31, 29, 2),
(30, 29, 3),

/* Adele */
(32, 30, 1),
(32, 30, 2),
(16, 30, 3);


--===========================
--Inserts into KaraokeFile ==
--===========================
INSERT INTO KaraokeFile (song_id, version, file_name) VALUES
(1,'Original','blinding_lights_v1.mp4'),
(1,'Extended','blinding_lights_v2.mp4'),
(2,'Original','save_your_tears_v1.mp4'),
(2,'Extended','save_your_tears_v2.mp4'),
(3,'Original','anti_hero_v1.mp4'),
(4,'Original','love_story_v1.mp4'),
(4,'Shortend','love_story_v2.mp4'),
(5,'Original','shape_of_you_v1.mp4'),
(6,'Original','perfect_v1.mp4'),
(7,'Original','gods_plan_v1.mp4'),
(8,'Original','one_dance_v1.mp4'),
(9,'Original','24k_magic_v1.mp4'),
(9,'Spanish','24k_magic_v2.mp4'),
(10,'Original','thats_what_i_like_v1.mp4'),
(11,'Original','bad_guy_v1.mp4'),
(12,'Original','believer_v1.mp4'),
(12,'Clean','believer_v2.mp4'),
(13,'Original','demons_v1.mp4'),
(14,'Original','7_rings_v1.mp4'),
(15,'Original','diamonds_v1.mp4'),
(16,'Original','umbrella_v1.mp4'),
(17,'Original','halo_v1.mp4'),
(17,'Acoustic','halo_v2.mp4'),
(18,'Original','circles_v1.mp4'),
(19,'Original','as_it_was_v1.mp4'),
(19,'Orchestral','as_it_was_v2.mp4'),
(20,'Original','titi_me_pregunto_v1.mp4'),
(21,'Original','lose_yourself_v1.mp4'),
(22,'Original','viva_la_vida_v1.mp4'),
(22,'Live','viva_la_vida_v2.mp4'),
(23,'Original','bohemian_rhapsody_v1.mp4'),
(24,'Original','drivers_license_v1.mp4'),
(25,'Original','hips_dont_lie_v1.mp4'),
(25,'Extended','hips_dont_lie_v2.mp4'),
(26,'Original','levitating_v1.mp4'),
(27,'Original','sicko_mode_v1.mp4'),
(28,'Original','kill_bill_v1.mp4'),
(29,'Original','humble_v1.mp4'),
(30,'Original','rolling_in_the_deep_v1.mp4'),
(30,'Fast','rolling_in_the_deep_v2.mp4'),
(30,'Slow','rolling_in_the_deep_v3.mp4');

--======================
-- Inserts into DJ =====
--======================
INSERT INTO DJ (name, currently_playing)
VALUES
('DJ MixMaster', "viva la vida");

--=====================
--Inserts into OpenQ ==
--=====================
INSERT INTO OpenQ (file_id, user_id, time, dj_id) VALUES
(1, 1, '2025-11-22 19:11:02', 1),
(4, 2, '2025-11-22 20:18:09', 1),
(7, 3, '2025-11-22 21:54:20', 1),
(10, 4, '2025-11-22 21:00:00', 1),
(12, 5, '2025-11-22 22:50:04', 1);


--=================================
-- Inserts into PRIORITY QUEUE ====
--=================================
INSERT INTO PriorityQ (file_id, user_id, amount_paid, time, dj_id) VALUES
(2, 6, 5.00, '2025-11-22 19:15:20', 1),
(6, 7, 3.50, '2025-11-22 20:11:12', 1),
(9, 8, 10.00, '2025-11-22 20:34:30', 1),
(15,9, 7.00, '2025-11-22 21:20:07', 1),
(20,10,4.00, '2025-11-22 23:59:59', 1);
