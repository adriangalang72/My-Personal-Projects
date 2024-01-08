
'Data Exploration of the top 250 kdrama dataset'
'Hypothesis: The Highest rated shows are determined by the types and amounts of audience the show garners'
'Goals to figure out with this dataset:
Do Actors who are present in a higher-than-average amount of shows affect the ratings?
What is the most popular show for this current data set?
What is the most popular genre?
What is the least popular genre and how could it be improved?
What Network has had the most success in shows?
What Network is the least successful and what can they improve on?
Are the show ratings affected by the show length and season length?'
'What directors and screenwriters have the most shows on this list?'

'Do Actors who are present in a higher than average amount of shows affect the ratings?'
'Lets count the total amount of Actors in this data set'

Select COUNT(distinct(Actor)) as Total_Actors
From kdrama_actor

'There are 820 Unique Actors in this top 250 kdrama dataset.'
'Next lets count the amount of shows each Actor has'

Select  Actor, COUNT(Actor) as show_count From kdrama_actor Group by Actor;

'Next is to count the avg amount of shows an actor typically has'

Select  avg(show_count) 
	From (
    Select  Actor, COUNT(Actor) as show_count From kdrama_actor Group by Actor
    )
    as avg_count

'On average, actors have 1.8 shows'
'Lets see actors who have the highest amount of shows and see if that correlates with popular shows' 

Select  Actor, COUNT(Actor) as show_count From kdrama_actor Group by Actor Order by show_count desc;

Select  a.Actor, avg(b.Rating) as avg_rating, COUNT(Actor) as show_count
From kdrama_actor as a
Left Join kdrama_network as b
On b.`Name` = a.`Name`
Group by Actor
Order by show_count Desc;

'From this query, actors who are part of the main cast in many shows are not 
necessarily part of the most popular shows, meaning their inherent frequency to be in a lot of shows
is not really correlated with a shows success in ratings'

'What is the most popular show for this current data set?'
'Using the original dataset, we can immediately get a good idea of the best show on this list using the rank. 
However, we will need to reformat the rank column 
To do this I simply went to excel and used the find and replace function to remove the # for the rank column.
This resulted in turning the entire column into an int column which made it easier to order the dataset by rank'

Select * 
From kdrama_main
Order by `Rank` 

'This most popular show for the current time period of this dataset is Move to Heaven, it is ranked #1 in the dataset 
and also has the highest show rating'

'What is the most popular genre?
What is the least popular genre and how could it be improved?'

select `Name`,
  SUBSTRING_INDEX(SUBSTRING_INDEX(kdrama_category.Genre, ',', numbers.n), ',', -1) main_genre
from
  (select 1 n union all
   select 2 union all select 3 union all
   select 4 union all select 5) numbers INNER JOIN kdrama_category
  on CHAR_LENGTH(kdrama_category.Genre)
     -CHAR_LENGTH(REPLACE(kdrama_category.Genre, ',', ''))>=numbers.n-1
order by
  Genre, n
;
'This line of code allows the string of genres combined in each row to be separated and reformatted into a new table called category_rating in order to analyze
the most and least popular genre'


Select main_genre, avg(Rating) as avg_rating, count(main_genre) as show_num
From category_rating
Group by main_genre
Order by show_num desc
;

'The highest rated genre based on the average calculations is the Romance and Drama genre
whereas the lowest rate genre is the Sitcom genre. There are other higher average rating 
genres however these genres have much less of a sample size of shows 
connected to them so it is harder to trust these averages. 

This indicates that generally this top 250 
kdrama list seems appealing to a younger audience/demographic. The Sitcom genre could improve 
if the shows in this genre could somehow appeal to a younger audience. These averages are highly affected 
by the amounts of shows that contain these specific tags below is the code that reflects this.'


'What Network has had the most success in shows?
What Network is the least successful and what can they improve on?'


