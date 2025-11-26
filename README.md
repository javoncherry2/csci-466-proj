To get access to the database use the database.sql to get the most recents version of the database

*Fixed the sql script, it wasnt working before. Also found and added the songs,
if you guys want to change any of the songs, thats fine (some songs I picked have multiple different versions)


Hamzah Subhani - Notes for 11/17
We inserted some more values for our tables. i also fixed some errors with my queue tables (open and priority). I can talk about those on Wednesday. The next step should be finishing inserting values for KaroakeFile and Contributed. I did Contributer and I think Morgan is doing Requested Songs tonight. 

Javon Cherry - Notes for 11/23
**Changes to database code**
1. Changed contribution type to writer, singer, and instrumentalist.
2. Added different versions of a few songs to the database (clean/live/classical, etc.).
3. Added specific submit times for base data in queues.
4. Removed foreign keys from DJ (DJ doesn’t want to see individual rows; access can be provided with pdo on website).
5. Added a foreign key to the queues due to changed relationships in the ER diagram.
6. Changed the primary key for Contributed to contributor_id, song_id, and contributiontype_id to prevent insert errors.
7. Gave queues a foreign key to DJ to indicate which DJ is controlling the queue (only because of the changed ER).

**Changes to ER diagram**
1. Changed ternary relationship to two binary 1:1 relationships.
  -This was done because it was easier to work with. Without this change, we would have had to create another table for     the ternary relationship.
2. Changed Song and Karaoke to 1:1 because there can only be one file per song, and vice versa.
3. Changed KaraokeFile and sent to relationship to 1:M.
  -This is because a row in the queue refers to only one song file, but one file can appear in a queue multiple times.
4. Added two 1:1 "can be in" relationships between User and the two queues.
  -This was necessary because we had a user_id foreign key in the queues without an relationship to get it.

**Other Things**
1. I also updated the description and relations.

Everything should be up to date and working now!
Next time we meet, we should start working on the actual websites,
If you have any questions or changes you want to make lmk.

Hamzah Subhani - Notes for 11/26

I was able to create the web interface! It shows all the songs and also has a search function to search by main artist, title, and contributor. I also tried requesting a song for both Queues. i logged into Javons MariaDB and checked both the openq and priorityq tables and it worked!! I am still trying to figure out how to sort descending and ascending when multiple rows and returned. If you want to try it out for youself, make sure to put database.sql, user_i.php and db_connect.php into your public_html folder and then click user_i.php on your domain to check it. I know Javon had a php file that connects ot the database but I just added my own anyways. 


