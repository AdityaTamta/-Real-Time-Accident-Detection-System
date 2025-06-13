--Schema--
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(5),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);

--Copying the data from csv file--
copy netflix (
  show_id, type, title, director, casts, country,
  date_added, release_year, rating, duration, listed_in, description
)
FROM 'D:/Netflix Database project/netflix_titles.csv' --add path to where you saved csv file.--
CSV HEADER;

--Count the number of Movies vs TV Shows--
Select
Count(Case when type ='Movie' then 1 End) as Number_of_Movies,
Count(Case when type = 'TV Show' then 1 End) as Number_of_TV_Shows
From Netflix;

--Find the most common rating for movies and TV shows--
select type,rating from 
(select type,rating, count(*),rank() over (partition by type order by count(*) desc ) as ranking
from netflix 
group by 1,2
)
where ranking = 1;

--List all movies released in a specific year (e.g., 2020)--
Select title,release_year from netflix where release_year = 2020 order by title asc;
1;

--Find the top 5 countries with the most content on Netflix--
select unnest(string_to_array(country, ',')) as country ,
count(show_id) as total_count 
from netflix
group by 1
order by 2 
limit 5;

--Identify the longest movie--
select title,duration from(
select title,duration, rank() over (order by Cast( Split_part(duration, ' ', 1 ) As Integer )Desc) as ranking 
from netflix 
where duration IS NOT NULL
group by duration,title
) where ranking = 1;

--Find content added in the last 5 years--
select title,duration,release_year from netflix
where release_year between
	(select max(release_year) from netflix)-4
	and
	(select max(release_year) from netflix)
order by release_year desc,title

--Find all the movies/TV shows by director 'Rajiv Chilaka'--
select title,type,director from netflix where director = 'Rajiv Chilaka';

--List all TV shows with more than 5 seasons--
Select title,type,Number_of_Seasons from(
select title,type, cast (split_part(duration, ' ',1) as Integer) as Number_of_Seasons from netflix where type = 'TV Show'
) as tv
where Number_of_Seasons >5
order by Number_of_Seasons desc;

--Count the number of content items in each genre--


select * from netflix;