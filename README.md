# Cinematrix
A course project for CS-207N. Cinematrix is a DBMS that gives a user convenient access to information related to their favourite movies, TV shows, and celebrities.

Made by
| Name         | Roll No |
|--------------|---------|
| Aman Gupta        | 230001006     |
| Srinidhi Sai Boorgu          | 230001072     |
| Abhinav Bitragunta     | 230001003     |
| Ansh Jain     | 230004005     |


The website used the following technologies:
| Front-end         | Back-end |
|--------------|---------|
| HTML/CSS        | Node.js     |
| JavaScript          | Express     |
| Bootstrap     | EJS Templating engine     |
| Tailwind CSS     |  MySQL(for database)   |

##  Database schema
```sql
CREATE  TABLE  Age_Ratings (

Age_Rating_ID INT  PRIMARY KEY,

Age_Rating_Name VARCHAR(50)

);

  

CREATE  TABLE  Movies (

Movie_ID INT  PRIMARY KEY,

Title VARCHAR(200) NOT NULL,

Duration TIME  NOT NULL,

Revenue FLOAT,

Release_Date DATE  NOT NULL,

Description  VARCHAR(2000),

Movie_Rating FLOAT, -- CHECK (Movie_Rating >= 0 AND Movie_Rating <= 10), insert trigger

Num_Ratings_Movies INT  DEFAULT  0,

Budget FLOAT,

Movie_Trailer_URL VARCHAR(200),

Age_Rating_ID INT,

FOREIGN KEY (Age_Rating_ID) REFERENCES Age_Ratings(Age_Rating_ID) ON DELETE  SET  NULL

);

  

CREATE  TABLE  TV_Shows (

Show_ID INT  PRIMARY KEY,

Title VARCHAR(200),

Start_Date  DATE,

End_Date DATE,

TVShow_Rating FLOAT,

Num_Ratings_TV INT,

Description  VARCHAR(2000),

TVShow_Trailer_URL VARCHAR(200),

Age_Rating_ID INT,

FOREIGN KEY (Age_Rating_ID) REFERENCES Age_Ratings(Age_Rating_ID) ON DELETE  SET  NULL

);

  

CREATE  TABLE  Episodes (

Show_ID INT,

Episode_Number INT,

Season_Number INT,

Title VARCHAR(200),

Duration TIME,

Release_Date DATE,

Num_Ratings_Ep INT,

Episode_Rating FLOAT,

Description  VARCHAR(2000),

PRIMARY KEY (Show_ID, Episode_Number, Season_Number),

FOREIGN KEY (Show_ID) REFERENCES TV_Shows(Show_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  Genres (

Genre_ID INT  PRIMARY KEY,

Genre_Name VARCHAR(100)

);

  

CREATE  TABLE  Awards (

Award_ID INT  PRIMARY KEY,

Award_Name VARCHAR(100),

Award_Category VARCHAR(100)

);

  

CREATE  TABLE  People (

Person_ID INT  PRIMARY KEY,

Person_First_Name VARCHAR(100),

Person_Last_Name VARCHAR(100),

Person_DOB DATE,

Person_Gender VARCHAR(100),

Person_Nationality VARCHAR(100)

);

  

CREATE  TABLE  Director (

Director_ID INT  PRIMARY KEY,

Directorial_Style VARCHAR(100),

FOREIGN KEY (Director_ID) REFERENCES People(Person_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  Producer (

Producer_ID INT  PRIMARY KEY,

Production_Methodology VARCHAR(100),

FOREIGN KEY (Producer_ID) REFERENCES People(Person_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  Actor (

Actor_ID INT  PRIMARY KEY,

Role_Range VARCHAR(100),

FOREIGN KEY (Actor_ID) REFERENCES People(Person_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  Languages (

Language_ID INT  PRIMARY KEY,

Language_Name VARCHAR(100)

);

  
  

CREATE  TABLE  Users (

User_ID INT  PRIMARY KEY AUTO_INCREMENT,

Username VARCHAR(100),

User_Mail VARCHAR(100),

User_Password_Encrypted VARCHAR(500),

User_Role VARCHAR(50),

User_Authentication_Key VARCHAR(500),

User_Join_Date DATE,

User_Last_Online DATETIME,

User_DOB VARCHAR(15),

User_Country VARCHAR(100),

Watchlist_URL VARCHAR(200)

);

  

CREATE  TABLE  Reviews (

Review_ID INT  PRIMARY KEY AUTO_INCREMENT,

User_ID INT,

Review_Comment VARCHAR(2000),

Media_Rating FLOAT,

Review_Date DATE,

Like_Count INT,

Dislike_Count INT,

FOREIGN KEY (User_ID) REFERENCES Users(User_ID) ON DELETE  SET  NULL

);

  

CREATE  TABLE  Streaming_Sites (

Site_ID INT  PRIMARY KEY,

Site_Name VARCHAR(100),

Site_URL VARCHAR(200),

Subscription_Starting_Price FLOAT

);

  
  
  

CREATE  TABLE  movieIsOfGenre (

Movie_ID INT,

Genre_ID INT,

PRIMARY KEY (Movie_ID, Genre_ID),

FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE,

FOREIGN KEY (Genre_ID) REFERENCES Genres(Genre_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  movieDirectedBy (

Movie_ID INT,

Director_ID INT,

PRIMARY KEY (Movie_ID, Director_ID),

FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE,

FOREIGN KEY (Director_ID) REFERENCES Director(Director_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  movieProducedBy (

Movie_ID INT,

Producer_ID INT,

PRIMARY KEY (Movie_ID, Producer_ID),

FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE,

FOREIGN KEY (Producer_ID) REFERENCES Producer(Producer_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  movieActedBy (

Movie_ID INT,

Actor_ID INT,

Character_Number INT,

Character_Name VARCHAR(100),

Role_Type VARCHAR(100),

PRIMARY KEY (Movie_ID, Actor_ID, Character_Number),

FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE,

FOREIGN KEY (Actor_ID) REFERENCES Actor(Actor_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  movieAwarded (

Movie_ID INT,

Award_ID INT,

Year_Of_Awarding SMALLINT,

PRIMARY KEY (Movie_ID, Award_ID),

FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE,

FOREIGN KEY (Award_ID) REFERENCES Awards(Award_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  movieAvailableIn (

Movie_ID INT,

Language_ID INT,

PRIMARY KEY (Movie_ID, Language_ID),

FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE,

FOREIGN KEY (Language_ID) REFERENCES Languages(Language_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  movieReviewed (

Review_ID INT  PRIMARY KEY,

Movie_ID INT,

FOREIGN KEY (Review_ID) REFERENCES Reviews(Review_ID) ON DELETE CASCADE,

FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  movieStreamsHere (

Movie_ID INT,

Site_ID INT,

PRIMARY KEY (Movie_ID, Site_ID),

FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE,

FOREIGN KEY (Site_ID) REFERENCES Streaming_Sites(Site_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  showIsOfGenre (

Show_ID INT,

Genre_ID INT,

PRIMARY KEY (Show_ID, Genre_ID),

FOREIGN KEY (Show_ID) REFERENCES TV_Shows(Show_ID) ON DELETE CASCADE,

FOREIGN KEY (Genre_ID) REFERENCES Genres(Genre_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  showDirectedBy (

Show_ID INT,

Director_ID INT,

PRIMARY KEY (Show_ID, Director_ID),

FOREIGN KEY (Show_ID) REFERENCES TV_Shows(Show_ID) ON DELETE CASCADE,

FOREIGN KEY (Director_ID) REFERENCES Director(Director_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  showProducedBy (

Show_ID INT,

Producer_ID INT,

PRIMARY KEY (Show_ID, Producer_ID),

FOREIGN KEY (Show_ID) REFERENCES TV_Shows(Show_ID) ON DELETE CASCADE,

FOREIGN KEY (Producer_ID) REFERENCES Producer(Producer_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  showActedBy (

Show_ID INT,

Actor_ID INT,

Character_Number INT,

Character_Name VARCHAR(100),

Role_Type VARCHAR(100),

PRIMARY KEY (Show_ID, Actor_ID, Character_Number),

FOREIGN KEY (Show_ID) REFERENCES TV_Shows(Show_ID) ON DELETE CASCADE,

FOREIGN KEY (Actor_ID) REFERENCES Actor(Actor_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  showAwarded (

Show_ID INT,

Award_ID INT,

Year_Of_Awarding SMALLINT,

PRIMARY KEY (Show_ID, Award_ID, Year_Of_Awarding),

FOREIGN KEY (Show_ID) REFERENCES TV_Shows(Show_ID) ON DELETE CASCADE,

FOREIGN KEY (Award_ID) REFERENCES Awards(Award_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  showAvailableIn (

Show_ID INT,

Language_ID INT,

PRIMARY KEY (Show_ID, Language_ID),

FOREIGN KEY (Show_ID) REFERENCES TV_Shows(Show_ID) ON DELETE CASCADE,

FOREIGN KEY (Language_ID) REFERENCES Languages(Language_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  showReviewed (

Review_ID INT,

Show_ID INT,

PRIMARY KEY (Review_ID),

FOREIGN KEY (Review_ID) REFERENCES Reviews(Review_ID) ON DELETE CASCADE,

FOREIGN KEY (Show_ID) REFERENCES TV_Shows(Show_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  showStreamsHere (

Show_ID INT,

Site_ID INT,

PRIMARY KEY (Show_ID, Site_ID),

FOREIGN KEY (Show_ID) REFERENCES TV_Shows(Show_ID) ON DELETE CASCADE,

FOREIGN KEY (Site_ID) REFERENCES Streaming_Sites(Site_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  episodeDirectedBy (

Show_ID INT,

Episode_Number INT,

Season_Number INT,

Director_ID INT,

PRIMARY KEY (Show_ID, Episode_Number, Season_Number, Director_ID),

FOREIGN KEY (Show_ID, Episode_Number, Season_Number) REFERENCES Episodes(Show_ID, Episode_Number, Season_Number) ON DELETE CASCADE,

FOREIGN KEY (Director_ID) REFERENCES Director(Director_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  episodeProducedBy (

Show_ID INT,

Episode_Number INT,

Season_Number INT,

Producer_ID INT,

PRIMARY KEY (Show_ID, Episode_Number, Season_Number, Producer_ID),

FOREIGN KEY (Show_ID, Episode_Number, Season_Number) REFERENCES Episodes(Show_ID, Episode_Number, Season_Number) ON DELETE CASCADE,

FOREIGN KEY (Producer_ID) REFERENCES Producer(Producer_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  episodeActedBy (

Show_ID INT,

Episode_Number INT,

Season_Number INT,

Actor_ID INT,

Character_Number INT,

Character_Name VARCHAR(100),

Role_Type VARCHAR(100),

PRIMARY KEY (Show_ID, Episode_Number, Season_Number, Actor_ID, Character_Number),

FOREIGN KEY (Show_ID, Episode_Number, Season_Number) REFERENCES Episodes(Show_ID, Episode_Number, Season_Number) ON DELETE CASCADE,

FOREIGN KEY (Actor_ID) REFERENCES Actor(Actor_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  episodeReviewed (

Review_ID INT,

Show_ID INT,

Episode_Number INT,

Season_Number INT,

PRIMARY KEY (Review_ID),

FOREIGN KEY (Review_ID) REFERENCES Reviews(Review_ID) ON DELETE CASCADE,

FOREIGN KEY (Show_ID, Episode_Number, Season_Number) REFERENCES Episodes(Show_ID, Episode_Number, Season_Number) ON DELETE CASCADE

);

  

CREATE  TABLE  personAwarded (

Person_ID INT,

Award_ID INT,

Year_Of_Awarding SMALLINT,

PRIMARY KEY (Person_ID, Award_ID, Year_Of_Awarding),

FOREIGN KEY (Person_ID) REFERENCES People(Person_ID) ON DELETE CASCADE,

FOREIGN KEY (Award_ID) REFERENCES Awards(Award_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  movieSequel (

Movie_ID INT,

Sequel_ID INT,

PRIMARY KEY (Movie_ID),

FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE,

FOREIGN KEY (Sequel_ID) REFERENCES Movies(Movie_ID) ON DELETE  SET  NULL

);

  

CREATE  TABLE  moviePrequel (

Movie_ID INT,

Prequel_ID INT,

PRIMARY KEY (Movie_ID),

FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE,

FOREIGN KEY (Prequel_ID) REFERENCES Movies(Movie_ID) ON DELETE  SET  NULL

);

  
  
CREATE  TABLE  movieWatchlisted (

User_ID INT,

Movie_ID INT,

PRIMARY KEY (User_ID, Movie_ID),

FOREIGN KEY (User_ID) REFERENCES Users(User_ID) ON DELETE CASCADE,

FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE

);

  

CREATE  TABLE  showWatchlisted (

User_ID INT,

Show_ID INT,

PRIMARY KEY (User_ID, Show_ID),

FOREIGN KEY (User_ID) REFERENCES Users(User_ID) ON DELETE CASCADE,

FOREIGN KEY (Show_ID) REFERENCES TV_Shows(Show_ID) ON DELETE CASCADE

);
```
## Indices
Indices in this project have been created on every frequently joined and searched table.
```sql
CREATE  INDEX  idx_movies_title  ON Movies (Title);

CREATE  INDEX  idx_movies_release_date  ON Movies (Release_Date);

CREATE  INDEX  idx_movies_rating  ON Movies (Movie_Rating);

  

CREATE  INDEX  idx_tvshows_title  ON TV_Shows (Title);

CREATE  INDEX  idx_tvshows_start_date  ON TV_Shows (Start_Date);

CREATE  INDEX  idx_tvshows_rating  ON TV_Shows (TVShow_Rating);

  

CREATE  INDEX  idx_episodes_show  ON Episodes (Show_ID);

CREATE  INDEX  idx_episodes_title  ON Episodes (Title);

CREATE  INDEX  idx_episodes_release_date  ON Episodes (Release_Date);

CREATE  INDEX  idx_episodes_rating  ON Episodes (Episode_Rating);

  

CREATE  INDEX  idx_genres_name  ON Genres (Genre_Name);

  

CREATE  INDEX  idx_awards_name  ON Awards (Award_Name);

CREATE  INDEX  idx_awards_category  ON Awards (Award_Category);

  

CREATE  INDEX  idx_people_full_name  ON People (Person_First_Name, Person_Last_Name);

CREATE  INDEX  idx_people_dob  ON People (Person_DOB);

CREATE  INDEX  idx_people_nationality  ON People (Person_Nationality);

  

CREATE  INDEX  idx_director_style  ON Director (Directorial_Style);

  

CREATE  INDEX  idx_producer_methodology  ON Producer (Production_Methodology);

  

CREATE  INDEX  idx_actor_role_range  ON Actor (Role_Range);

  

CREATE  INDEX  idx_languages_name  ON Languages (Language_Name);

  

CREATE  INDEX  idx_reviews_user  ON Reviews (User_ID);

CREATE  INDEX  idx_reviews_rating  ON Reviews (Media_Rating);

CREATE  INDEX  idx_reviews_date  ON Reviews (Review_Date);

  

CREATE  INDEX  idx_users_id  ON Users (User_ID);

CREATE  INDEX  idx_users_username  ON Users (Username);

CREATE  INDEX  idx_users_mail  ON Users (User_Mail);

  

CREATE  INDEX  idx_streaming_sites_name  ON Streaming_Sites (Site_Name);

  

CREATE  INDEX  idx_age_ratings_name  ON Age_Ratings (Age_Rating_Name);

  

CREATE  INDEX  idx_movie_genre  ON movieIsOfGenre (Movie_ID);

CREATE  INDEX  idx_genre_movie  ON movieIsOfGenre (Genre_ID);

  

CREATE  INDEX  idx_movie_director  ON movieDirectedBy (Movie_ID);

CREATE  INDEX  idx_director_movie  ON movieDirectedBy (Director_ID);

  

CREATE  INDEX  idx_movie_producer  ON movieProducedBy (Movie_ID);

CREATE  INDEX  idx_producer_movie  ON movieProducedBy (Producer_ID);

  

CREATE  INDEX  idx_movie_acted_by_movie  ON movieActedBy (Movie_ID);

CREATE  INDEX  idx_movie_acted_by_actor  ON movieActedBy (Actor_ID);

  

CREATE  INDEX  idx_movie_awarded_movie  ON movieAwarded (Movie_ID);

CREATE  INDEX  idx_movie_awarded_award  ON movieAwarded (Award_ID);

  

CREATE  INDEX  idx_movie_available_in_movie  ON movieAvailableIn (Movie_ID);

CREATE  INDEX  idx_movie_available_in_language  ON movieAvailableIn (Language_ID);

  

CREATE  INDEX  idx_movie_reviewed_movie  ON movieReviewed (Movie_ID);

  

CREATE  INDEX  idx_movie_streams_here_movie  ON movieStreamsHere (Movie_ID);

CREATE  INDEX  idx_movie_streams_here_site  ON movieStreamsHere (Site_ID);

  

CREATE  INDEX  idx_show_is_of_genre_show  ON showIsOfGenre (Show_ID);

CREATE  INDEX  idx_show_is_of_genre_genre  ON showIsOfGenre (Genre_ID);

  

CREATE  INDEX  idx_show_directed_by_show  ON showDirectedBy (Show_ID);

CREATE  INDEX  idx_show_directed_by_director  ON showDirectedBy (Director_ID);

  

CREATE  INDEX  idx_show_produced_by_show  ON showProducedBy (Show_ID);

CREATE  INDEX  idx_show_produced_by_producer  ON showProducedBy (Producer_ID);

  

CREATE  INDEX  idx_show_acted_by_show  ON showActedBy (Show_ID);

CREATE  INDEX  idx_show_acted_by_actor  ON showActedBy (Actor_ID);

  

CREATE  INDEX  idx_show_awarded_show  ON showAwarded (Show_ID);

CREATE  INDEX  idx_show_awarded_award  ON showAwarded (Award_ID);

  

CREATE  INDEX  idx_show_available_in_show  ON showAvailableIn (Show_ID);

CREATE  INDEX  idx_show_available_in_language  ON showAvailableIn (Language_ID);

  

CREATE  INDEX  idx_show_reviewed_show  ON showReviewed (Show_ID);

  

CREATE  INDEX  idx_show_streams_here_show  ON showStreamsHere (Show_ID);

CREATE  INDEX  idx_show_streams_here_site  ON showStreamsHere (Site_ID);

  

CREATE  INDEX  idx_episode_directed_by_episode  ON episodeDirectedBy (Show_ID, Episode_Number, Season_Number);

CREATE  INDEX  idx_episode_directed_by_director  ON episodeDirectedBy (Director_ID);

  

CREATE  INDEX  idx_episode_produced_by_episode  ON episodeProducedBy (Show_ID, Episode_Number, Season_Number);

CREATE  INDEX  idx_episode_produced_by_producer  ON episodeProducedBy (Producer_ID);

  

CREATE  INDEX  idx_episode_acted_by_episode  ON episodeActedBy (Show_ID, Episode_Number, Season_Number);

CREATE  INDEX  idx_episode_acted_by_actor  ON episodeActedBy (Actor_ID);

  

CREATE  INDEX  idx_episode_reviewed_episode  ON episodeReviewed (Show_ID, Episode_Number, Season_Number);

  

CREATE  INDEX  idx_person_awarded_person  ON personAwarded (Person_ID);

CREATE  INDEX  idx_person_awarded_award  ON personAwarded (Award_ID);

  

CREATE  INDEX  idx_movie_sequel_movie  ON movieSequel (Movie_ID);

CREATE  INDEX  idx_movie_sequel_sequel  ON movieSequel (Sequel_ID);

  

CREATE  INDEX  idx_movie_prequel_movie  ON moviePrequel (Movie_ID);

CREATE  INDEX  idx_movie_prequel_prequel  ON moviePrequel (Prequel_ID);
```
## Triggers
Triggers in this project are used to update a newly joined user's join date, and a user's last online time.
```sql
DELIMITER $$

  

CREATE  TRIGGER  set_join_date

BEFORE  INSERT  ON Users

FOR EACH ROW

BEGIN

IF  NEW.User_Join_Date  IS  NULL  THEN

SET  NEW.User_Join_Date  = CURDATE();

END  IF;

END $$

  

DELIMITER ;

DELIMITER $$

  

CREATE  TRIGGER  update_last_online

BEFORE  UPDATE  ON Users

FOR EACH ROW

BEGIN

IF  OLD.User_Authentication_Key  <>  NEW.User_Authentication_Key  OR

(OLD.User_Authentication_Key  IS  NULL  AND  NEW.User_Authentication_Key  IS NOT NULL) OR

(OLD.User_Authentication_Key  IS NOT NULL  AND  NEW.User_Authentication_Key  IS  NULL) THEN

SET  NEW.User_Last_Online  =  NOW();

END  IF;

END $$

  

DELIMITER ;
```
