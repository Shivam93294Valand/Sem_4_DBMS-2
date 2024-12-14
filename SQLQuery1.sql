CREATE DATABASE CSE_4B_374

--Part – A
--1. Retrieve a unique genre of songs.
select distinct genre from Songs

--2. Find top 2 albums released before 2010.
select top 2 * from albums where Release_year < 2010

--3. Insert Data into the Songs Table. (1245, ‘Zaroor’, 2.55, ‘Feel good’, 1005)
insert into Songs values (1245, 'Zaroor', 2.55, 'Feel good', 1005)

--4. Change the Genre of the song ‘Zaroor’ to ‘Happy’
update Songs set genre = 'Happy' where Song_title = 'Zaroor'

--5. Delete an Artist ‘Ed Sheeran’
delete from Artists where Artist_name = 'Ed Sheeran'

--6. Add a New Column for Rating in Songs Table. [Ratings decimal(3,2)]
alter table Songs add Ratings decimal(3,2) 

--7. Retrieve songs whose title starts with 'S'.
select * from Songs where Song_title like 's%'

--8. Retrieve all songs whose title contains 'Everybody'.
select * from songs where Song_title like '%Everybody%'

--9. Display Artist Name in Uppercase.
select Upper(Artist_name) from Artists 

--10. Find the Square Root of the Duration of a Song ‘Good Luck’
select sqrt(Duration) from Songs where Song_title = 'Good Luck'

--11. Find Current Date.
select getdate()

--12. Find the number of albums for each artist.
select Artist_name, count(Albums.Artist_id) as Num_of_album from 
Artists inner join Albums on
Albums.Artist_id = Artists.Artist_id
group by Artist_name

--13. Retrieve the Album_id which has more than 5 songs in it.
SELECT Albums.Album_id FROM 
Albums INNER JOIN Songs ON 
Albums.Album_id = Songs.Album_id 
GROUP BY Albums.Album_id 
HAVING COUNT(Songs.Song_id) > 5;

--14. Retrieve all songs from the album 'Album1'. (using Subquery)
select Song_title from Songs where Album_id = (select Album_id from Albums where Album_id = 1001)

--15. Retrieve all albums name from the artist ‘Aparshakti Khurana’ (using Subquery)
select Album_title from Albums where Artist_id  = (select Artist_id from Artists where Artist_id = 1)

--16. Retrieve all the song titles with its album title.
select song_title, Album_title from 
Songs inner join Albums on
Songs.Album_id = Albums.Album_id 

--17. Find all the songs which are released in 2020.
select Song_title from 
Songs inner join Albums on
Songs.Album_id = Albums.Album_id
where Release_year = 2020

--18. Create a view called ‘Fav_Songs’ from the songs table having songs with song_id 101-105.
create view Fav_Songs
as select * from Songs where song_id < 106

--19. Update a song name to ‘Jannat’ of song having song_id 101 in Fav_Songs view.
update Fav_Songs set song_title = 'Jannat' where Song_id = 101

--20. Find all artists who have released an album in 2020.
select Artist_name from 
Artists inner join Albums on
Artists.Artist_id = Albums.Artist_id
where Release_year = 2020

--21. Retrieve all songs by Shreya Ghoshal and order them by duration. 
select Songs.Song_title from
Artists inner join Albums on
Artists.Artist_id = Albums.Artist_id 
inner join Songs on
Songs.Album_id = Albums.Album_id
where Artists.Artist_name = 'Shreya Ghoshal'
order by Songs.Duration

--Part – B
--22. Retrieve all song titles by artists who have more than one album.
select Song_title from 
Songs inner join Albums on 
Songs.Album_id = Albums.Album_id
inner join Artists on
Artists.Artist_id = Albums.Artist_id
where Artists.Artist_id in 
(select Artist_id from Albums group by Artist_id having count(Album_title) > 1)

--23. Retrieve all albums along with the total number of songs.
select Al.Album_title, Count(S.Song_title) from
Songs S inner join Albums Al on 
S.Album_id = Al.Album_id
Group by Album_title

--24. Retrieve all songs and release year and sort them by release year.
select S.Song_title, Al.Release_year from
Songs S inner join Albums Al on 
S.Album_id = Al.Album_id
order by Release_year

--25. Retrieve the total number of songs for each genre, showing genres that have more than 2 songs.
select Genre, Count(Song_id) as total_Song from Songs
Group by Genre 
having Count(Song_id) > 2

--26. List all artists who have albums that contain more than 3 songs
select Distinct Ar.Artist_name from
Artists Ar inner join Albums Al on
Ar.Artist_id = Al.Artist_id 
inner join Songs S on
Al.Album_id = S.Album_id 
where s.Album_id in (Select S.Album_id from Songs S group by S.Album_id having count(S.Album_id) > 3)

--Part – C
--27. Retrieve albums that have been released in the same year as 'Album4'
select Album_title from Albums where 
Release_year = (select Release_year from Albums where Album_title = 'Album4')

--28. Find the longest song in each genre
select genre, Song_title, Duration from Songs 
where Duration in (select max(Duration) from Songs group by Genre) order by Genre

--29. Retrieve the titles of songs released in albums that contain the word 'Album' in 
--the title.
select Song_title from 
Songs inner join Albums on
Songs.Album_id = Albums.Album_id
where Album_title like '%Album%'

--30. Retrieve the total duration of songs by each artist where total duration exceeds 
--15 minutes.
select Artist_name, sum(Duration) from 
Songs inner join Albums on
Songs.Album_id = Albums.Album_id
inner join Artists on
Albums.Artist_id = Artists.Artist_id
Group by Artist_name
having sum(Duration) > 15