Select Original_Network, avg(Rating) as avg_rating, count(Original_Network) as show_num
From kdrama_network
Group by Original_Network
Order by show_num desc
;

'Based on the average ratings of the shows , it seems that the most common Network 
with the highest ratings is  tvN and Netflix. These networks has generated a both a strong amount of
 shows with high average ratings. '
 
 'The worst networks are Hulu, and SBS, ViuTV as they both have the least number of shows within this
 top 250 list as well as the lowest ratings. These networks could improve by generating more shows in the 
 Romance Drama genre because these are the most highly rated types of shows with these tags in the list.'
 
 
'What insights can be drawn by the show length, season length?'

Select a.Duration, avg(b.Rating) as avg_rating, count(a.Duration) as show_num
From kdrama_episode as a
Left join kdrama_network as b
on b.`Name` = a.`Name`
Group by Duration
Order by show_num desc

'The most common episode length times are usually around 1hr. The average rating around this lengths are roughly 8.5.'

Select * 
From kdrama_episode


Select a.`Number of Episodes`, avg(b.Rating) as avg_rating, count(a.`Number of Episodes`) as show_num
From kdrama_episode as a
Left join kdrama_network as b
on b.`Name` = a.`Name`
Group by `Number of Episodes`
Order by show_num desc

'About 46% of shows have around 16 episodes in length, 11% for 20 episodes, and around 10% for 12 episodes.
The rest are a random assortment of episodes numbers for a season. Clearly 16 is generally a pretty optimal
amount for these kdrama shows' 


'What directors and screenwriters have the most shows on this list?'

Select *
From kdrama_network 

Create Table directors
Select `Name`,
  SUBSTRING_INDEX(SUBSTRING_INDEX(kdrama_network.Director, ',', numbers.n), ',', -1) main_director
From
  (select 1 n union all
   select 2 union all select 3 union all
   select 4 union all select 5) numbers INNER JOIN kdrama_network
  on CHAR_LENGTH(kdrama_network.Director)
     -CHAR_LENGTH(REPLACE(kdrama_network.Director, ',', ''))>=numbers.n-1
order by
  Director, n
;

select a.main_director, count(a.`Name`) as num_shows, avg(b.Rating) as avg_rating
from directors as a
Left Join kdrama_network as b
on b.`Name` = a.`Name`
Where a.`Name` <> 'It\'s Okay, That\'s Friendship'
Group by main_director
Order by num_shows desc
;

'After analyzing the metrics for the directors, it is noticable that most of the directors with high average ratings
have directed very few shows which is why their average is high in these calculations. Whereas the directors
who have done more shows that are on this list have a bit lower ratings. The show It\'s Okay, That\'s Friendship 
was removed from the analysis because not only is it just a short 1 episode special, but there were not any directors and screenwriters
for the episode

It is noticeable that Shin Won Ho in particular has both a decent number of shows within this list as well as 
a high average rating.' 

Create Table screenwriters
select `Name`,
  SUBSTRING_INDEX(SUBSTRING_INDEX(kdrama_network.Screenwriter, ',', numbers.n), ',', -1) main_screenwriter
from
  (select 1 n union all
   select 2 union all select 3 union all
   select 4 union all select 5) numbers INNER JOIN kdrama_network
  on CHAR_LENGTH(kdrama_network.Screenwriter)
     -CHAR_LENGTH(REPLACE(kdrama_network.Screenwriter, ',', ''))>=numbers.n-1
order by
  Screenwriter, n
;

Select *
from screenwriters
;

select a.main_screenwriter, count(a.`Name`) as num_shows, avg(b.Rating) as avg_rating
from screenwriters as a
Left Join kdrama_network as b
on b.`Name` = a.`Name`
Where a.`Name` <> 'It\'s Okay, That\'s Friendship'
Group by main_screenwriter
Order by num_shows desc
;

'The result seems similar to the analysis on the directors. In this case as well,
Lee Woo Jung has both a decent number of shows within this list as well as a high average.'
