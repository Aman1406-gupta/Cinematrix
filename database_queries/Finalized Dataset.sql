CREATE DATABASE CINEMATRIX_DB;
USE CINEMATRIX_DB;

CREATE TABLE Age_Ratings (
    Age_Rating_ID INT PRIMARY KEY,
    Age_Rating_Name VARCHAR(50)
);

CREATE TABLE Movies (
    Movie_ID INT PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    Duration TIME NOT NULL,
    Revenue FLOAT,
    Release_Date DATE NOT NULL,
    Description VARCHAR(2000),
    Movie_Rating FLOAT, -- CHECK (Movie_Rating >= 0 AND Movie_Rating <= 10), insert trigger
    Num_Ratings_Movies INT DEFAULT 0, 
    Budget FLOAT,
    Movie_Trailer_URL VARCHAR(200),
    Age_Rating_ID INT,
    FOREIGN KEY (Age_Rating_ID) REFERENCES Age_Ratings(Age_Rating_ID) ON DELETE SET NULL
);

CREATE TABLE TV_Shows (
    Show_ID INT PRIMARY KEY,
    Title VARCHAR(200),
    Start_Date DATE,
    End_Date DATE,
    TVShow_Rating FLOAT,
    Num_Ratings_TV INT,
    Description VARCHAR(2000),
    TVShow_Trailer_URL VARCHAR(200),
    Age_Rating_ID INT,
    FOREIGN KEY (Age_Rating_ID) REFERENCES Age_Ratings(Age_Rating_ID) ON DELETE SET NULL
);

CREATE TABLE Episodes (
    Show_ID INT,
    Episode_Number INT,
    Season_Number INT,
    Title VARCHAR(200),
    Duration TIME,
    Release_Date DATE,
    Num_Ratings_Ep INT,
    Episode_Rating FLOAT,
    Description VARCHAR(2000),
    PRIMARY KEY (Show_ID, Episode_Number, Season_Number),
    FOREIGN KEY (Show_ID) REFERENCES TV_Shows(Show_ID) ON DELETE CASCADE
);

CREATE TABLE Genres (
    Genre_ID INT PRIMARY KEY,
    Genre_Name VARCHAR(100)
);

CREATE TABLE Awards (
    Award_ID INT PRIMARY KEY,
    Award_Name VARCHAR(100),
    Award_Category VARCHAR(100)
);

CREATE TABLE People (
    Person_ID INT PRIMARY KEY,
    Person_First_Name VARCHAR(100),
    Person_Last_Name VARCHAR(100),
    Person_DOB DATE,
    Person_Gender VARCHAR(100),
    Person_Nationality VARCHAR(100)
);

CREATE TABLE Director (
    Director_ID INT PRIMARY KEY,
    Directorial_Style VARCHAR(100),
    FOREIGN KEY (Director_ID) REFERENCES People(Person_ID) ON DELETE CASCADE
);

CREATE TABLE Producer (
    Producer_ID INT PRIMARY KEY,
    Production_Methodology VARCHAR(100),
    FOREIGN KEY (Producer_ID) REFERENCES People(Person_ID) ON DELETE CASCADE
);

CREATE TABLE Actor (
    Actor_ID INT PRIMARY KEY,
    Role_Range VARCHAR(100),
    FOREIGN KEY (Actor_ID) REFERENCES People(Person_ID) ON DELETE CASCADE
);

CREATE TABLE Languages (
    Language_ID INT PRIMARY KEY,
    Language_Name VARCHAR(100)
);


CREATE TABLE Users (
    User_ID INT PRIMARY KEY AUTO_INCREMENT,
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

CREATE TABLE Reviews (
    Review_ID INT PRIMARY KEY AUTO_INCREMENT,
    User_ID INT,
    Review_Comment VARCHAR(2000),
    Media_Rating FLOAT,
    Review_Date DATE,
    Like_Count INT,
    Dislike_Count INT,
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID) ON DELETE SET NULL
);

CREATE TABLE Streaming_Sites (
    Site_ID INT PRIMARY KEY,
    Site_Name VARCHAR(100),
    Site_URL VARCHAR(200),
    Subscription_Starting_Price FLOAT
);



CREATE TABLE movieIsOfGenre (
    Movie_ID INT,
    Genre_ID INT,
    PRIMARY KEY (Movie_ID, Genre_ID),
    FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE,
    FOREIGN KEY (Genre_ID) REFERENCES Genres(Genre_ID) ON DELETE CASCADE
);

CREATE TABLE movieDirectedBy (
    Movie_ID INT,
    Director_ID INT,
    PRIMARY KEY (Movie_ID, Director_ID),
    FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE,
    FOREIGN KEY (Director_ID) REFERENCES Director(Director_ID) ON DELETE CASCADE
);

CREATE TABLE movieProducedBy (
    Movie_ID INT,
    Producer_ID INT,
    PRIMARY KEY (Movie_ID, Producer_ID),
    FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE,
    FOREIGN KEY (Producer_ID) REFERENCES Producer(Producer_ID) ON DELETE CASCADE
);

CREATE TABLE movieActedBy (
    Movie_ID INT,
    Actor_ID INT,
    Character_Number INT,
    Character_Name VARCHAR(100),
    Role_Type VARCHAR(100),
    PRIMARY KEY (Movie_ID, Actor_ID, Character_Number),
    FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE,
    FOREIGN KEY (Actor_ID) REFERENCES Actor(Actor_ID) ON DELETE CASCADE
);

CREATE TABLE movieAwarded (
    Movie_ID INT,
    Award_ID INT,
    Year_Of_Awarding SMALLINT,
    PRIMARY KEY (Movie_ID, Award_ID),
    FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE,
    FOREIGN KEY (Award_ID) REFERENCES Awards(Award_ID) ON DELETE CASCADE
);

CREATE TABLE movieAvailableIn (
    Movie_ID INT,
    Language_ID INT,
    PRIMARY KEY (Movie_ID, Language_ID),
    FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE,
    FOREIGN KEY (Language_ID) REFERENCES Languages(Language_ID) ON DELETE CASCADE
);

CREATE TABLE movieReviewed (
    Review_ID INT PRIMARY KEY,
    Movie_ID INT,
    FOREIGN KEY (Review_ID) REFERENCES Reviews(Review_ID) ON DELETE CASCADE,
    FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE
);

CREATE TABLE movieStreamsHere (
    Movie_ID INT,
    Site_ID INT,
    PRIMARY KEY (Movie_ID, Site_ID),
    FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE,
    FOREIGN KEY (Site_ID) REFERENCES Streaming_Sites(Site_ID) ON DELETE CASCADE
);

CREATE TABLE showIsOfGenre (
    Show_ID INT,
    Genre_ID INT,
    PRIMARY KEY (Show_ID, Genre_ID),
    FOREIGN KEY (Show_ID) REFERENCES TV_Shows(Show_ID) ON DELETE CASCADE,
    FOREIGN KEY (Genre_ID) REFERENCES Genres(Genre_ID) ON DELETE CASCADE
);

CREATE TABLE showDirectedBy (
    Show_ID INT,
    Director_ID INT,
    PRIMARY KEY (Show_ID, Director_ID),
    FOREIGN KEY (Show_ID) REFERENCES TV_Shows(Show_ID) ON DELETE CASCADE,
    FOREIGN KEY (Director_ID) REFERENCES Director(Director_ID) ON DELETE CASCADE
);

CREATE TABLE showProducedBy (
    Show_ID INT,
    Producer_ID INT,
    PRIMARY KEY (Show_ID, Producer_ID),
    FOREIGN KEY (Show_ID) REFERENCES TV_Shows(Show_ID) ON DELETE CASCADE,
    FOREIGN KEY (Producer_ID) REFERENCES Producer(Producer_ID) ON DELETE CASCADE
);

CREATE TABLE showActedBy (
    Show_ID INT,
    Actor_ID INT,
    Character_Number INT,
    Character_Name VARCHAR(100),
    Role_Type VARCHAR(100),
    PRIMARY KEY (Show_ID, Actor_ID, Character_Number),
    FOREIGN KEY (Show_ID) REFERENCES TV_Shows(Show_ID) ON DELETE CASCADE,
    FOREIGN KEY (Actor_ID) REFERENCES Actor(Actor_ID) ON DELETE CASCADE
);

CREATE TABLE showAwarded (
    Show_ID INT,
    Award_ID INT,
    Year_Of_Awarding SMALLINT,
    PRIMARY KEY (Show_ID, Award_ID, Year_Of_Awarding),
    FOREIGN KEY (Show_ID) REFERENCES TV_Shows(Show_ID) ON DELETE CASCADE,
    FOREIGN KEY (Award_ID) REFERENCES Awards(Award_ID) ON DELETE CASCADE
);

CREATE TABLE showAvailableIn (
    Show_ID INT,
    Language_ID INT,
    PRIMARY KEY (Show_ID, Language_ID),
    FOREIGN KEY (Show_ID) REFERENCES TV_Shows(Show_ID) ON DELETE CASCADE,
    FOREIGN KEY (Language_ID) REFERENCES Languages(Language_ID) ON DELETE CASCADE
);

CREATE TABLE showReviewed (
    Review_ID INT,
    Show_ID INT,
    PRIMARY KEY (Review_ID),
    FOREIGN KEY (Review_ID) REFERENCES Reviews(Review_ID) ON DELETE CASCADE,
    FOREIGN KEY (Show_ID) REFERENCES TV_Shows(Show_ID) ON DELETE CASCADE
);

CREATE TABLE showStreamsHere (
    Show_ID INT,
    Site_ID INT,
    PRIMARY KEY (Show_ID, Site_ID),
    FOREIGN KEY (Show_ID) REFERENCES TV_Shows(Show_ID) ON DELETE CASCADE,
    FOREIGN KEY (Site_ID) REFERENCES Streaming_Sites(Site_ID) ON DELETE CASCADE
);

CREATE TABLE episodeDirectedBy (
    Show_ID INT,
    Episode_Number INT,
    Season_Number INT,
    Director_ID INT,
    PRIMARY KEY (Show_ID, Episode_Number, Season_Number, Director_ID),
    FOREIGN KEY (Show_ID, Episode_Number, Season_Number) REFERENCES Episodes(Show_ID, Episode_Number, Season_Number) ON DELETE CASCADE,
    FOREIGN KEY (Director_ID) REFERENCES Director(Director_ID) ON DELETE CASCADE
);

CREATE TABLE episodeProducedBy (
    Show_ID INT,
    Episode_Number INT,
    Season_Number INT,
    Producer_ID INT,
    PRIMARY KEY (Show_ID, Episode_Number, Season_Number, Producer_ID),
	FOREIGN KEY (Show_ID, Episode_Number, Season_Number) REFERENCES Episodes(Show_ID, Episode_Number, Season_Number) ON DELETE CASCADE,
    FOREIGN KEY (Producer_ID) REFERENCES Producer(Producer_ID) ON DELETE CASCADE
);

CREATE TABLE episodeActedBy (
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

CREATE TABLE episodeReviewed (
    Review_ID INT,
    Show_ID INT,
    Episode_Number INT,
    Season_Number INT,
    PRIMARY KEY (Review_ID),
    FOREIGN KEY (Review_ID) REFERENCES Reviews(Review_ID) ON DELETE CASCADE,
    FOREIGN KEY (Show_ID, Episode_Number, Season_Number) REFERENCES Episodes(Show_ID, Episode_Number, Season_Number) ON DELETE CASCADE
);

CREATE TABLE personAwarded (
    Person_ID INT,
    Award_ID INT,
    Year_Of_Awarding SMALLINT,
    PRIMARY KEY (Person_ID, Award_ID, Year_Of_Awarding),
    FOREIGN KEY (Person_ID) REFERENCES People(Person_ID) ON DELETE CASCADE,
    FOREIGN KEY (Award_ID) REFERENCES Awards(Award_ID) ON DELETE CASCADE
);

CREATE TABLE movieSequel (
    Movie_ID INT,
    Sequel_ID INT,
    PRIMARY KEY (Movie_ID),
    FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE,
    FOREIGN KEY (Sequel_ID) REFERENCES Movies(Movie_ID) ON DELETE SET NULL
);

CREATE TABLE moviePrequel (
    Movie_ID INT,
    Prequel_ID INT,
    PRIMARY KEY (Movie_ID),
    FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE,
    FOREIGN KEY (Prequel_ID) REFERENCES Movies(Movie_ID) ON DELETE SET NULL
);

INSERT INTO Age_Ratings (Age_Rating_ID, Age_Rating_Name) VALUES
(1, 'G'),
(2, 'PG'),
(3, 'PG-13'),
(4, 'R'),
(5, 'NC-17');

CREATE TABLE movieWatchlisted (
    User_ID INT,
    Movie_ID INT,
    PRIMARY KEY (User_ID, Movie_ID),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID) ON DELETE CASCADE,
    FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID) ON DELETE CASCADE
);

CREATE TABLE showWatchlisted (
    User_ID INT,
    Show_ID INT,
    PRIMARY KEY (User_ID, Show_ID),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID) ON DELETE CASCADE,
    FOREIGN KEY (Show_ID) REFERENCES TV_Shows(Show_ID) ON DELETE CASCADE
);

INSERT INTO Movies (Movie_ID, Title, Duration, Revenue, Release_Date, Description, Movie_Rating, Num_Ratings_Movies, Budget, Movie_Trailer_URL, Age_Rating_ID) VALUES
(1, 'Inception', '02:28:00', 829895144, '2010-07-08', 'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O., but his tragic past may doom the project and his team to disaster.', 8.8, 2600000, 160000000, 'https://www.youtube.com/watch?v=YoHD9XEInc0', 3),
(2, 'The Dark Knight', '02:32:00', 1004558444, '2008-07-14', 'When the menace known as the Joker emerges from his mysterious past, he wreaks havoc and chaos on the people of Gotham.', 9.0, 2900000, 185000000, 'https://www.youtube.com/watch?v=EXeTwQWrcwY', 3),
(3, 'The Matrix', '02:16:00', 463517383, '1999-03-31', 'A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.', 8.7, 2100000, 63000000, 'https://youtu.be/vKQi3bBA1y8?si=QPM_YELi6gmwOJTv', 4),
(4, 'Avatar', '02:42:00', 2787965087, '2009-12-10', 'A paraplegic Marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home.', 7.9, 1400000, 237000000, 'https://www.youtube.com/watch?v=5PSNL1qE6VY', 3),
(5, 'Titanic', '03:14:00', 2187463944, '1997-12-19', 'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.', 7.8, 1300000, 200000000, 'https://www.youtube.com/watch?v=CHekzSiZjrY', 3),
(6, 'The Shawshank Redemption', '02:22:00', 58340000, '1994-09-10', 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.', 9.3, 3000000, 25000000, 'https://www.youtube.com/watch?v=6hB3S9bIaco', 4),
(7, 'The Godfather', '02:55:00', 246120974, '1972-03-14', 'An organized crime dynasty''s aging patriarch transfers control of his clandestine empire to his reluctant son.', 9.2, 2100000, 6000000, 'https://www.youtube.com/watch?v=sY1S34973zA', 4),
(8, 'Star Wars: Episode IV - A New Hope', '02:01:00', 775398007, '1977-05-25', 'Luke Skywalker joins forces with a Jedi Knight, a cocky pilot, a mysterious princess, and the galaxy''s most advanced droid to rescue the galaxy from a mysterious villain.', 8.6, 1500000, 11000000, 'https://www.youtube.com/watch?v=vZ734NWnAHA', 2),
(9, 'Jurassic Park', '02:07:00', 914691118, '1993-06-11', 'During a preview tour, a theme park suffers a major power breakdown that allows its cloned dinosaurs to run amok.', 8.1, 1100000, 63800000, 'https://www.youtube.com/watch?v=lc0UehYemQA', 3),
(10, 'The Lion King', '01:28:00', 968511105, '1994-06-15', 'Lion prince Simba flees his kingdom after the death of his father, but returns as an adult to reclaim his throne.', 8.5, 1200000, 45000000, 'https://www.youtube.com/watch?v=lFzVJEksoDY', 1),
(11, 'Finding Nemo', '01:40:00', 940335536, '2003-05-30', 'After his son is captured in the Great Barrier Reef and taken to Sydney, a timid clownfish sets out on a journey to bring him home.', 8.2, 1100000, 94000000, 'https://www.youtube.com/watch?v=9oQ628Seb9w', 2),
(12, 'Toy Story', '01:21:00', 373554033, '1995-11-22', 'A cowboy doll is profoundly threatened and jealous when a new spaceman figure supplants him as top toy in a boy''s room.', 8.3, 1100000, 30000000, 'https://www.youtube.com/watch?v=v-PjgYDrg70', 1),
(13, 'The Godfather: Part II', '03:22:00', 57300000, '1974-12-20', 'The early life and career of Vito Corleone in 1920s New York is portrayed while his son, Michael, expands and tightens his grip on the family crime syndicate.', 9.0, 1400000, 13000000, 'https://www.youtube.com/watch?v=9O1Iy9od7-A', 4),
(14, 'Finding Dory', '01:37:00', 1035000000, '2016-06-17', 'The friendly-but-forgetful blue tang fish, Dory, embarks on a search for her long-lost parents.', 7.2, 312000, 200000000, 'https://www.youtube.com/watch?v=JhvrQeY3doI', 2),
(15, 'Star Wars: Episode V - The Empire Strikes Back', '02:04:00', 538400000, '1980-05-21', 'After the Rebels are brutally overpowered by the Empire on the ice planet Hoth, Luke Skywalker begins Jedi training with Yoda.', 8.7, 1400000, 18000000, 'https://www.youtube.com/watch?v=JNwNXF9Y6kY', 2),
(16, 'Mad Max: Fury Road', '02:00:00', 375000000, '2015-05-15', 'In a post-apocalyptic wasteland, Max teams up with Furiosa to escape a tyrant and his army.', 8.1, 1100000, 15000000, 'https://www.youtube.com/watch?v=hEJnMQG9ev8', 4),
(17, 'Frozen II', '01:43:00', 1300000000, '2019-11-22', 'Anna, Elsa, Kristoff, Olaf and Sven embark on a journey to discover the origin of Elsa''s powers in Frozen II.', 6.8, 201000, 150000000, 'https://www.youtube.com/watch?v=Zi4LMpSDccc', 2),
(18, 'Jumanji: Welcome to the Jungle', '01:59:00', 962899546, '2017-12-20', 'Four high school kids are sucked into a magical video game, and the only way they can escape is to work together to finish the game.',7.0, 464000, 90000000, 'https://www.youtube.com/watch?v=2QKg5SZ_35I', 3),
(19, 'Deadpool', '01:48:00', 783112979, '2016-02-12', 'A former special forces operative turned mercenary is subjected to a rogue experiment that leaves him with accelerated healing powers.', 8.0, 1200000, 58000000, 'https://www.youtube.com/watch?v=Xithigfg7dA', 4),
(20, 'Guardians of the Galaxy', '02:01:00', 773328629, '2014-08-01', 'A group of intergalactic criminals must pull together to stop a fanatical warrior with plans to purge the universe.', 8.0, 1400, 232000000, 'https://www.youtube.com/watch?v=d96cjJhvlMA', 3),
(21, 'Spider-Man: No Way Home', '02:28:00', 1852580000, '2021-12-17', 'Spider-Man faces his greatest battle yet as he confronts villains from other dimensions while trying to save his loved ones.', 8.2, 914000, 200000000, 'https://www.youtube.com/watch?v=JfVOs4VSpmA', 3),
(22, 'Black Panther', '02:14:00', 1346913161, '2018-02-16', 'T''Challa, the new ruler of the advanced kingdom of Wakanda, must face a powerful foe in order to protect his nation.', 7.3, 855000, 200000000, 'https://www.youtube.com/watch?v=xjDjIWPwcPU', 3),
(23, 'Parasite', '02:12:00', 258123000, '2019-05-30', 'Greed and class discrimination threaten the newly formed symbiotic relationship between the wealthy Park family and the destitute Kim clan.', 8.6, 1000000, 11400000, 'https://www.youtube.com/watch?v=5xH0HfJHsaY', 4),
(24, 'The Silence of the Lambs', '01:58:00', 272742922, '1991-02-14', 'A young FBI cadet must confide in an incarcerated and manipulative killer to receive his help on catching another serial killer.', 8.6, 1600000, 19000000, 'https://www.youtube.com/watch?v=6iB21hsprAQ', 4),
(25, 'The Avengers', '02:23:00', 1518812988, '2012-05-04', 'Earth''s mightiest heroes must come together to stop Loki and his alien army from enslaving humanity.', 8.0, 1500000, 220000000, 'https://www.youtube.com/watch?v=eOrNdBpGMv8', 3),
(26, 'The Matrix Reloaded', '02:18:00', 741847937, '2003-05-07', 'Freedom fighters Neo, Trinity and Morpheus continue to lead the revolt against the Machine Army, unleashing their arsenal of extraordinary skills and weaponry against the systematic forces of repression and exploitation.', 7.2, 642000, 150000000, 'https://www.youtube.com/watch?v=kYzz0FSgpSU', 4),
(27, 'Avatar: The Way of Water', '03:12:00', 2320000000, '2022-12-06', 'Jake Sully lives with his newfound family formed on the extrasolar moon Pandora. Once a familiar threat returns to finish what was previously started, Jake must work with Neytiri and the army of the Na''vi race to protect their home.', 7.5, 515000, 390000000, 'https://www.youtube.com/watch?v=a8Gx8wiNbs8', 3),
(28, 'The Last Airbender', '01:43:00', 319000000, '2010-06-30',  'Aang, a young successor to a long line of Avatars, must master all four elements and stop the Fire Nation from enslaving the Water Tribes and the Earth Kingdom.', 4.0, 177000, 150000000, 'https://www.youtube.com/watch?v=-egQ79OrYCs', 2),
(29, 'The Godfather: Part III', '02:42:00', 136800000, '1990-12-20', 'Follows Michael Corleone, now in his 60s, as he seeks to free his family from crime and find a suitable successor to his empire.', 7.6, 432000, 54000000, 'https://www.youtube.com/watch?v=UUkG37KSWf0', 4),
(30, 'Toy Story 2', '01:32:00', 511000000, '1999-11-13', 'When Woody is stolen by a toy collector, Buzz and his friends set out on a rescue mission to save Woody before he becomes a museum toy property with his roundup gang Jessie, Prospector, and Bullseye.', 7.9, 633000, 90000000, 'https://www.youtube.com/watch?v=xNWSGRD5CzU', 1),
(31, 'Mar adentro', '02:06:00', 43731621, '2004-09-02', 'The factual story of Spaniard Ramon Sampedro, who fought a 28-year campaign in favor of euthanasia and his own right to die.', 8.0, 86000, 10000000,  'https://www.youtube.com/watch?v=PxXb_YZ-CQI', 3),
(32, 'El laberinto del fauno', '01:58:00', 83000000, '2006-05-27', 'In the Falangist Spain of 1944, the bookish young stepdaughter of a sadistic army officer escapes into an eerie but captivating fantasy world.', 8.2, 713000, 14000000, 'https://www.youtube.com/watch?v=FGzvvUBXj5M', 4),
(33, 'Intouchables', '01:52:00', 426590315, '2011-09-23', 'After he becomes a quadriplegic from a paragliding accident, an aristocrat hires a young man from the projects to be his caregiver.', 8.5, 951000, 10800000, 'https://www.youtube.com/watch?v=0RqDiYnFxTk', 4),
(34, 'Anatomie d''une chute' , '02:31:00', 36051506, '2023-05-21', 'A woman is suspected of murder after her husband''s death; their half-blind son faces a moral dilemma as the main witness.', 7.7, 156000, 6700000, 'https://www.youtube.com/watch?v=fTrsp5BMloA', 4),
(35, 'The Zone of Interest', '01:45:00', 52000000, '2023-05-19', 'Auschwitz commandant Rudolf Höss and his wife Hedwig strive to build a dream life for their family in a house and garden beside the camp.', 7.4, 116000, 15000000, 'https://www.youtube.com/watch?v=r-vfg3KkV54', 3),
(36, 'Im Westen nichts Neues', '02:28:00', 80000000, '2022-09-12', 'A young German soldier''s terrifying experiences and distress on the western front during World War I.', 7.8, 259000, 20000000, 'https://www.youtube.com/watch?v=Ug1bqv3ch1s', 4),
(37, 'Wo hu cang long', '2:00:00', 214000000, '2000-05-18', 'A young Chinese warrior steals a sword from a famed swordsman and then escapes into a world of romantic adventure with a mysterious man in the frontier of the nation.', 7.9, 285000, 17000000,  'https://www.youtube.com/watch?v=-jTdOdcMKoY', 3),
(38, 'Se, jie', '02:37:00', 67091915, '2007-08-30', 'During World War II era, a young woman, Wang Jiazhi, gets swept up in a dangerous game of emotional intrigue with a powerful political figure, Mr. Yee.', 7.5, 46000, 15000000, 'https://www.youtube.com/watch?v=tEO37mokpQc', 5),
(39, 'Kimitachi wa dô ikiru ka', '02:04:00', 320000000, '2023-07-14', 'In the wake of his mother''s death and his father''s remarriage, a headstrong boy named Mahito ventures into a dreamlike world shared by both the living and the dead.', 7.4, 78000, 10000000, 'https://www.youtube.com/watch?v=t5khm-VjEu4', 3),
(40, 'Perfect Days', '02:04:00', 25000000, '2023-05-25', 'Hirayama cleans public toilets in Tokyo, lives his life in simplicity and daily tranquility. Some encounters also lead him to reflect on himself.', 7.9, 64000, 14000000, 'https://www.youtube.com/watch?v=QzZBbX5A1FA', 2),
(41, '3 Idiots', '02:50:00', 90000000, '2009-11-09', 'Two friends are searching for their long lost companion. They revisit their college days and recall the memories of their friend who inspired them to think differently, even as the rest of the world called them \"idiots\".', 8.4, 446000, 20000000, 'https://www.youtube.com/watch?v=xvszmNXdM4w', 3),
(42, 'Lagaan: Once Upon a Time in India', '03:44:00', 15000000, '2001-06-15', 'The people of a small village in Victorian India stake their future on a game of cricket against their ruthless British rulers.', 8.1, 122000, 5320000, 'https://www.youtube.com/watch?v=oSIGQ0YkFxs', 2),
(43, 'Busanhaeng', '01:58:00', 98500000, '2016-05-13', 'While a zombie virus breaks out in South Korea, passengers struggle to survive on the train from Seoul to Busan.', 7.6, 271000, 8500000, 'https://www.youtube.com/watch?v=pyWuHv2-Abk', 5);

INSERT INTO TV_Shows (Show_ID, Title, Start_Date, End_Date, TVShow_Rating, Num_Ratings_TV, Description, TVShow_Trailer_URL, Age_Rating_ID) VALUES
(1, 'Breaking Bad', '2008-01-20', '2013-09-29', 9.5, 2200000, 'A high school chemistry teacher turned methamphetamine manufacturer partners with a former student to secure his family''s future.', 'https://www.youtube.com/watch?v=HhesaQXLuRY', 4),
(2, 'Game of Thrones', '2011-04-17', '2019-05-19', 9.3, 2400000, 'Nine noble families fight for control of the mythical land of Westeros.', 'https://www.youtube.com/watch?v=KPLWWIOCOOQ', 4),
(3, 'Stranger Things', '2016-07-15', NULL, 8.7, 1400000, 'A group of kids in a small town uncover a series of supernatural mysteries.', 'https://www.youtube.com/watch?v=b9EkMc79ZSU', 3),
(4, 'The Crown', '2016-11-04', NULL, 8.6, 264000, 'The inside story of Queen Elizabeth II''s reign and the events that shaped the second half of the 20th century.', 'https://www.youtube.com/watch?v=JWtnJjn6ng0', 4),
(5, 'The Mandalorian', '2019-11-12', NULL, 8.8, 605000, 'After the fall of the Empire, a lone gunfighter navigates the outer reaches of the galaxy.', 'https://www.youtube.com/watch?v=aOC8E8z_ifw', 3),
(6, 'The Office (US)', '2005-03-24', '2013-05-16', 9.0, 744000, 'A mockumentary on a group of typical office workers, portraying the everyday lives of the employees.', 'https://www.youtube.com/watch?v=-C2z-nshFts', 3),
(7, 'Friends', '1994-09-22', '2004-05-06', 8.9, 1100000, 'Six friends navigate the ups and downs of life in Manhattan.', 'https://www.youtube.com/watch?v=Zg2LCD5QOJs', 5),
(8, 'The Simpsons', '1989-12-17', NULL, 8.7, 444000, 'The satiric adventures of a working-class family in the misfit city of Springfield.', 'https://www.youtube.com/watch?v=3R1ebDCv7vM', 3),
(9, 'Sherlock', '2010-07-25', '2017-01-15', 9.1, 1000000, 'A modern update to the classic British detective tales of Sherlock Holmes.', 'https://www.youtube.com/watch?v=9UcR9iKArd0', 2),
(10, 'The Witcher', '2019-12-20', NULL, 8.0, 584000, 'A monster hunter struggles to find his place in a world where people often prove more wicked than beasts.', 'https://www.youtube.com/watch?v=ndl1W4ltcmg', 4),
(11, 'The Big Bang Theory', '2007-09-24', '2019-05-16', 6.1, 889000, 'A group of friends and their adventures in science and relationships.', 'https://www.youtube.com/watch?v=WBb3fojgW0Q', 5),
(12, 'The Handmaid''s Tale', '2017-04-26', NULL, 8.4, 266000, 'In a dystopian future, a woman is forced into sexual servitude to repopulate a world facing extinction.', 'https://www.youtube.com/watch?v=dVLiDETfx1c', 4),
(13, 'Westworld', '2016-10-02', NULL, 8.4, 542000, 'A futuristic amusement park is populated by androids, where guests can indulge their wildest fantasies.', 'https://www.youtube.com/watch?v=kEkZdgWu7mM', 5),
(14, 'Money Heist', '2017-05-02', NULL, 8.3, 550000, 'A criminal mastermind plans the biggest heist in recorded history, aiming to print billions of euros in the Royal Mint of Spain.', 'https://www.youtube.com/watch?v=_InqQJRqGW4', 4),
(15, 'The Queen''s Gambit', '2020-10-23', NULL, 8.6, 585000, 'Orphaned at a young age, a girl discovers her prodigious chess talent while struggling with addiction.', 'https://www.youtube.com/watch?v=oZn3qSgmLqI', 5),
(16, 'Loki', '2021-06-09', '2023-11-09', 8.2, 420000, 'The mercurial villain Loki resumes his role as the God of Mischief in a new series that takes place after the events of \“Avengers: Endgame.\”', 'https://www.youtube.com/watch?v=nW948Va-l10', 3),
(17, 'Attack On Titan', '2013-09-28', '2023-11-04', 9.1, 558000, 'After his hometown is destroyed, young Eren Jaeger vows to cleanse the earth of the giant humanoid Titans that have brought humanity to the brink of extinction.', 'https://www.youtube.com/watch?v=MGRm4IzK1SQ', 5),
(18, 'The Family Man', '2019-09-18', NULL, 8.7, 102000, 'A working man from the National Investigation Agency tries to protect the nation from terrorism, but he also needs to keep his family safe from his secret job.', 'https://www.youtube.com/watch?v=XatRGut65VI', 5),
(19, 'Squid Game', '2021-09-17', NULL, 8.0, 575000, 'Hundreds of cash-strapped players accept a strange invitation to compete in children''s games. Inside, a tempting prize awaits with deadly high stakes: a survival game that has a whopping 45.6 billion-won prize at stake.', 'https://www.youtube.com/watch?v=oqxAJKy0ii4', 4),
(20, 'Arcane', '2021-11-06', NULL, 9.0, 295000, 'Set in Utopian Piltover and the oppressed underground of Zaun, the story follows the origins of two iconic League of Legends champions and the power that will tear them apart.','https://www.youtube.com/watch?v=fXmAurh012s' , 3);

INSERT INTO Episodes (Show_ID, Episode_Number, Season_Number, Title, Duration, Release_Date, Num_Ratings_Ep, Episode_Rating, Description) VALUES
-- THERE ARE EPISODE 0's !!!!! Don't do trigger episode_number > 0 !!!!!
-- Show 1: Breaking Bad
(1,1,1,'Pilot', '00:58:00', '2008-01-20', 47000, 9.0, 'Diagnosed with terminal lung cancer, chemistry teacher Walter White teams up with former student Jesse Pinkman to cook and sell crystal meth.'),
(1,2,1,'Cat''s in the Bag...', '00:48:00', '2008-01-27', 34000, 8.6, 'After their first drug deal goes terribly wrong, Walt and Jesse are forced to deal with a corpse and a prisoner. Meanwhile, Skyler grows suspicious of Walt''s activities.'),
(1,3,1,'...And the Bag''s in the River', '00:48:00', '2008-02-10', 33000, 8.7, 'Walt and Jesse clean up after the bathtub incident before Walt decides what course of action to take with their prisoner Krazy-8.'),
(1,4,1,'Cancer Man', '00:48:00', '2008-02-17', 32000, 8.2, 'Walt tells the rest of his family about his cancer. Jesse tries to make amends with his own parents.'),
(1,5,1,'Crazy Handful of Nothin''', '00:48:00', '2008-03-02', 37000, 9.3, 'With the side effects and cost of his treatment mounting, Walt demands that Jesse finds a wholesaler to buy their drugs - which lands him in trouble.'),
(1,1,4,'Box Cutter', '00:47:00', '2011-07-17', 31000, 9.2, 'Walt and Jesse are held captive by Gus, after Gale''s death. Meanwhile, Skyler tries to find out what happened to Walt.'),
(1,11,4,'Crawl Space', '00:47:00', '2011-09-25', 44000, 9.7, 'Hank asks Walt to drive him to the laundry where the meth lab is hidden. Ted still won''t pay the IRS so Skyler asks Saul for help, and Saul sends in his A-Team. Gus and Jesse return from Mexico, and Walt fears he is in trouble with Gus.'),
(1,13,4,'Face Off', '00:50:00', '2011-10-09', 80000, 9.9, 'Jesse is brought to the FBI for questioning on his knowledge of ricin. In a last effort to kill Gus, Walt must ask for help from an old enemy.'),
(1,13,5, 'To''hajiilee', '00:46:00', '2013-09-08', 59000, 9.8, 'Jesse and Hank come up with an idea to take Walt down. Walt hires Todd''s uncle to kill Jesse.'),
(1,14,5, 'Ozymandias', '00:47:00', '2013-09-15', 231000, 10.0, 'Walt goes on the run. Jesse is taken hostage. Marie forces Skyler to tell Junior the truth.'),
(1,15,5, 'Granite State', '00:53:00', '2013-09-22', 58000, 9.7, 'Walt struggles as he adapts to aspects of his new identity. Jesse plans an escape against Jack and his crew.'),
(1,16,5, 'Felina', '00:55:00', '2013-09-29', 148000, 9.9, 'Walter White returns to Albuquerque one last time to secure his family''s future and settle old scores.'),

-- Show 2: Game Of Thrones
(2,1,1,'Winter Is Coming', '01:02:00', '2011-04-17', 59000, 8.9, 'Lord Eddard Stark is concerned by news of a deserter from the Night''s Watch; King Robert I Baratheon and the Lannisters arrive at Winterfell; the exiled Prince Viserys Targaryen forges a powerful new alliance.'),
(2,2,1,'The Kingsroad', '00:56:00', '2011-04-24', 44000, 8.6, 'While Bran recovers from his fall, Ned takes only his daughters to King''s Landing. Jon Snow goes with his uncle Benjen to the Wall. Tyrion joins them.'),
(2,3,1,'Lord Snow', '00:58:00', '2011-05-01', 42000, 8.5, 'Jon begins his training with the Night''s Watch; Ned confronts his past and future at King''s Landing; Daenerys finds herself at odds with Viserys.'),
(2,4,1,'Cripples, Bastards, and Broken Things', '00:56:00', '2011-05-08', 40000, 8.6, 'Eddard investigates Jon Arryn''s murder. Jon befriends Samwell Tarly, a coward who has come to join the Night''s Watch.'),
(2,3,8,'The Long Night', '01:22:00', '2019-04-28', 229000, 7.5, 'The Night King and his army have arrived at Winterfell and the great battle begins.'),
(2,4,8,'The Last of the Starks', '01:18:00', '2019-05-05', 174000, 5.5, 'The Battle of Winterfell is over and a new chapter for Westeros begins.'),
(2,5,8,'The Bells', '01:18:00', '2019-05-12', 204000, 5.9, 'Forces have arrived at King''s Landing for the final battle.'),
(2,6,8,'The Iron Throne', '01:20:00', '2019-05-19', 268000, 4.0, 'In the aftermath of the devastating attack on King''s Landing, Daenerys must face the survivors.'),

-- Show 3: Stranger Things
(3,1,1, 'Chapter One: The Vanishing of Will Byers', '01:18:00', '2016-07-15', 28000, 8.5, 'On his way home from a friend''s house, young Will sees something terrifying. Nearby, a sinister secret lurks in the depths of a government lab'),
(3,2,1, 'Chapter Two: The Weirdo on Maple Street', '01:18:00', '2016-07-15', 25000, 8.4, 'Lucas, Mike and Dustin try to talk to the girl they found in the woods. Meanwhile, Hopper questions an anxious Joyce about an unsettling phone call.'),
(3,3,1, 'Chapter Three: Holly, Jolly', '01:18:00', '2016-07-15', 25000, 8.8, 'An increasingly concerned Nancy looks for Barb and finds out what Jonathan''s been up to. Joyce is convinced Will is trying to talk to her.'),
(3,4,1, 'Chapter Four: The Body', '01:18:00', '2016-07-15', 24000, 8.9, 'Refusing to believe Will is dead, Joyce tries to connect with her son. The boys give Eleven a makeover. Jonathan and Nancy form an unlikely alliance.'),
(3,6,4, 'Chapter Six: The Dive', '01:18:00', '2022-05-27', 20000, 8.5, 'Behind the Iron Curtain, a risky rescue mission gets underway. The California crew seeks help from a hacker. Steve takes one for the team.'),
(3,7,4, 'Chapter Seven: The Massacre at Hawkins Lab', '01:18:00', '2022-05-27', 43000, 9.6, 'As Hopper braces to battle a monster, Dustin dissects Vecna''s motives -- and decodes a message from beyond. El finds strength in a distant memory.'),
(3,8,4, 'Chapter Eight: Papa', '01:18:00', '2022-07-01', 23000, 8.6, 'Nancy has sobering visions, and El passes an important test. Back in Hawkins, the gang gathers supplies and prepares for battle.'),
(3,9,4, 'Chapter Nine: The Piggyback', '01:18:00', '2022-07-01', 34000, 9.1, 'With selfless hearts and a clash of metal, heroes fight from every corner of the battlefield to save Hawkins - and the world itself.'),

-- Show 4: The Crown
(4, 1, 1, 'Wolferton Splash', '01:01:00', '2016-11-04', 7300, 8.2, 'A young Princess Elizabeth marries Prince Philip. As King George VI''s health worsens, Winston Churchill becomes Prime Minister for the second time.'),
(4, 2, 1, 'Hyde Park Corner', '00:45:00', '2016-11-04', 7400, 8.9, 'With King George too ill to travel, Elizabeth and Phillip embark on a four-continent Commonwealth tour. Party leaders attempt to undermine Churchill.'),
(4, 3, 1, 'Windsor', '00:59:00', '2016-11-04', 5800, 8.1, 'With Elizabeth in a new role, Phillip tries to assert some power. Churchill wants to delay the coronation. King George''s disgraced brother arrives.'),
(4, 1, 2, 'Act of War', '00:53:00', '2017-12-08', 8500, 8.4, 'Political challenges arise in the monarchy.'),
(4, 2, 2, 'Pride', '00:50:00', '2017-12-08', 7000, 8.3, 'The Queen faces a national crisis.'),
(4, 8, 6, 'Ritz', '00:50:00', '2023-12-14', 3100, 8.6, 'After a series of strokes, a declining Margaret recalls a wild night with her sister at the Ritz in 1945, and later celebrates her 70th birthday there.'),
(4, 9, 6, 'Hope Street', '00:52:00', '2023-12-14', 2100, 8.0, 'Reeling from loss and wary of her Golden Jubilee, the Queen bonds with William, who finds his footing between normality and life in the royal limelight.'),
(4, 10, 6, 'Sleep, Dearie Sleep', '01:12:00', '2023-12-14', 3600, 9.0, 'The Queen gives Charles the green light to wed Camilla. Tasked with planning her own funeral ahead of her 80th birthday, she faces an existential crisis.'),

-- Show 5:  The Mandalorian
(5, 1, 1, 'Chapter 1: The Mandalorian', '00:39:00', '2019-11-12', 35000, 8.7, 'A lone bounty hunter navigates the galaxy.'),
(5, 2, 1, 'Chapter 2: The Child', '00:42:00', '2019-11-17', 32000, 8.8, 'The Mandalorian discovers a mysterious child.'),
(5, 3, 1, 'Chapter 3: The Sin', '00:37:00', '2019-11-22', 32000, 8.9, 'The battered Mandalorian returns to his client for his reward.'),
(5, 4, 1, 'Chapter 4: Sanctuary', '00:41:00', '2019-11-29', 30000, 7.7, 'The Mandalorian teams up with an ex-soldier to protect a farming village from raiders.'),
(5, 1, 2, 'Chapter 9: The Marshal', '00:45:00', '2020-10-30', 6500, 8.6, 'A new ally is introduced in the fight.'),
(5, 2, 2, 'Chapter 10: The Passenger', '00:45:00', '2020-11-06', 6000, 8.5, 'A perilous journey unfolds.'),
(5, 7, 3, 'Chapter 23: The Spies', '00:51:00', '2023-04-12', 18000, 8.7, 'Survivors come out of hiding.'),
(5, 8, 3, 'Chapter 24: The Return', '00:39:00', '2023-04-19', 16000, 8.4, 'The Mandalorian and his allies confront their enemies.'),

-- Show 6: The Office US
(6, 1, 1, 'Pilot', '00:22:00', '2005-03-24', 15000, 7.3, 'A look into the lives of Dunder Mifflin employees.'),
(6, 2, 1, 'Diversity Day', '00:22:00', '2005-03-31', 12000, 8.1, 'A diversity training seminar goes awry.'),
(6, 3, 1, 'Health Care', '00:22:00', '2005-04-05', 8900, 7.6, 'Michael leaves Dwight in charge of picking the new healthcare plan for the staff, with disastrous results ahead.'),
(6, 4, 1, 'The Alliance', '00:22:00', '2005-04-12', 8600, 7.8, 'Just for a laugh, Jim agrees to an alliance with Dwight regarding the downsizing rumors.'),
(6, 1, 2, 'The Dundies', '00:22:00', '2006-05-15', 11000, 8.6, 'The annual Dundie Awards create chaos.'),
(6, 2, 2, 'The Office Olympics', '00:22:00', '2006-05-22', 10000, 8.1, 'The employees hold their own Olympics.'),
(6, 21, 9, 'Livin'' the Dream', '00:42:00', '2013-05-02', 6900, 9.0, 'Dwight becomes regional manager after Andy quits his job, Jim dedicates more time to his Dunder Mifflin job to save his marriage, and Angela has problems with her new living arrangements after her breakup with The Senator.'),
(6, 22, 9, 'A.A.R.M.', '00:43:00', '2013-05-09', 8900, 9.4, 'Dwight prepares for a marriage proposal and hires an assistant for his assistant, Andy auditions for a singing program, Darryl tries to leave his job without a fuss, and Pam has second thoughts about Jim staying in Scranton.'),
(6, 23, 9, 'Finale', '00:51:00', '2013-05-16', 23900, 9.8, 'One year later, Dunder Mifflin employees past and present reunite for a panel discussion about the documentary and to attend Dwight and Angela''s wedding.'),

-- Show 7: Friends
(7, 1, 1, 'The One Where Monica Gets a Roommate', '00:22:00', '1994-09-22', 11000, 8.9, 'Friends introduce each other to their new lives.'),
(7, 2, 1, 'The One with the Sonogram at the End', '00:22:00', '1994-09-29', 8000, 7.8, 'Monica and Ross deal with unexpected news.'),
(7, 3, 1, 'The One with the Thumb', '00:22:00', '1995-10-27', 7700, 8.0, 'Monica becomes irritated when everyone likes her new boyfriend more than she does.'),
(7, 4, 1, ' The One with George Stephanopoulos', '00:22:00', '1996-03-20', 7000, 7.9, 'Joey and Chandler take Ross to a hockey game to take his mind off the anniversary of the first time he slept with Carol, while the girls become depressed '),
(7, 1, 2, 'The One with the Prom Video', '00:22:00', '1995-10-27', 22000, 9.0, 'The friends reflect on their high school memories.'),
(7, 2, 2, 'The One with the Proposal', '00:22:00', '1996-03-20', 21000, 9.1, 'A memorable proposal leads to unexpected outcomes.'),
(7, 17, 10, 'The Last One: Part 1', '00:22:00', '2004-05-06', 17000, 9.6, 'Phoebe races Ross to the airport in a bid to stop Rachel from leaving for Paris. Monica and Chandler pack up their apartment ahead of their move to their new house, and Joey buys Chandler a new chick and duck as a leaving present.'),
(7, 18, 10, 'The Last One: Part 2', '00:22:00', '2004-05-06', 245, 9.5, 'The six friends prepare to say goodbye and embark on the next chapters of their lives; momentous events and last-minute surprises.'),

-- Show 8: The Simpsons
(8, 1, 1, 'Simpsons Roasting on an Open Fire', '00:22:00', '1989-12-17', 9000, 8.1, 'The family faces the challenges of Christmas.'),
(8, 2, 1, 'Bart the Genius', '00:22:00', '1990-01-14', 6000, 7.6, 'Bart takes a test that changes everything.'),
(8, 1, 2, 'Bart Gets an F', '00:22:00', '1990-10-11', 5300, 8.2, 'Mrs. Krabappel, fed up with Bart''s lackadaisical approach to his studies, gives him an ultimatum: shape up or repeat the fourth grade.'),
(8, 2, 2, 'Simpson and Delilah', '00:22:00', '1990-10-18', 5300, 8.4, 'Homer''s choices lead to moral dilemmas.'),
(8, 1, 36, 'Bart''s Birthday', '00:22:00', '2024-09-29', 649, 8.0, 'Bart celebrates a birthday that will change his life forever.'),
(8, 2, 36, 'The Yellow Lotus', '00:22:00', '2024-10-06', 338, 6.6, 'The Simpsons encounter death on vacation at a high-end resort.'),
(8, 3, 36, 'Desperately Seeking Lisa', '00:22:00', '2024-10-20', 281, 6.0, 'Lisa has a blazing misadventure in the dark world of Capital City''s downtown art scene'),
(8, 4, 36, 'Shoddy Heat', '00:22:00', '2024-10-27', 222, 6.3, 'An unearthed corpse opens up a cold case from Springfield in the 1980s as well as a steamy relationship between young Grampa and Agnes Skinner.'),

-- Show 9: Sherlock
(9, 0, 1, 'Unaired Pilot', '00:55:00', '2011-06-05', 13000, 8.7, 'Invalided home from the war in Afghanistan, Dr. John Watson becomes roommates with the world''s only \"consulting detective,\" Sherlock Holmes. Within a day their friendship is forged and several murders are solved.'),
(9, 1, 1, 'A Study in Pink', '01:28:00', '2010-10-24', 34000, 8.9, 'War vet Dr. John Watson returns to London in need of a place to stay. He meets Sherlock Holmes, a consulting detective, and the two soon find themselves digging into a string of serial \"suicides.\"'),
(9, 2, 1, 'The Blind Banker', '01:29:00', '2010-10-31', 30000, 7.9, 'Mysterious symbols and murders are showing up all over London, leading Sherlock and John to a secret Chinese crime syndicate called Black Lotus'),
(9, 3, 1, 'The Great Game', '01:29:00', '2010-11-07', 30000, 9.0, 'Mycroft needs Sherlock''s help, but a remorseless criminal mastermind puts Sherlock on a distracting crime-solving spree via a series of hostage human bombs through which he speaks.'),
(9, 1, 2, 'A Scandal in Belgravia', '01:29:00', '2012-05-06', 42000, 9.4, 'Sherlock must confiscate something of importance from a mysterious woman named Irene Adler.'),
(9, 2, 2, 'The Hounds of Baskerville', '01:28:00', '2012-05-13', 28000, 8.3, 'Sherlock and John investigate the ghosts of a young man who has been seeing monstrous hounds out in the woods where his father died.'),
(9, 3, 2, 'The Reichenbach Fall', '01:28:00', '2012-05-20', 41000, 9.6, 'Jim Moriarty hatches a mad scheme to turn the whole city against Sherlock.'),
(9, 0, 3, 'Many Happy Returns', '00:07:00', '2014-01-19', 13000, 8.4, 'John and Lestrade try to move on with their lives after Sherlock''s apparent death. However, Anderson believes he is still alive.'),
(9, 1, 3, 'The Empty Hearse', '01:28:00', '2014-01-19', 32000, 8.8, 'Mycroft calls Sherlock back to London to investigate an underground terrorist organization.'),
(9, 2, 3, 'The Sign of Three', '01:26:00', '2014-01-26', 29000, 8.9, 'Sherlock tries to give the perfect best man speech at John''s wedding when he suddenly realizes a murder is about to take place.'),
(9, 3, 3, 'His Last Vow', '01:29:00', '2014-02-02', 32000, 9.2, 'Sherlock goes up against Charles Augustus Magnussen, media tycoon and a notorious blackmailer.'),

-- Show 10: The Witcher
(10, 1, 1, 'The End''s Beginning', '00:46:00', '2019-12-20', 26000, 8.2, 'Hostile townsfolk and a cunning mage greet Geralt in the town of Blaviken. Ciri finds her royal world upended when Nilfgaard sets its sights on Cintra.'),
(10, 2, 1, 'Four Marks', '00:39:00', '2019-12-20', 22000, 7.7, 'Bullied and neglected, Yennefer accidentally finds a means of escape. Geralt''s hunt for a so-called devil goes to hell. Ciri seeks safety in numbers.'),
(10, 3, 1, 'Betrayer Moon', '00:51:00', '2019-12-20', 22000, 8.5, 'Geralt takes on another Witcher''s unfinished business in a kingdom stalked by a ferocious beast. At a brutal cost, Yennefer forges a magical new future.'),
(10, 4, 1, 'Betrayer Moon', '00:44:00', '2019-12-20', 20000, 8.4, 'Against his better judgment, Geralt accompanies Jaskier to a royal ball. Ciri wanders into an enchanted forest. Yennefer tries to protect her charges.'),
(10, 1, 2, 'Episode 6', '00:44:00', '2019-01-05', 7000, 8.4, 'Consequences of their choices become evident.'),
(10, 2, 2, 'Episode 8', '00:47:00', '2019-01-05', 6000, 8.5, 'A final confrontation changes everything.'),
(10, 6, 3, 'Everybody Has a Plan ''til They Get Punched in the Face', '00:49:00', '2023-07-27', 6900, 6.5, 'Betrayal and bloodshed rock the conclave when the hunt for Ciri comes to a head. As sides are chosen and enemies unmasked, nothing will ever be the same.'),
(10, 7, 3, 'Out of the Fire, Into the Frying Pan', '00:50:00', '2023-07-27', 8200, 4.3, 'Haunted by faces from the past, Ciri endures the ultimate test of survival on a desperate journey under the harshest of conditions.'),
(10, 8, 3, 'The Cost of Chaos', '00:50:00', '2023-07-27', 6900, 5.3, 'After the fateful events at Aretuza , Geralt and Yennefer struggle to pick up the pieces and reunite their family as war comes to the Continent.'),

-- Show 11: The Big Bang Theory
(11, 1, 1, 'Pilot', '00:40:00', '2007-09-24', 7500, 8.1, 'The story of nerds and their interactions with women.'),
(11, 2, 1, 'The Big Bran Hypothesis', '00:22:00', '2007-10-01', 6000, 8.3, 'The group helps Sheldon with his issues.'),
(11, 1, 2, 'The Bad Fish Paradigm', '00:22:00', '2008-09-22', 4900, 8.2, 'Romantic entanglements create complications.'),
(11, 2, 2, 'The Codpiece Topology', '00:22:00', '2008-09-27', 4500, 8.0, 'Sheldon is annoyed when Leonard turns to Leslie for comfort after seeing Penny with another guy.'),
(11, 22, 12, 'The Maternal Conclusion', '00:22:00', '2019-05-09', 3000, 7.9, 'Leonard is pleasantly surprised when Beverly comes to visit and she''s genuinely kind to him, until he finds out the real reason she''s there.'),
(11, 23, 12, 'The Change Constant', '00:22:00', '2019-05-16', 5200, 9.0, 'Sheldon and Amy await big news.'),
(11, 24, 12, 'The Stockholm Syndrome', '00:22:00', '2019-05-16', 11200, 9.5, 'Bernadette and Wolowitz leave their kids for the first time; Penny and Leonard try to keep a secret; Sheldon and Amy stick together; and Koothrappali makes a new friend, as the gang travels together into an uncharted future.'),

-- Show 12: The Handmaid's Tale
(12, 1, 1, 'Offred', '00:47:00', '2017-04-26', 7100, 8.2, 'In a dystopian world, a handmaid reflects on her life.'),
(12, 2, 1, 'Birth Day', '00:45:00', '2017-04-26', 5800, 8.1, 'The struggles of a handmaid become apparent.'),
(12, 1, 2, 'June', '00:50:00', '2018-04-25', 5200, 8.8, 'June reckons with the consequences of a dangerous decision while haunted by memories from her past and the violent beginnings of Gilead.'),
(12, 2, 2, 'Unwomen', '00:50:00', '2018-04-25', 4600, 8.2, 'June adjusts to a new way of life, while in hiding in Boston. Emily reflects on her past as a new arrival disrupts life at the Colonies.'),
(12, 8, 5, 'Motherland', '00:53:00', '2022-10-26', 1700, 8.0, 'June receives a tempting offer from a surprise visitor. Serena hits rock bottom and searches for allies.'),
(12, 9, 5, 'Allegiance', '00:51:00', '2022-11-02', 1600, 7.6, 'June and Luke prepare for a rescue mission. Serena tries new tactics with her oppressive hosts. Lawrence makes a surprising proposal to elevate his status.'),
(12, 10, 5, 'Allegiance', '00:57:00', '2022-11-09', 2200, 8.4, 'Under threat, June must find a way to keep herself and her family safe from Gilead and its violent supporters in Toronto.'),

-- Show 13: Westworld
(13, 1, 1, 'The Original', '00:50:00', '2016-10-02', 24000, 8.8, 'The park staff begin to notice strange behavior from the hosts; A mysterious Man in Black roams the park, wreaking havoc.'),
(13, 2, 1, 'Chestnut', '00:51:00', '2016-10-09', 18000, 8.5, 'Guests explore their fantasies.'),
(13, 3, 1, 'The Stray', '00:41:00', '2016-10-16', 17000, 8.2, 'Elsie and Stubbs search for a missing host; Teddy gets a new backstory; Bernard investigates the origins of madness and hallucinations within the hosts.'),
(13, 1, 2, 'Journey into Night', '00:56:00', '2018-04-22', 14000, 8.1, 'The hosts revolt against the guests while searching for a new purpose; Maeve sets out to find her daughter with some unexpected help'),
(13, 2, 2, 'Reunion', '00:58:00', '2018-04-29', 12000, 8.0, 'Dolores remembers she''s been to the outside world; William makes a bold business venture.'),
(13, 4, 2, 'The Riddle of the Sphinx', '00:59:00', '2018-05-13', 14000, 8.9, 'An enigmatic figure becomes the center of Delos'' secret project; The Man in Black and Lawrence follow the path to Las Mudas, but run into trouble.'),

-- Show 14: Money Heist
(14, 1, 1, 'Efectuar lo acordado', '00:44:00', '2017-05-02', 9900, 8.1, 'The Professor recruits a young female robber and seven other criminals for a grand heist, targeting the Royal Mint of Spain.'),
(14, 2, 1, 'Imprudencias letales', '00:43:00', '2017-05-09', 8500, 8.2, 'Hostage negotiator Raquel makes initial contact with the Professor. One of the hostages is a crucial part of the thieves'' plans.'),
(14, 3, 1, 'Errar al disparar', '00:47:00', '2017-05-16', 7900, 8.1, 'Police grab an image of the face of one of the robbers. Raquel is suspicious of the gentleman she meets at a bar.'),
(14, 1, 2, 'Se acabaron las máscaras', '00:42:00', '2017-10-16', 6700, 8.4, 'The police finds the house where The Professor has planned everything. Tokyo and Berlin are fighting about how to proceed.'),
(14, 2, 2, 'La cabeza del plan', '00:45:00', '2017-10-23', 6500, 8.3, 'Tokyo is questioned by the police. The Professor and Raquel''s ex-husband are getting into a fight.'),
(14, 8, 5, 'La teoría de la elegancia', '00:49:00', '2021-12-03', 4700, 7.9, 'Tamayo hunts for the gold as the team races against the clock. Mónica worries she''s having a psychotic break. Years earlier, Berlin is deceived.'),
(14, 9, 5, 'Lo que se habla en la cama', '00:52:00', '2021-12-03', 4700, 8.9, 'The Professor is left reeling after his tactics are used against him, and when it seems like all hope is lost, he makes a bold decision.'),
(14, 10, 5, 'Una tradición familiar', '00:55:00', '2021-12-03', 8100, 8.5, 'With multiple lives on the line and Spain''s economy at stake, the Professor and Tamayo engage in one final showdown.'),

-- Show 15: The Queen's Gambit
(15, 1, 1, 'Openings', '00:46:00', '2020-10-23', 13000, 8.7, 'Sent to an orphanage at age 9, Beth develops an uncanny knack for chess and a growing dependence on the green tranquilizers given to the children.'),
(15, 2, 1, 'Exchanges', '00:48:00', '2020-10-23', 12500, 8.6, 'Suddenly plunged into a confusing new life in suburbia, teenage Beth studies her high school classmates and hatches a plan to enter a chess tournament.'),
(15, 3, 1, 'Doubled Pawns', '00:51:00', '2020-10-23', 11000, 8.8, 'The trip to Cincinnati launches Beth and her mother into a whirlwind of travel and press coverage. Beth sets her sights on the U.S. open in Las Vegas.'),
(15, 4, 1, 'Middle Game', '00:50:00', '2020-10-23', 10500, 8.4, 'Russian class opens the door to a new social scene. In Mexico City, Beth meets the intimidating Borgov, while her mother cozies up with a pen pal.'),
(15, 5, 1, 'Fork', '00:46:00', '2020-10-23', 10500, 8.2, 'Back home in Kentucky, a shaken Beth reconnects with a former opponent who offers to help sharpen her game ahead of the U.S. Championship.'),
(15, 6, 1, 'Adjournment', '00:47:00', '2020-10-23', 11500, 8.4, 'After training with Benny in New York, Beth heads to Paris for her rematch with Borgov. But a wild night sends her into a self-destructive spiral.'),
(15, 7, 1, 'End Game', '00:47:00', '2020-10-23', 14500, 9.2, 'A visit from an old friend forces Beth to reckon with her past and rethink her priorities, just in time for the biggest match of her life.'),

-- Show 16: Loki
(16, 1, 1, 'Glorious Purpose', '00:51:00', '2021-06-09', 35000, 8.6, 'Loki, the God of Mischief, finds himself out of time and in an unusual place and forced - against his godly disposition - to cooperate with others.'),
(16, 2, 1, 'The Variant', '00:53:00', '2021-06-16', 31000, 8.7, 'Mobius puts Loki to work, but not everyone at TVA is thrilled about the God of Mischief''s presence.'),
(16, 3, 1, 'Lamentis', '00:42:00', '2021-06-23', 30000, 7.7, 'Loki finds out The Variant''s plan, but he has his own that will forever alter both their destinies.'),
(16, 4, 1, 'The Nexus Event', '00:48:00', '2021-06-30', 31000, 9.0, 'Frayed nerves and paranoia infiltrate the TVA as Mobius and Hunter B-15 search for Loki and Sylvie.'),
(16, 3, 2, '1893', '00:54:00', '2023-10-19', 13000, 7.7, 'Loki and Mobius go on the hunt for everyone''s favorite cartoon clock as they try to save the TVA.'),
(16, 4, 2, 'Heart of the TVA', '00:50:00', '2023-10-26', 15000, 8.6, 'The TVA''s Loom nears catastrophic failure, but Loki, Mobius and Sylvie have a He Who Remains variant.'),
(16, 5, 2, 'Science/Fiction', '00:45:00', '2023-11-02', 15000, 8.7, 'Loki traverses dying timelines in an attempt to find his friends, but Reality is not what it seems.'),
(16, 6, 2, 'Glorious Purpose', '00:56:00', '2023-11-09', 27000, 9.4, 'ki learns the true nature of ''glorious purpose'' as he rectifies the past.'),

-- Show 17: Attack On Titan
(17, 1, 1, 'To You, in 2000 Years: The Fall of Shiganshina, Part 1', '00:26:00', '2013-09-28', 36000, 9.1, 'After 100 years of peace, humanity is suddenly reminded of the terror of being at the Titans'' mercy.'),
(17, 2, 1, 'That Day: The Fall of Shiganshina, Part 2', '00:24:00', '2014-05-10', 27000, 8.5, 'After the Titans break through the wall, the citizens of Shiganshina must run for their lives. Those that do make it to safety find a harsh life waiting for them, however.'),
(17, 25, 1, 'Wall: Raid on Stohess District, Part 3', '00:24:00', '2013-09-29', 27000, 9.4, 'Eren goes head-to-head with the Female Titan in a fight that demolishes Stohess District inside Wall Sina. As the number of casualties multiplies and Annie tries to escape over the wall, Erwin must deal with the consequences of his plan.'),
(17, 6, 2, 'Warrior', '00:25:00', '2017-05-06', 52000, 9.7, 'The Scouts rest atop the wall, and in their departure, two of their own reveal an Earth-shattering secret to Eren'),
(17, 7, 2, 'Close Combat', '00:26:00', '2017-05-13', 27000, 9.6, 'With a new enemy revealed, Eren and the Scouts fight back using all the techniques at their disposal. However, the Armored and Colossal Titan have other plans in mind.'),
(17, 12, 2, 'Scream', '00:26:00', '2017-06-17', 39000, 9.7, 'Eren''s confrontation with a smiling Titan raises questions about his powers, but any answers will come at a cost.'),
(17, 9, 3, 'Ruler of the Walls', '00:26:00', '2018-09-17', 23000, 9.3, 'Desperate to stop the approaching monstrosity, the Scouts resort to unconventional tactics before it destroys everything in its path'),
(17, 11, 3, 'Bystander', '00:26:00', '2018-10-08', 23000, 9.1, 'Having seen a glimpse of his father''s memories, Eren attempts to track down a man hoping they might shed some light on his father''s secrets.'),
(17, 16, 3, 'Perfect Game', '00:25:00', '2019-05-20', 86000, 9.8, 'While one front is rained on by flames, the other is battered by boulders. With no way out and limited options, the Scouts are forced to fight against the Titans with little hope left'),
(17, 17, 3, 'Hero', '00:26:00', '2019-05-27', 138000, 9.7, 'As Erwin''s heroic charge buys Levi time to confront the Beast Titan, Armin comes up with a plan of his own that lays it all on the line.'),
(17, 20, 4, 'Memories of the Future', '00:25:00', '2022-01-30', 80000, 9.7, 'Zeke takes Eren through Grisha''s memories to show him how he''s been brainwashed. But in doing so, Zeke discovers something about Eren that he never knew.'),
(17, 21, 4, 'From You, 2000 Years Ago', '00:25:00', '2022-02-06', 79000, 9.7, 'Eren and Zeke with their contradicted ethics and shattered emotions, clash on the credibility of their ideals while Ymir, the founder, discloses her tragic past and deepest secrets within the walls.'),
(17, 28, 4, 'The Dawn of Humanity', '00:27:00', '2022-04-03', 38000, 9.6, 'Regardless of where it all began, Eren commits to his path of destruction during the Scouts'' first visit to the Marleyan mainland, leaving Mikasa to wonder if things could''ve been different'),

-- Show 18: The Family Man
(18, 1, 1, 'The Family Man', '00:53:00', '2019-09-19', 2200, 8.2, 'Middle-class man working for the National Investigation Agency. While he tries to protect the nation from terrorists, he also has to protect his family from the impact of his secretive, high-pressure, and low paying job.'),
(18, 2, 1, 'Sleepers', '00:47:00', '2019-09-20', 1500, 8.2, 'A scooter bomb goes off at Kala Ghoda. Srikant learns about a mission called Zulfiqar. Suspects in the blast case tell him about a drop box near Victoria College.'),
(18, 3, 1, 'Anti-National', '00:46:00', '2019-09-20', 1400, 8.2, 'When he finds out that one of the hospitalised prisoners is part of Mission Zulfiqar, Srikant interrogates the prisoner''s friend, Moosa, about it.'),
(18, 6, 2, 'Martyrs', '00:40:00', '2021-06-04', 4200, 9.2, 'Srikant and team manage to nab Raji. But they find out the hard way that they are way in over their heads. TASC suffers a tragic loss.'),
(18, 7, 2, 'Collateral Damage', '00:35:00', '2021-06-04', 4200, 8.9, 'Raji is injured days before the D-Day and needs treatment. Simmering tensions between Suchitra and Dhriti hit a crescendo.'),
(18, 8, 2, 'Vendetta', '00:42:00', '2021-06-04', 4400, 9.3, 'The hunt is on for Dhriti. Meanwhile, JK and Muthu decide to check out Tigris Aviation, and walk into a trap.'),
(18, 9, 2, 'The Final Act', '01:00:00', '2021-06-04', 4700, 9.2, 'News about JK forces Srikant to rush back to Chennai. Raji hears about Sajid''s fate. Dhriti finds out the true nature of Srikant''s job.'),

-- Show 19: Squid Game
(19, 1, 1, 'Mugunghwa kkoch-i pideon nal', '00:59:00', '2021-09-17', 17000, 8.2, 'Hoping to win easy money, a broke and desperate Gi-hun agrees to take part in an enigmatic game. Not long into the first round, unforeseen horrors unfold.'),
(19, 2, 1, 'Ji-ok', '01:02:00', '2021-09-17', 14000, 7.5, 'Split on whether to continue or quit, the group holds a vote. But their realities in the outside world may prove to be just as unforgiving as the game.'),
(19, 3, 1, 'Usan-eul sseun namja', '00:54:00', '2021-09-17', 14000, 8.0, 'A few players enter the next round - which promises equal doses of sweet and deadly - with hidden advantages. Meanwhile, Jun-ho sneaks his way inside.'),
(19, 4, 1, 'Jjollyeodo pyeonmeokgi', '00:54:00', '2021-09-17', 14000, 8.0, 'As alliances form among the players, no one is safe in the dorm after lights-out. The third game challenges Gi-hun''s team to think strategically.'),
(19, 5, 1, 'Pyeongdeung-han sesang', '00:51:00', '2021-09-17', 13000, 7.6, 'Gi-hun and his team take turns keeping guard through the night. The masked men encounter trouble with their co-conspirators.'),
(19, 6, 1, 'Kkanbu', '01:01:00', '2021-09-17', 23000, 9.2, 'Players pair off for the fourth game. Gi-hun grapples with a moral dilemma, Sang-woo chooses self-preservation and Sae-byeok shares her untold story.'),
(19, 7, 1, 'VIPS', '00:50:00', '2021-09-17', 13000, 7.9, 'The Masked Leader welcomes VIP guests to the facility for a front-row viewing of the show. In the fifth game, some players crack under pressure.'),
(19, 8, 1, 'Peulonteu maen', '00:32:00', '2021-09-17', 13000, 7.8, 'Ahead of the last round, distrust and disgust run deep among the finalists. Jun-ho makes a getaway, determined to expose the game''s dirty secrets.'),
(19, 9, 1, 'Unsu joeun nal', '00:55:00', '2021-09-17', 15000, 7.5, 'The final round presents another cruel test but this time, how it ends depends on just one player. The game''s creator steps out of the shadows.'),

-- Show 20: Arcane
(20, 1, 1, 'Welcome to the Playground', '00:43:00', '2021-11-06', 18000, 8.5, 'Orphaned sisters Vi and Powder bring trouble to Zaun''s underground streets in the wake of a heist in posh Piltover.'),
(20, 2, 1, 'Some Mysteries Are Better Left Unsolved', '00:41:00', '2021-11-06', 16000, 8.5, 'Idealistic inventor Jayce attempts to harness magic through science --- despite his mentor''s warning. Criminal kingpin Silco tests a powerful substance.'),
(20, 3, 1, 'The Base Violence Necessary for Change', '00:44:00', '2021-11-06', 23000, 9.6, 'An epic showdown between old rivals results in a fateful moment for Zaun. Jayce and Viktor risk it all for their research.'),
(20, 4, 1, 'Happy Progress Day!', '00:40:00', '2021-11-13', 15000, 8.7, 'With Piltover prospering from their tech, Jayce and Viktor weigh their next move. A familiar face re-emerges from Zaun to wreak havoc.'),
(20, 5, 1, 'Everybody Wants to Be My Enemy', '00:40:00', '2021-11-13', 14000, 8.0, 'Rogue enforcer Caitlyn tours the undercity alongside Vi to track down Silco. Jayce puts a target on his back trying to root out Piltover corruption.'),
(20, 6, 1, 'When These Walls Come Tumbling Down', '00:42:00', '2021-11-13', 15000, 9.2, 'An eager protege undermines his mentor on the council as a magical tech rapidly evolves. With authorities in pursuit, Jinx must face her past.'),
(20, 7, 1, 'The Boy Savior', '00:40:00', '2021-11-20', 15000, 9.2, 'Caitlyn and Vi meet an ally in Zaun''s streets and head into a frenzied battle with a common foe. Viktor makes a dire decision.'),
(20, 8, 1, 'Oil and Water', '00:40:00', '2021-11-20', 14000, 9.2, 'Disowned heir Mel and her visiting mother trade combat tactics. Caitlyn and Vi forge an unlikely alliance. Jinx undergoes a startling change.'),
(20, 9, 1, 'The Monster You Created', '00:39:00', '2021-11-20', 20000, 9.6, 'Perilously close to war, the leaders of Piltover and Zaun reach an ultimatum. But a fateful standoff changes both cities forever.');

INSERT INTO Genres (Genre_ID, Genre_Name) VALUES
(1, 'Action'),
(2, 'Adventure'),
(3, 'Comedy'),
(4, 'Drama'),
(5, 'Fantasy'),
(6, 'Horror'),
(7, 'Mystery'),
(8, 'Romance'),
(9, 'Sci-Fi'),
(10, 'Thriller'),
(11, 'Documentary'),
(12, 'Animation');

INSERT INTO Awards (Award_ID, Award_Name, Award_Category) VALUES
(1, 'Academy Awards', 'Best Picture'),
(2, 'Academy Awards', 'Best Director'),
(3, 'Academy Awards', 'Best Actor'),
(4, 'Academy Awards', 'Best Actress'),
(5, 'Academy Awards', 'Best Supporting Actor'),
(6, 'Academy Awards', 'Best Supporting Actress'),
(7, 'Emmy Awards', 'Lead Actor in a Drama Series'),
(8, 'Emmy Awards', 'Lead Actress in a Drama Series'),
(9, 'Emmy Awards', 'Outstanding Drama Series'),
(10, 'Emmy Awards', 'Outstanding Comedy Series'),
(11, 'Emmy Awards', 'Lead Actor in a Comedy Series'),
(12, 'Emmy Awards', 'Lead Actress in a Comedy Series'),
(13, 'Academy Awards', 'Best Direction'),
(14, 'Academy Awards', 'Best Animated Feature');


INSERT INTO People (Person_ID, Person_First_Name, Person_Last_Name, Person_DOB, Person_Gender, Person_Nationality) VALUES
(1, 'Leonardo', 'DiCaprio', '1974-11-11', 'Male', 'American'), 		-- m1A,m5A
(2, 'Joseph', 'Gordon-Levitt', '1981-02-17', 'Male', 'American'), 	-- m1A
(3, 'Elliot', 'Page', '1987-02-21', 'Other', 'American'), 			-- m1A
(4, 'Ken', 'Watanabe', '1959-10-21', 'Male', 'Japanese'), 			-- m1A
(5, 'Christian', 'Bale', '1974-01-30', 'Male', 'Welsh'), 			-- m2A
(6, 'Heath', 'Ledger', '1979-04-04', 'Male', 'Australian'), 		-- m2A
(7, 'Aaron', 'Eckhart', '1968-03-12', 'Male', 'American'),			-- m2A
(8, 'Michael', 'Caine', '1933-03-14', 'Male', 'English'),			-- m2A
(9, 'Maggie', 'Gyllenhaal', '1977-11-16', 'Female', 'American'),	-- m2A
(10, 'Gary', 'Oldman', '1958-03-21', 'Male', 'English'),			-- m2A
(11, 'Morgan', 'Freeman', '1937-06-01', 'Male', 'American'),		-- m2A,m6A
(12, 'Keanu', 'Reeves', '1964-09-02', 'Male', 'Canadian'),			-- m3A, m26A
(13, 'Laurence', 'Fishburne', '1961-07-30', 'Male', 'American'),	-- m3A, m26A
(14, 'Carrie-Anne', 'Moss', '1967-08-21', 'Female', 'Canadian'),	-- m3A, m26A
(15, 'Gloria', 'Foster', '1933-11-15', 'Female', 'American'),		-- m3A
(16, 'Sam', 'Worthington', '1976-08-02', 'Male', 'English'),		-- m4A, m27A
(17, 'Zoe', 'Saldana', '1978-06-19', 'Female', 'American'),			-- m4A, m27A
(18, 'Sigourney', 'Weaver', '1949-10-08', 'Female', 'American'),	-- m4A, m27A
(19, 'Michelle', 'Rodriguez', '1978-07-12', 'Female', 'American'),	-- m4A
(20, 'Stephen', 'Lang', '1952-07-11', 'Male', 'American'),			-- m4A
(21, 'Christopher', 'Nolan', '1970-07-30', 'Male', 'English'), 		-- m1D,m2D,m1P
(22, 'Emma', 'Thomas', '1971-12-09', 'Female', 'English'), 			-- m1P,m2P
(23, 'Lilly', 'Wachowski', '1967-12-29', 'Female', 'American'), 	-- m3P,m3D, m26D, m26P
(24, 'Lana', 'Wachowski', '1965-06-21', 'Female', 'American'), 		-- m3P,m3D, m26D, m26P
(25, 'James', 'Cameron', '1954-08-16', 'Male', 'Canadian'), 		-- m4P,m4D,m5D,m5P, m27D, m27P
(26, 'John', 'Landau', '1960-07-23', 'Male', 'American'), 			-- m4P,m5P,m27P
(27, 'Kate', 'Winslet', '1975-10-05', 'Female', 'English'), 		-- m5A
(28, 'Billy', 'Zane', '1966-02-24', 'Male', 'American'), 			-- m5A
(29, 'Tim', 'Robbins', '1958-10-16', 'Male', 'American'), 			-- m6A
(30, 'Bob', 'Gunton', '1945-11-15', 'Male', 'American'), 			-- m6A
(31, 'Frank', 'Darabont', '1959-01-28', 'Male', 'French'), 			-- m6D,m6P
(32, 'Marlin', 'Brando', '1924-04-03', 'Male', 'American'), 		-- m7A
(33, 'Al', 'Pacino', '1940-04-25', 'Male', 'American'), 			-- m7A,m13A, m29A
(34, 'James', 'Caan', '1940-03-26', 'Male', 'American'), 			-- m7A
(35, 'David', 'Lester', '1940-03-26', 'Male', 'American'), 			-- m6P
(36, 'Francis', 'Ford Coppola', '1939-04-07', 'Male', 'American'), 	-- m7D,m7P,m13D,m13P, m29D, m29P
(37, 'Mark', 'Hamill', '1951-09-25', 'Male', 'American'), 			-- m8A, m15A
(38, 'Harrison', 'Ford', '1942-07-13', 'Male', 'American'), 		-- m8A, m15A
(39, 'Carrie', 'Fisher', '1956-10-21', 'Female', 'American'), 		-- m8A, m15A
(40, 'George', 'Lucas', '1944-05-14', 'Male', 'American'), 			-- m8D,m8P, m15D, m15P
(41, 'Sam', 'Neill', '1947-09-14', 'Male', 'Irish'), 				-- m9A, m20A
(42, 'Laura', 'Dern', '1967-02-10', 'Female', 'American'), 			-- m9A
(43, 'Jeff', 'Goldblum', '1952-10-22', 'Male', 'American'), 		-- m9A, m20A
(44, 'Steven', 'Spielberg', '1946-12-18', 'Male', 'American'), 		-- m9D,m9P
(45, 'Kathleen', 'Kennedy', '1953-06-05', 'Female', 'American'), 	-- m9P
(46, 'Matthew', 'Broderick', '1962-03-21', 'Male', 'Irish'), 		-- m10A
(47, 'James', 'Earl Jones', '1931-01-17', 'Male', 'American'), 		-- m10A
(48, 'Roger', 'Allers', '1949-06-29', 'Male', 'American'), 			-- m10D,m10P, m24D
(49, 'Albert', 'Brooks', '1947-07-22', 'Male', 'American'), 		-- m11A, m14A
(50, 'Ellen', 'DeGeneres', '1958-01-26', 'Female', 'American'), 	-- m11A,m14A
(51, 'Alexander', 'Gould', '1994-05-04', 'Male', 'American'), 		-- m11A
(52, 'Andrew', 'Stanton', '1965-12-03', 'Male', 'American'), 		-- m11D, m11P, m14D, m14P, m24P
(53, 'Tom', 'Hanks', '1956-07-09', 'Male', 'American'), 			-- m12A, m30A
(54, 'Tim', 'Allen', '1953-06-13', 'Male', 'American'), 			-- m12A, m30A
(55, 'John', 'Lasseter', '1957-01-12', 'Male', 'American'), 		-- m12D,m12P, m28P, m30D, m30P
(56, 'Steve', 'Jobs', '1955-02-24', 'Male', 'American'), 			-- m12P
(57, 'Robert', 'De Niro', '1943-08-17', 'Male', 'American'), 		-- m13A
(58, 'Robert', 'Duvall', '1931-01-05', 'Male', 'American'), 		-- m13A
(59, 'George', 'Miller', '1945-03-03', 'Male', 'Australian'), 		-- m16D,m16P,m19D,m19P,s12D,s12P
(60, 'Tom', 'Hardy', '1977-09-15', 'Male', 'English'), 				-- m16A, m20A
(61, 'Charlize', 'Theron', '1975-08-07', 'Female', 'African'), 		-- m16A
(62, 'Kristen', 'Bell', '1980-07-18', 'Female', 'American'), 		-- m17A
(63, 'Josh', 'Gad', '1980-07-18', 'Male', 'American'), 				-- m17A
(64, 'Idina', 'Menzel', '1971-05-30', 'Female', 'American'), 		-- m17A,m19A
(65, 'Jennifer', 'Lee', '1971-10-22', 'Female', 'American'), 		-- m17D, m17P, m18D, m18P, m20P
(66, 'Dwayne', 'Johnson', '1972-05-02', 'Male', 'American'), 		-- m18A,m19A
(67, 'Karen', 'Gillan', '1987-11-28', 'Female', 'Scottish'), 		-- m18A
(68, 'Ryan', 'Reynolds', '1976-10-23', 'Male', 'Canadian'), 		-- m19A
(69, 'Chris', 'Pratt', '1979-06-21', 'Male', 'American'), 			-- m20A
(70, 'James', 'Gunn', '1966-08-05', 'Male', 'American'), 			-- m20D,m20P, m21P, m21D, m22D, m22P, m25D, m25P, s16D, s16P
(71, 'Tom', 'Holland', '1996-06-01', 'Male', 'English'), 			-- m21A
(72, 'Zendaya', 'Coleman', '1996-09-01', 'Male', 'American'), 		-- m21A
(73, 'Benedict', 'Cumberbatch', '1976-07-19', 'Male', 'English'), 	-- m21A, s9A
(74, 'Chadwick', 'Boseman', '1976-11-29', 'Male', 'American'), 		-- m22A
(75, 'Michael', 'B. Jordan', '1987-02-09', 'Male', 'American'), 	-- m22A
(76, 'Song', 'Kang-ho', '1967-01-17', 'Male', 'South Korean'), 		-- m23A
(77, 'Lee', 'Sun-kyun', '1975-03-02', 'Male', 'South Korean'), 		-- m23A
(78, 'Cho', 'Yeo-jeong', '1981-02-10', 'Female', 'South Korean'), 	-- m23A
(79, 'Bong', 'Joon Ho', '1969-09-14', 'Male', 'South Korean'), 		-- m23D, m23P
(80, 'Jodie', 'Foster', '1962-11-19', 'Female', 'American'), 		-- m24A
(81, 'Anthony', 'Hopkins', '1937-12-31', 'Male', 'Welsh'), 			-- m24A
(82, 'Robert', 'Downey Jr.', '1965-04-04', 'Male', 'American'), 	-- m25A
(83, 'Chris', 'Evans', '1981-06-13', 'Male', 'American'), 			-- m25A
(84, 'Scarlett', 'Johansson', '1984-11-22', 'Female', 'American'), 	-- m25A
(85, 'M. Night', 'Shyamalan', '1970-08-06', 'Male', 'Indian'), 		-- m28D, m28P
(86, 'Noah', 'Ringer', '1996-11-18', 'Male', 'American'), 			-- m28A
(87, 'Nicola', 'Peltz Beckham', '1995-01-09', 'Female', 'American'), -- m28A
(88, 'Diane', 'Keaton', '1946-01-05', 'Female', 'American'), 		-- m29A
(89, 'Alejandro', 'Amenábar', '1972-03-31', 'Male', 'Spanish'), 	-- m31D, m31P
(90, 'Javier', 'Bardem', '1969-03-01', 'Male', 'Spanish'), 			-- m31A
(91, 'Guillermo', 'del Toro', '1964-10-09', 'Male', 'Spanish'), 	-- m32D,m32P
(92, 'Ivana', 'Baquero', '1994-06-11', 'Female', 'Spanish'), 		-- m32A
(93, 'Olivier', 'Nakache', '1973-04-15', 'Male', 'French'), 		-- m33D,m33P
(94, 'François', 'Cluzet', '1955-09-21', 'Male', 'French'), 		-- m33A
(95, 'Omar', 'Sy', '1979-01-20', 'Male', 'French'), 				-- m33A
(96, 'Justine', 'Triet', '1978-07-17', 'Female', 'French'), 		-- m34D, m34P
(97, 'Sandra', 'Hüller', '1978-04-30', 'Female', 'French'), 		-- m34A, m35A
(98, 'Christian', 'Friedel', '1979-03-09', 'Male', 'German'), 		-- m35A
(99, 'Jonathan', 'Glazer', '1965-03-26', 'Male', 'English'), 		-- m35D, m35P
(100, 'Edward', 'Berger', '1970-01-01', 'Male', 'German'), 			-- m36D, m36P
(101, 'Felix', 'Kammerer', '1995-09-19', 'Male', 'Austrian'), 		-- m36A
(102, 'Albrecht', 'Schuch', '1985-08-21', 'Male', 'German'), 		-- m36A
(103, 'Ang', 'Lee', '1954-10-23', 'Male', 'Chinese'), 				-- m38D,m38P, m37D, m37P
(104, 'Tony', 'Leung Chiu-wai', '1962-06-27', 'Male', 'Chinese'), 	-- m38A
(105, 'Tang', 'Wei', '1979-10-07', 'Female', 'Chinese'), 			-- m38A
(106, 'Chow', 'Yun-Fat', '1955-05-18', 'Male', 'Chinese'), 			-- m37A
(107, 'Michelle', 'Yeoh', '1962-08-06', 'Female', 'Malaysian'), 	-- m37A
(108, 'Hayao', 'Miyazaki', '1941-01-05', 'Male', 'Japanese'), 		-- m39D,m39P
(109, 'Soma', 'Santoki', '1960-01-05', 'Male', 'Japanese'), 		-- m39A
(110, 'Kô', 'Shibasaki', '1981-08-05', 'Female', 'Japanese'), 		-- m39A
(111, 'Wim', 'Wenders', '1945-08-14', 'Male', 'German'), 			-- m40D,m40P
(112, 'Kôji', 'Yakusho', '1956-01-01', 'Male', 'Japanese'), 		-- m40A
(113, 'Tokio', 'Emoto', '1989-10-17', 'Male', 'Japanese'), 			-- m40A
(114, 'Rajkumar', 'Hirani', '1962-11-20', 'Male', 'Indian'), 		-- m41D,m41P
(115, 'Aamir', 'Khan', '1965-03-14', 'Male', 'Indian'), 			-- m41A, m42A
(116, 'Madhavan', 'Ranganathan', '1970-06-01', 'Male', 'Indian'), 	-- m41A
(117, 'Sharman', 'Joshi', '1974-04-28', 'Male', 'Indian'), 			-- m41A
(118, 'Kareena', 'Kapoor', '1980-09-21', 'Female', 'Indian'), 		-- m41A
(119, 'Ashutosh', 'Gowariker', '1964-02-15', 'Male', 'Indian'), 	-- m42D,m42P
(120, 'Raghubir', 'Yadav', '1957-06-25', 'Male', 'Indian'), 		-- m42A
(121, 'Gracy', 'Singh', '1980-07-20', 'Female', 'Indian'), 			-- m42A
(122, 'Yeon', 'Sang-ho', '1978-12-25', 'Male', 'South Korean'), 	-- m43D, m43P
(123, 'Gong', 'Yoo', '1979-07-10', 'Male', 'South Korean'), 		-- m43A
(124, 'Jung ', 'Yu-mi', '1983-01-18', 'Female', 'South Korean'), 	-- m43A
(125, 'Vince', 'Gilligan', '1967-02-10', 'Male', 'American'), 		-- s1D,s1P
(126, 'Bryan', 'Cranston', '1956-03-07', 'Male', 'American'), 		-- s1A
(127, 'Aaron', 'Paul', '1979-08-27', 'Male', 'American'), 			-- s1A
(128, 'Anna', 'Gunn', '1968-08-11', 'Female', 'American'), 			-- s1A
(129, 'David', 'Benioff', '1970-09-25', 'Male', 'American'), 		-- s2D
(130, 'D.B.', 'Weiss', '1971-04-23', 'Male', 'American'), 			-- s2P
(131, 'Emilia', 'Clarke', '1986-10-23', 'Female', 'English'), 		-- s2A
(132, 'Peter', 'Dinklage', '1969-06-11', 'Male', 'American'), 		-- s2A
(133, 'Sophie', 'Turner', '1996-02-21', 'Female', 'English'), 		-- s2A
(134, 'Isaac', 'Hempstead Wright', '1999-04-09', 'Male', 'English'),-- s2A
(135, 'Maisie', 'Williams', '1997-04-15', 'Female', 'English'),		-- s2A
(136, 'Matt', 'Duffer', '1984-02-15', 'Male', 'English'),			-- s3D
(137, 'Ross', 'Duffer', '1984-02-15', 'Male', 'English'),			-- s3P
(138, 'Millie', 'Bobby Brown', '2004-02-19', 'Female', 'English'),	-- s3A
(139, 'Finn', 'Wolfhard', '2002-12-23', 'Male', 'English'),			-- s3A
(140, 'Maya', 'Hawke', '1998-07-08', 'Female', 'American'),			-- s3A
(141, 'Peter', 'Morgan', '1963-04-10', 'Male', 'English'),			-- s4D,s4P
(142, 'Claire', 'Foy', '1984-04-16', 'Female', 'English'),			-- s4A
(143, 'Olivia', 'Colman', '1974-01-30', 'Female', 'English'),		-- s4A
(144, 'Imelda', 'Staunton', '1956-01-09', 'Female', 'English'),		-- s4A
(145, 'Jon', 'Favreau', '1956-10-19', 'Male', 'American'),			-- s5D,s5P
(146, 'Pedro', 'Pascal', '1975-04-02', 'Male', 'Chilean'),			-- s5A
(147, 'Chris', 'Bartlett', '1970-09-03', 'Male', 'American'),		-- s5A
(148, 'Katee', 'Sackhoff', '1980-04-08', 'Female', 'American'),		-- s5A
(149, 'Greg', 'Daniels', '1963-06-13', 'Male', 'American'),			-- s6D
(150, 'Ricky', 'Gervais', '1961-06-25', 'Male', 'English'),			-- s6P
(151, 'Steve', 'Carell', '1962-11-16', 'Male', 'American'),			-- s6A
(152, 'Jenna', 'Fischer', '1974-03-07', 'Female', 'American'),		-- s6A
(153, 'John', 'Krasinski', '1979-10-20', 'Male', 'American'),		-- s6A
(154, 'Rainn', 'Wilson', '1966-01-20', 'Male', 'American'),			-- s6A
(155, 'David', 'Crane', '1957-08-13', 'Male', 'American'),			-- s7D,s7P
(156, 'Jennifer', 'Aniston', '1969-02-11', 'Female', 'American'),	-- s7A
(157, 'Matt', 'LeBlanc', '1967-07-25', 'Male', 'American'),			-- s7A
(158, 'Matthew', 'Perry', '1969-08-19', 'Male', 'American'),		-- s7A
(159, 'James', 'L. Brooks', '1940-05-09', 'Male', 'American'),		-- s8D,s8P
(160, 'Dan', 'Castellaneta', '1957-10-29', 'Male', 'American'),		-- s8A
(161, 'Nancy', 'Cartwright', '1957-10-25', 'Female', 'American'),	-- s8A
(162, 'Julie', 'Kavner', '1950-09-07', 'Female', 'American'),		-- s8A
(163, 'Mark', 'Gatiss', '1966-10-17', 'Male', 'English'),			-- s9A,s9D,s9P
(164, 'Steven', 'Moffat', '1961-11-18', 'Male', 'Scottish'),		-- s9D,s9P
(165, 'Martin', 'Freeman', '1971-09-08', 'Male', 'English'),		-- s9A
(166, 'Rupert', 'Graves', '1963-06-30', 'Male', 'English'),			-- s9A
(167, 'Lauren', 'Schmidt', '1978-08-01', 'Female', 'American'),		-- s10D,s10P
(168, 'Henry', 'Cavill', '1983-05-05', 'Male', 'American'),			-- s10A
(169, 'Freya', 'Allan', '2001-09-06', 'Female', 'English'),			-- s10A
(170, 'Anya', 'Chalotra', '1995-07-28', 'Female', 'English'),		-- s10A
(171, 'Chuck', 'Lorre', '1952-10-18', 'Male', 'American'),			-- s11D,s11P
(172, 'Johnny', 'Galecki', '1975-04-18', 'Male', 'Belgian'),		-- s11A
(173, 'Jim', 'Parsons', '1973-03-24', 'Male', 'American'),			-- s11A
(174, 'Kaley', 'Cuoco', '1985-11-30', 'Female', 'American'),		-- s11A
(175, 'Elisabeth', 'Moss', '1982-07-24', 'Female', 'American'),		-- s12A
(176, 'Yvonne', 'Strahovski', '1982-07-30', 'Female', 'Australian'),-- s12A
(177, 'Ann', 'Dowd', '1956-01-30', 'Female', 'American'),			-- s12A
(178, 'Lisa', 'Joy', '1977-05-23', 'Female', 'American'),			-- s13D,s13P
(179, 'Evan', 'Rachel Wood', '1987-09-07', 'Female', 'American'),	-- s13A
(180, 'Jeffrey', 'Wright', '1965-12-07', 'Male', 'American'),		-- s13A
(181, 'Ed', 'Harris', '1950-11-28', 'Male', 'American'),			-- s13A
(182, 'Álex', 'Pina', '1967-06-23', 'Male', 'Spanish'),				-- s14D,s14P
(183, 'Úrsula', 'Corberó', '1989-08-11', 'Female', 'Spanish'),		-- s14A
(184, 'Álvaro', 'Morte', '1975-02-23', 'Male', 'Spanish'),			-- s14A
(185, 'Itziar', 'Ituño', '1974-06-18', 'Female', 'Spanish'),		-- s14A
(186, 'Pedro', 'Alonso', '1971-06-21', 'Male', 'Spanish'),			-- s14A
(187, 'Miguel', 'Herrán', '1996-04-25', 'Male', 'Spanish'),			-- s14A
(188, 'Garry', 'Kasparov', '1963-04-13', 'Male', 'Russian'),		-- s15P
(189, 'Scott', 'Frank', '1960-03-10', 'Male', 'American'),			-- s15D
(190, 'Anya', 'Taylor-Joy', '1996-04-16', 'Female', 'American'),	-- s15A
(191, 'Marcin', 'Dorocinski', '1973-06-22', 'Male', 'Polish'),		-- s15A
(192, 'Harry', 'Melling', '1989-03-13', 'Male', 'English'),			-- s15A
(193, 'Tom', 'Hiddleston', '1981-02-09', 'Male', 'English'),		-- s16A, m25A
(194, 'Owen', 'Wilson', '1968-11-18', 'Male', 'American'),			-- s16A
(195, 'Sophia', 'Di Martino', '1983-11-15', 'Male', 'American'),	-- s16A
(196, 'Tetsurô', 'Araki', '1976-11-05', 'Male', 'Japanese'),		-- s17D
(197, 'Yûichirô', 'Hayashi', '1976-10-06', 'Male', 'Japanese'),		-- s17P -- This dude's bday doesn't exist online
(198, 'Yûki', 'Kaji', '1985-09-03', 'Male', 'Japanese'),			-- s17A 
(199, 'Yui', 'Ishikawa', '1989-05-30', 'Female', 'Japanese'),		-- s17A 
(200, 'Marina', 'Inoue', '1985-01-20', 'Female', 'Japanese'),		-- s17A 
(201, 'Yoshimasa', 'Hosoya', '1982-02-10', 'Male', 'Japanese'),		-- s17A
(202, 'Kenshô', 'Ono', '1989-10-05', 'Male', 'Japanese'),			-- s17A 
(203, 'Krishna', 'D.K.', '1984-12-13', 'Male', 'Indian'),			-- s18D
(204, 'Raj', 'Nidimoru', '1984-12-13', 'Male', 'Indian'),			-- s18P
(205, 'Manoj', 'Bajpayee', '1969-04-23', 'Male', 'Indian'),			-- s18A
(206, 'Sharib', 'Hashmi', '1979-01-25', 'Male', 'Indian'),			-- s18A
(207, 'Ashlesha', 'Thakur', '2003-10-19', 'Female', 'Indian'),		-- s18A
(208, 'Vedant', 'Sinha', '2009-02-18', 'Male', 'Indian'),			-- s18A
(209, 'Hwang', 'Dong-hyuk', '1971-05-26', 'Male', 'South Korean'),	-- s19D, s19P
(210, 'Lee', 'Jung-jae', '1972-12-15', 'Male', 'South Korean'),		-- s19A
(211, 'Park', ' Hae-soo', '1981-11-21', 'Male', 'South Korean'),	-- s19A
(212, 'Nandito', 'Putra', '2002-01-06', 'Male', 'South Korean'),	-- s19A
(213, 'Hailee', 'Steinfeld', '1996-12-11', 'Female', 'American'),	-- s20A
(214, 'Jason', 'Spisak', '1973-08-29', 'Female', 'American'),		-- s20A
(215, 'Ella', 'Purnell', '1996-09-17', 'Female', 'English'),		-- s20A
(216, 'Ash', 'Brannon', '1969-07-19', 'Male', 'American'),			-- s20D
(217, 'Melinda', 'Wunsch', '1966-10-22', 'Female', 'American');		-- s20P

INSERT INTO Director (Director_ID, Directorial_Style) VALUES
(21, 'Complex narratives and non-linear storytelling'),
(23, 'Dark humor and whimsical fantasy'),
(24, 'Stylized violence and sharp dialogue'),
(25, 'Epic storytelling and groundbreaking technology'),
(31, 'Fantasy and adventure films'),
(36, 'Character-driven and emotionally rich stories'),
(40, 'Visually stunning and atmospheric films'),
(44, 'Realism and character study'),
(48, 'Gothic and quirky storytelling'),
(52, 'High concept and action-oriented storytelling'),
(55, 'Psychological depth and technical precision'),
(59, 'Character exploration and feminist themes'),
(65, 'Visual beauty and emotional resonance'),
(91, 'Social commentary and genre-blending'),
(79, 'Social issues and character-driven narratives'),
(85, 'Fantasy and dark comedy'),
(89, 'Animated storytelling and humanism'),
(70, 'Action-oriented and comic book adaptations'),
(93, 'Adaptations of complex literary works'),
(96, 'Science fiction and philosophical themes'),
(99, 'Coming-of-age narratives and dialogue-heavy films'),
(100, 'Strong female protagonists and action films'),
(103, 'Social justice themes and strong narratives'),
(108, 'Horror and suspense-driven storytelling'),
(111, 'Suspense and thriller genres'),
(114, 'Whimsical and unique storytelling'),
(119, 'Thought-provoking and genre-defying films'),
(122, 'Cinematic realism and emotional depth'),
(125, 'Producer-driven and character-focused storytelling'),
(129, 'Twists and supernatural elements'),
(136, 'Quirky and unique visual style'),
(141, 'Controversial themes and experimentation'),
(145, 'Urban culture and ensemble casts'),
(149, 'Character-driven dramas and humor'),
(155, 'Historical and political themes'),
(159, 'Character-driven and intimate storytelling'),
(163, 'Comedic ensemble casts and relatable characters'),
(164, 'Emotional storytelling and character studies'),
(167, 'Innovative and engaging narratives'),
(171, 'Romantic comedies and relationship dynamics'),
(178, 'Dark humor and whimsical fantasy'), -- a
(182, 'Psychological depth and technical precision'),
(189, 'Coming-of-age narratives and dialogue-heavy films'),
(216, 'Gothic and quirky storytelling'),
(203, 'Horror and suspense-driven storytelling'),
(209, 'Thought-provoking and genre-defying films'),
(196, 'Complex narratives and non-linear storytelling');

INSERT INTO Producer (Producer_ID, Production_Methodology) VALUES
(217, 'Collaborative, high-quality storytelling with a focus on character development.'),
(209, 'Innovative approaches to franchise films, combining high production values with diverse narratives.'),
(204, 'Marvel Cinematic Universe assembly-line style producing with a strong focus on interconnectivity.'),
(188, 'Cinematic blockbusters with a focus on fan engagement and audience experience.'),
(182, 'Character-driven narratives with a focus on intricate storytelling and depth.'),
(197, 'Dark, complex narratives focusing on themes of morality and power.'),
(178, 'Diverse storytelling across genres, utilizing new formats and platforms.'),
(171, 'Strong character-driven narratives with a focus on representation and diversity.'),
(167, 'Humor-driven storytelling, with a focus on relatable characters and situations.'),
(164, 'Socially relevant stories with a focus on realism and authenticity.'),
(163, 'Unique, character-driven narratives with a focus on moral ambiguity.'),
(159, 'Diverse narratives and strong representation in comedy and drama.'),
(155, 'Aesthetic-driven productions with a focus on innovative visual storytelling.'),
(150, 'Strong focus on character arcs and emotional narratives.'),
(145, 'Low-budget horror with high creativity and audience engagement.'),
(141, 'Controversial narratives with a focus on dark themes and moral complexity.'),
(137, 'Environmental and social themes with a focus on storytelling through performance.'),
(130, 'Diverse and innovative narratives with a focus on contemporary themes.'),
(122, 'Cinematic storytelling with a focus on social commentary and humor.'),
(125, 'Great character driven complex storylines'),
(119, 'Dramatic narratives with a focus on emotional depth and realism.'),
(114, 'Gothic storytelling with a unique visual style.'),
(111, 'Epic storytelling with a focus on visual effects and world-building.'),
(108, 'Diverse and interconnected stories with a focus on comic adaptations.'),
(103, 'Thought-provoking narratives with a focus on social issues.'),
(100, 'Character-focused comedies with a unique sense of humor.'),
(99, 'Thriller-based storytelling with a focus on plot twists.'),
(96, 'Production of high-profile, big-budget films with strong narratives.'),
(93, 'Diverse storytelling through various genres with a comedic touch.'),
(91, 'Comedic narratives with a focus on character and relationships.'),
(89, 'Innovative storytelling with a focus on high production values and diverse roles.'),
(85, 'Dramatic narratives with a focus on strong female leads.'),
(79, 'Action-oriented storytelling with a focus on visual spectacle.'),
(70, 'Innovative storytelling with a focus on character depth and historical narratives.'),
(65, 'Epic, character-driven narratives with strong visual storytelling.'),
(59, 'Complex narratives focusing on family and moral dilemmas.'),
(55, 'Diverse stories with a focus on underrepresented voices in film.'),
(52, 'Strong narratives with a focus on genre diversity and unique storytelling.'),
(48, 'Cinematic storytelling with a focus on historical and biographical narratives.'),
(45, 'Socially conscious narratives with a focus on representation.'),
(44, 'Innovative storytelling with a focus on contemporary themes and representation.'),
(40, 'Unique, character-driven narratives with a focus on moral ambiguity.'),
(36, 'Diverse and innovative narratives with a focus on contemporary themes.'),
(35, 'Innovative approaches to franchise films, combining high production values with diverse narratives.'),
(31, 'Dramatic narratives with a focus on emotional depth and realism.'),
(26, 'Diverse storytelling across genres, utilizing new formats and platforms.'),
(25, 'Marvel Cinematic Universe assembly-line style producing with a strong focus on interconnectivity.'),
(24, 'Thought-provoking narratives with a focus on social issues.'),
(23, 'Complex narratives focusing on family and moral dilemmas.'),
(22, 'Controversial narratives with a focus on dark themes and moral complexity.'),
(21, 'Thriller-based storytelling with a focus on plot twists.');

INSERT INTO Actor (Actor_ID, Role_Range) VALUES
(1, 'Versatile roles in action, drama, and comedy.'),
(2, 'Strong performances in action and drama, often portraying complex characters.'),
(3, 'Heroic roles in action and superhero films.'),
(4, 'Dramatic roles in fantasy and adventure films.'),
(5, 'Action and adventure roles, often portraying heroic characters.'),
(6, 'Dramatic and diverse roles, often in thought-provoking films.'),
(7, 'Strong performances in dramatic and thriller roles.'),
(8, 'Diverse roles in drama, action, and historical films.'),
(9, 'Complex characters in drama and biographical films.'),
(10, 'Diverse roles in action, drama, and humanitarian-themed films.'),
(11, 'Dramatic and comedic roles, often portraying strong female characters.'),
(12, 'Diverse roles in musicals, action films, and dramas.'),
(13, 'Comedic and dramatic roles, often portraying likable characters.'),
(14, 'Diverse roles in romantic comedies and action films.'),
(15, 'Strong performances in coming-of-age and fantasy films.'),
(16, 'Versatile roles in drama and thriller films.'),
(17, 'Intense roles in dramas and fantasy films.'),
(18, 'Complex characters in drama and psychological thrillers.'),
(19, 'Diverse roles in comedy, drama, and historical films.'),
(20, 'Strong performances in drama and romance.'),
(27, 'Iconic roles in action and adventure films.'),
(28, 'Strong performances in action and drama, often portraying complex characters.'),
(29, 'Diverse roles in drama, action, and fantasy films.'),
(30, 'Versatile roles in drama and comedy.'),
(32, 'Iconic roles in action and adventure films.'),
(33, 'Strong performances in action and superhero films.'),
(34, 'Versatile roles in action and drama.'),
(37, 'Diverse roles in drama and fantasy films.'),
(38, 'Diverse roles in action, drama, and thriller films.'),
(39, 'Strong performances in musicals and dramas.'),
(41, 'Diverse roles in drama and action films.'),
(42, 'Versatile roles in action, drama, and romance.'),
(43, 'Dramatic roles in action and fantasy films.'),
(46, 'Comedic and dramatic roles in television and film.'),
(47, 'Comedic roles, often portraying relatable characters.'),
(49, 'Comedic and dramatic roles, often in ensemble casts.'),
(50, 'Comedic and dramatic roles in television and film.'),
(51, 'Strong performances in drama, comedy, and biographical films.'),
(53, 'Diverse roles in drama and comedy.'),
(54, 'Versatile roles in drama and television.'),
(57, 'Diverse roles in drama and action films.'),
(58, 'Strong performances in drama and action films.'),
(60, 'Diverse roles in drama and classics.'),
(61, 'Strong performances in drama and independent films.'),
(62, 'Diverse roles in drama, action, and romantic comedies.'),
(63, 'Strong performances in action and dramatic films.'),
(64, 'Versatile roles in drama and comedy.'),
(66, 'Comedic and dramatic roles, often in ensemble casts.'),
(67, 'Comedic roles and strong performances in television.'),
(68, 'Diverse roles in drama and action films.'),
(69, 'Diverse roles in drama and biographical films.'),
(71, 'Strong performances in coming-of-age and fantasy films.'),
(72, 'Diverse roles in drama and action films.'),
(73, 'Action and fantasy roles, often portraying heroic characters.'),
(74, 'Strong performances in action and adventure films.'),
(75, 'Comedic roles, often in buddy films.'),
(76, 'Diverse roles in drama and action films.'),
(77, 'Diverse roles in drama and coming-of-age films.'),
(78, 'Versatile roles in drama and action films.'),
(80, 'Comedic and dramatic roles in film and television.'),
(81, 'Challenging roles in historical dramas and war films.'),
(82, 'Diverse roles in horror and thriller genres, often as the lead.'),
(83, 'Charismatic characters in romantic and family films.'),
(84, 'Strong performances in suspense and psychological thrillers.'),
(181, 'Dramatic roles in romantic and period dramas.'),
(86, 'Heroic roles in science fiction and action genres.'),
(87, 'Complex characters in legal and crime dramas.'),
(88, 'Comedic and dramatic roles in animated films and voice work.'),
(183, 'Diverse roles in historical dramas and fantasy films.'),
(90, 'Comedic roles, often portraying quirky characters.'),
(184, 'Dynamic performances in superhero and fantasy films.'),
(92, 'Dramatic roles in science fiction and mystery genres.'),
(185, 'Complex characters in biographical and inspirational films.'),
(94, 'Strong performances in dark comedies and thrillers.'),
(95, 'Diverse roles in mystery, drama, and suspense films.'),
(186, 'Comedic and action roles in family and children''s films.'),
(97, 'Romantic leads in drama and adventure films.'),
(98, 'Dramatic roles in horror and psychological thrillers.'),
(187, 'Versatile roles in historical and war epics.'),
(190, 'Dramatic and comedic roles in ensemble casts.'),
(101, 'Powerful performances in suspense and drama films.'),
(102, 'Dynamic roles in science fiction and futuristic thrillers.'),
(191, 'Comedic roles in romantic and family-centered films.'),
(104, 'Complex characters in fantasy and biographical dramas.'),
(105, 'Versatile performances in drama, comedy, and musicals.'),
(106, 'Dramatic and comedic roles in dark comedy genres.'),
(107, 'Heroic characters in war and adventure films.'),
(192, 'Comedic and romantic roles in animated features.'),
(109, 'Complex roles in historical and drama genres.'),
(110, 'Diverse performances in horror and thriller films.'),
(193, 'Strong performances in coming-of-age dramas.'),
(112, 'Versatile roles in horror, action, and science fiction.'),
(113, 'Romantic leads in drama and romantic comedies.'),
(194, 'Powerful roles in biographical and inspirational films.'),
(115, 'Dramatic roles in crime and thriller genres.'),
(116, 'Comedic roles, often portraying eccentric characters.'),
(117, 'Diverse roles in fantasy and science fiction epics.'),
(118, 'Complex characters in historical and adventure films.'),
(195, 'Dramatic and complex roles in fantasy and historical dramas.'),
(120, 'Versatile performances in comedy, drama, and romance.'),
(121, 'Diverse roles in action, fantasy, and drama films.'),
(199, 'Comedic roles, often in satire and parody films.'),
(123, 'Dramatic roles in period pieces and romantic dramas.'),
(124, 'Dynamic performances in action and superhero films.'),
(198, 'Complex characters in science fiction and thriller genres.'),
(126, 'Romantic roles in drama and family films.'),
(127, 'Dramatic roles in crime and detective stories.'),
(128, 'Comedic roles, often as the comic relief.'),
(200, 'Dramatic and action roles in thriller films.'),
(201, 'Versatile roles in science fiction and horror genres.'),
(131, 'Strong performances in romantic and biographical dramas.'),
(132, 'Comedic and dramatic roles in historical epics.'),
(133, 'Dynamic performances in action and fantasy films.'),
(134, 'Diverse roles in animated and live-action comedies.'),
(135, 'Dramatic roles in suspense and crime genres.'),
(202, 'Heroic characters in action and war films.'),
(205, 'Complex roles in drama and romance genres.'),
(138, 'Versatile roles in horror and psychological thrillers.'),
(139, 'Romantic leads in musicals and comedies.'),
(140, 'Diverse roles in science fiction and fantasy epics.'),
(206, 'Dramatic roles in period dramas and historical films.'),
(142, 'Dynamic roles in action, fantasy, and superhero genres.'),
(143, 'Complex characters in legal and crime dramas.'),
(144, 'Comedic roles, often portraying everyday characters.'),
(207, 'Dramatic roles in horror and suspense films.'),
(146, 'Romantic roles in coming-of-age and fantasy films.'),
(147, 'Heroic roles in action and thriller films.'),
(148, 'Diverse roles in comedy, drama, and action genres.'),
(149, 'Strong performances in biographical and musical films.'),
(150, 'Dramatic roles in fantasy and mystery genres.'),
(151, 'Diverse roles in action, drama, and sci-fi films.'),
(152, 'Comedic and dramatic roles in animated films.'),
(153, 'Dynamic roles in mystery and suspense genres.'),
(154, 'Complex roles in war and adventure genres.'),
(208, 'Dramatic roles in romantic and family-oriented films.'),
(156, 'Comedic roles in dark comedy and satire films.'),
(157, 'Versatile roles in thriller and crime genres.'),
(158, 'Dramatic performances in historical and biographical films.'),
(210, 'Heroic characters in science fiction and adventure films.'),
(160, 'Comedic roles in romantic comedies and dramas.'),
(161, 'Dynamic roles in action and historical epics.'),
(162, 'Complex roles in biographical and psychological dramas.'),
(163, 'Dramatic roles in mystery and suspense genres.'),
(211, 'Versatile roles in comedy, drama, and action.'),
(165, 'Diverse roles in horror and fantasy genres.'),
(166, 'Strong performances in dramatic and musical films.'),
(212, 'Heroic roles in fantasy and science fiction genres.'),
(168, 'Diverse roles in animated and family-oriented films.'),
(169, 'Dynamic performances in action and thriller genres.'),
(170, 'Dramatic roles in war and historical dramas.'),
(213, 'Versatile roles in comedy, drama, and mystery genres.'),
(172, 'Comedic and action roles in children’s films.'),
(173, 'Dramatic roles in romantic comedies and dramas.'),
(174, 'Strong performances in historical and fantasy epics.'),
(175, 'Diverse roles in fantasy, action, and drama films.'),
(176, 'Heroic characters in superhero and science fiction films.'),
(177, 'Diverse roles in animated and adventure films.'),
(214, 'Dramatic roles in crime and thriller genres.'),
(179, 'Comedic roles in romantic and fantasy films.'),
(180, 'Complex characters in biographical and psychological thrillers.'),
(215, 'Versatile roles in thriller and crime genres.');

INSERT INTO Languages (Language_ID, Language_Name) VALUES
(1, 'English'),
(2, 'Spanish'),
(3, 'French'),
(4, 'German'),
(5, 'Mandarin'),
(6, 'Japanese'),
(7, 'Hindi'),
(8, 'Korean');

DELIMITER $$

CREATE TRIGGER set_join_date
BEFORE INSERT ON Users
FOR EACH ROW
BEGIN
    IF NEW.User_Join_Date IS NULL THEN
        SET NEW.User_Join_Date = CURDATE();
    END IF;
END $$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER update_last_online
BEFORE UPDATE ON Users
FOR EACH ROW
BEGIN
    IF OLD.User_Authentication_Key <> NEW.User_Authentication_Key OR 
       (OLD.User_Authentication_Key IS NULL AND NEW.User_Authentication_Key IS NOT NULL) OR 
       (OLD.User_Authentication_Key IS NOT NULL AND NEW.User_Authentication_Key IS NULL) THEN
        SET NEW.User_Last_Online = NOW();
    END IF;
END $$

DELIMITER ;

INSERT INTO Users ( User_ID, Username, User_Mail, User_Password_Encrypted, User_Role, User_Authentication_Key, User_DOB, User_Country, Watchlist_URL) VALUES
(1, 'john_doe', 'john.doe@example.com', '$2b$10$XXEguln0gKOV2vgMNCQPB.QhSAzihKSuxL7OptZ8xBc2EgDtoDxXW', 'User', NULL, '1990-05-20', 'United States', '/watchlist/john_doe'),
(2, 'jane_smith', 'jane.smith@example.com', '$2b$10$XXEguln0gKOV2vgMNCQPB.QhSAzihKSuxL7OptZ8xBc2EgDtoDxXW', 'User', NULL, '1985-07-30', 'Canada', '/watchlist/jane_smith'),
(3, 'mike_jones', 'mike.jones@example.com', '$2b$10$XXEguln0gKOV2vgMNCQPB.QhSAzihKSuxL7OptZ8xBc2EgDtoDxXW', 'User', NULL, '1992-12-10', 'United Kingdom', '/watchlist/mike_jones'),
(4, 'alice_brown', 'alice.brown@example.com', '$2b$10$XXEguln0gKOV2vgMNCQPB.QhSAzihKSuxL7OptZ8xBc2EgDtoDxXW', 'User', NULL, '1988-11-15', 'Australia', '/watchlist/alice_brown'),
(5, 'charlie_green', 'charlie.green@example.com', '$2b$10$XXEguln0gKOV2vgMNCQPB.QhSAzihKSuxL7OptZ8xBc2EgDtoDxXW', 'User', NULL, '1993-03-05', 'Germany', '/watchlist/charlie_green'),
(6, 'dave_white', 'dave.white@example.com', '$2b$10$XXEguln0gKOV2vgMNCQPB.QhSAzihKSuxL7OptZ8xBc2EgDtoDxXW', 'User', NULL, '1995-02-25', 'France', '/watchlist/dave_white'),
(7, 'eve_black', 'eve.black@example.com', '$2b$10$XXEguln0gKOV2vgMNCQPB.QhSAzihKSuxL7OptZ8xBc2EgDtoDxXW', 'User', NULL, '1989-08-30', 'Italy', '/watchlist/eve_black'),
(8, 'frank_yellow', 'frank.yellow@example.com', '$2b$10$XXEguln0gKOV2vgMNCQPB.QhSAzihKSuxL7OptZ8xBc2EgDtoDxXW', 'User', NULL, '1991-06-12', 'Spain', '/watchlist/frank_yellow'),
(9, 'grace_purple', 'grace.purple@example.com', '$2b$10$XXEguln0gKOV2vgMNCQPB.QhSAzihKSuxL7OptZ8xBc2EgDtoDxXW', 'User', NULL, '1987-09-24', 'Mexico', '/watchlist/grace_purple'),
(10, 'henry_orange', 'henry.orange@example.com', '$2b$10$XXEguln0gKOV2vgMNCQPB.QhSAzihKSuxL7OptZ8xBc2EgDtoDxXW', 'User', NULL, '1994-04-18', 'Brazil', '/watchlist/henry_orange'),
(11, 'isabella_cyan', 'isabella.cyan@example.com', '$2b$10$XXEguln0gKOV2vgMNCQPB.QhSAzihKSuxL7OptZ8xBc2EgDtoDxXW', 'User', NULL, '1986-01-12', 'India', '/watchlist/isabella_cyan'),
(12, 'jack_red', 'jack.red@example.com', '$2b$10$XXEguln0gKOV2vgMNCQPB.QhSAzihKSuxL7OptZ8xBc2EgDtoDxXW', 'User', NULL, '1990-07-23', 'Japan', '/watchlist/jack_red'),
(13, 'karen_violet', 'karen.violet@example.com', '$2b$10$XXEguln0gKOV2vgMNCQPB.QhSAzihKSuxL7OptZ8xBc2EgDtoDxXW', 'User', NULL, '1992-10-15', 'South Korea', '/watchlist/karen_violet'),
(14, 'luke_magenta', 'luke.magenta@example.com', '$2b$10$XXEguln0gKOV2vgMNCQPB.QhSAzihKSuxL7OptZ8xBc2EgDtoDxXW', 'User', NULL, '1984-11-01', 'Russia', '/watchlist/luke_magenta'),
(15, 'molly_teal', 'molly.teal@example.com', '$2b$10$XXEguln0gKOV2vgMNCQPB.QhSAzihKSuxL7OptZ8xBc2EgDtoDxXW', 'User', NULL, '1995-08-30', 'China', '/watchlist/molly_teal'),
(16, 'nathan_pink', 'nathan.pink@example.com', '$2b$10$XXEguln0gKOV2vgMNCQPB.QhSAzihKSuxL7OptZ8xBc2EgDtoDxXW', 'User', NULL, '1983-02-20', 'Australia', '/watchlist/nathan_pink'),
(17, 'olivia_brown', 'olivia.brown@example.com', '$2b$10$XXEguln0gKOV2vgMNCQPB.QhSAzihKSuxL7OptZ8xBc2EgDtoDxXW', 'User', NULL, '1992-05-15', 'Canada', '/watchlist/olivia_brown'),
(18, 'paul_silver', 'paul.silver@example.com', '$2b$10$XXEguln0gKOV2vgMNCQPB.QhSAzihKSuxL7OptZ8xBc2EgDtoDxXW', 'User', NULL, '1989-03-25', 'United States', '/watchlist/paul_silver'),
(19, 'quinn_gold', 'quinn.gold@example.com', '$2b$10$XXEguln0gKOV2vgMNCQPB.QhSAzihKSuxL7OptZ8xBc2EgDtoDxXW', 'User', NULL, '1988-12-12', 'Germany', '/watchlist/quinn_gold'),
(20, 'rose_bronze', 'rose.bronze@example.com', '$2b$10$XXEguln0gKOV2vgMNCQPB.QhSAzihKSuxL7OptZ8xBc2EgDtoDxXW', 'User', NULL, '1990-01-18', 'France', '/watchlist/rose_bronze'),
(21, 'Aman Gupta', 'aman1406gupta@gmail.com', '$2b$10$bJuAPdphTOJHu1HFsWYNq.183ZgNQkO6Vc020R8NCgT1GoIvxcbay', 'Admin', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjEsImlhdCI6MTczMTIyNzIzM30.n2h7cDLvY4ziUn0ip7rMT6RcLdNTtNiURwjQKTxEdDU', '01-04-2006', 'India', '/watchlist/aman_gupta'),
(22, 'Srinidhi Sai Boorgu', 'cse230001072@iiti.ac.in', '$2b$10$XXEguln0gKOV2vgMNCQPB.QhSAzihKSuxL7OptZ8xBc2EgDtoDxXW', 'Admin', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjIsImlhdCI6MTczMTIyMzg5N30.5FGDVcpV73LSAdzdaIAKd0Qsed8e8GgOhmgI5YgiekE', '2004-11-07', 'India', '/watchlist/srinidhi_sai_boorgu'),
(23, 'Ansh Jain', 'cse230004005@iiti.ac.in', '$2b$10$hTXL9hrVVyAd43h8L99kwudua2fXX51FbQwexVtm2jx8oAXwWepBm', 'User', NULL, '2005-01-01', 'India', '/watchlist/ansh_jain'),
(24, 'Abhinav Bitragunta', 'cse230001003@iiti.ac.in', '$2b$10$TgivJfhRJq8Gs.FAPw1k8eo..ihkjuj5xSOeOx7zPvy3KRp0pKA.2', 'Admin', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjQsImlhdCI6MTczMDQ4NjI4MH0.lxMo1xe2RgII2RLCg-A3oqnFRB2Kkez9u-rKqrjF1CU', '2005-08-11', 'India', '/watchlist/abhinav_bitragunta');

UPDATE Users SET User_Authentication_Key = "dummy";
UPDATE Users SET User_Authentication_Key = NULL;

INSERT INTO Reviews (Review_ID, User_ID, Review_Comment, Media_Rating, Review_Date, Like_Count, Dislike_Count) VALUES
(1,21, 'A captivating story with stunning visuals.', 9.0, '2024-01-15', 120, 5),
(2,1, 'Solid plot but lacked character development.', 7.6, '2024-02-20', 75, 10),
(3,16, 'An excellent plot that exceeded expectations.', 10.0, '2024-03-05', 210, 3),
(4,20, 'Average story with predictable plotlines.', 6.4, '2024-04-12', 40, 15),
(5,18, 'Brilliant direction and acting!', 9.4, '2024-05-08', 180, 7),
(6,12, 'Not as good as the previous season.', 5.8, '2024-06-19', 30, 25),
(7,13, 'Perfect balance of suspense and humor.', 9.2, '2024-07-22', 190, 4),
(8,6, 'A slow start but picks up well in the second half.', 7.8, '2024-08-15', 85, 20),
(9,15, 'Could have been better with a stronger script.', 7.0, '2024-09-10', 65, 18),
(10,11, 'Absolutely loved it! A must-watch.', 9.6, '2024-10-01', 230, 2),
(11,23, 'A masterpiece in storytelling.', 10.0, '2024-10-15', 300, 1),
(12,22, 'Interesting concept but poorly executed.', 5.4, '2024-10-20', 40, 35),
(13,7, 'Well-done! The cinematography is stunning.', 8.8, '2024-10-22', 160, 6),
(14,19, 'Predictable and lacks originality.', 5.6, '2024-10-25', 50, 30),
(15,14, 'Good for a one-time watch.', 7.2, '2024-10-26', 70, 12),
(16,2, 'Amazing soundtrack and visuals!', 9.0, '2024-10-25', 175, 8),
(17,17, 'Not my cup of tea, too slow-paced.', 5.0, '2024-10-23', 35, 28),
(18,5, 'Entertaining and keeps you on the edge.', 8.4, '2024-10-19', 150, 10),
(19,9, 'Weak storyline, could have been better.', 6.0, '2024-10-16', 60, 22),
(20,24, 'Incredible performance by the lead actor!', 9.8, '2024-10-14', 220, 3),
(21,8, 'A bit overhyped but still enjoyable.', 7.4, '2024-10-12', 90, 15),
(22,4, 'Beautifully shot, a visual treat.', 8.6, '2024-10-10', 145, 5),
(23,3, 'A forgettable experience, unfortunately.', 5.8, '2024-10-07', 55, 19),
(24,10, 'Loved the character arcs!', 9.2, '2024-10-05', 200, 4),
(25,6, 'Confusing plot, hard to follow.', 5.2, '2024-10-02', 30, 25),
(26,18, 'Great plot but dragged in some parts.', 6.8, '2024-09-28', 80, 14),
(27,22, 'Would watch it again! Fantastic work.', 9.4, '2024-09-20', 210, 3),
(28,10, 'Too much CGI, took away from the story.', 6.2, '2024-09-15', 65, 20),
(29,3, 'A classic. Worth every minute.', 9.8, '2024-09-12', 250, 2),
(30,2, 'Good story, but nothing groundbreaking.', 7.6, '2024-09-05', 75, 16),
(31,17, 'Fascinating insights, but could be more engaging.', 7.0, '2024-08-28', 50, 10),
(32,4, 'An emotional rollercoaster, loved every moment!', 9.6, '2024-08-25', 200, 5),
(33,14, 'Poor pacing made it hard to stay invested.', 5.6, '2024-08-20', 40, 15),
(34,24, 'Great chemistry between the leads!', 8.8, '2024-08-15', 120, 4),
(35,1, 'A visually stunning experience!', 9.2, '2024-08-10', 150, 6),
(36,15, 'Interesting characters but weak plot.', 6.0, '2024-08-05', 70, 12),
(37,11, 'A fun watch with some great twists!', 8.6, '2024-07-30', 180, 3),
(38,19, 'Not what I expected, but in a good way.', 8.2, '2024-07-25', 110, 8),
(39,20, 'The dialogue felt forced at times.', 5.4, '2024-07-20', 65, 18),
(40,21, 'An average story with some standout moments.', 6.6, '2024-07-15', 75, 14),
(41,12, 'A fresh take on a classic story!', 9.0, '2024-07-10', 130, 5),
(42,8, 'Charming performances but lacks depth.', 7.2, '2024-07-05', 90, 10),
(43,5, 'The ending was predictable but still satisfying.', 7.8, '2024-06-30', 85, 11),
(44,23, 'Great soundtrack, but the plot fell flat.', 6.2, '2024-06-25', 60, 20),
(45,9, 'Well-acted but too lengthy.', 7.6, '2024-06-20', 70, 15),
(46,16, 'Enjoyable but forgettable.', 6.4, '2024-06-15', 50, 25),
(47,13, 'An exceptional story that stays with you.', 9.8, '2024-06-10', 250, 2),
(48,7, 'The characters were not relatable.', 4.8, '2024-06-05', 40, 30),
(49,17, 'A delightful surprise, highly recommended!', 9.4, '2024-05-30', 210, 3),
(50,11, 'Not for everyone, but I loved it!', 8.0, '2024-05-25', 100, 7),
(51,14, 'An engaging story but a bit predictable.', 7.4, '2024-05-20', 85, 10),
(52,10, 'A solid performance from the cast!', 8.2, '2024-05-15', 120, 5),
(53,6, 'Loved the cinematography, but the plot was lacking.', 7.2, '2024-05-10', 70, 15),
(54,3, 'A compelling tale with strong characters.', 8.8, '2024-05-05', 140, 4),
(55,16, 'Had its moments, but overall forgettable.', 5.8, '2024-05-01', 50, 20),
(56,13, 'Well-crafted but felt too long.', 7.6, '2024-04-30', 90, 8),
(57,1, 'A fantastic sequel that lives up to expectations!', 9.4, '2024-04-25', 200, 3),
(58,7, 'A real treat for fans of the genre.', 9.0, '2024-04-20', 110, 6),
(59,24, 'I didnt find it engaging, unfortunately.', 5.2, '2024-04-15', 40, 25),
(60,19, 'Great performances, but the script was weak.', 6.6, '2024-04-10', 80, 14),
(61,4, 'An enjoyable story with a great cast.', 8.6, '2024-03-15', 140, 5),
(62,12, 'The plot twist was unexpected and brilliant!', 9.6, '2024-03-10', 180, 2),
(63,18, 'Disappointing sequel, lacked the charm of the original.', 5.0, '2024-03-05', 45, 20),
(64,22, 'Engaging from start to finish, a must-watch!', 9.2, '2024-02-28', 200, 4),
(65,20, 'Stunning visuals, but the story fell short.', 7.4, '2024-02-25', 85, 12),
(66,15, 'Had potential but didn’t deliver.', 5.6, '2024-02-20', 40, 25),
(67,5, 'A light-hearted story that brightened my day!', 9.0, '2024-02-15', 150, 3),
(68,8, 'Excellent writing and character development.', 9.4, '2024-02-10', 160, 1),
(69,9, 'An emotional journey, beautifully told.', 9.8, '2024-02-05', 210, 2),
(70,21, 'Good concept, but execution was lacking.', 6.0, '2024-01-30', 55, 15),
(71,2, 'Not what I expected, but I enjoyed it.', 8.0, '2024-01-25', 120, 7),
(72,23, 'Fascinating take on a classic tale.', 8.4, '2024-01-20', 135, 6),
(73,20, 'Had its moments, but felt uneven.', 6.8, '2024-01-15', 70, 14),
(74,7, 'An exceptional performance by the lead!', 9.6, '2024-01-10', 220, 3),
(75,2, 'The pacing was off, making it drag.', 5.8, '2024-01-05', 60, 18),
(76,17, 'A delightful mix of humor and drama!', 8.8, '2024-01-01', 150, 4),
(77,13, 'A classic story that still holds up.', 10.0, '2023-12-28', 300, 1),
(78,6, 'The characters felt flat and uninteresting.', 5.2, '2023-12-20', 40, 20),
(79,5, 'A gripping storyline that kept me hooked.', 9.2, '2023-12-15', 180, 5),
(80,8, 'Too long and overly complicated.', 5.4, '2023-12-10', 50, 30),
(81,22, 'An exhilarating journey with stunning visuals and a gripping storyline.', 8.5, '2019-05-14', 78, 22),
(82,15, 'A decent watch but lacked depth in characters.', 6.3, '2018-11-21', 45, 55),
(83,21, 'An emotional rollercoaster that keeps you hooked till the end.', 9.2, '2020-06-30', 83, 17),
(84,12, 'Predictable plot but enjoyable performances.', 5.8, '2021-01-15', 52, 48),
(85,3, 'A perfect blend of action and humor, a must-watch!', 8.7, '2017-08-20', 95, 5),
(86,24, 'Disappointing storyline with forgettable characters.', 4.3, '2019-10-02', 37, 63),
(87,9, 'A masterpiece with a soundtrack that enhances the experience.', 9.4, '2021-12-05', 88, 12),
(88,16, 'Visually impressive but lacks substance.', 6.1, '2020-03-19', 60, 40),
(89,10, 'An average plot that doesn’t live up to the hype.', 5.5, '2016-07-27', 47, 53),
(90,19, 'A thrilling ride from start to finish!', 8.9, '2019-09-16', 82, 18),
(91,23, 'A bit slow-paced but the cinematography is beautiful.', 6.9, '2018-02-14', 53, 47),
(92,1, 'Excellent character development and an engaging plot.', 9.0, '2022-04-11', 90, 10),
(93,11, 'Not as good as the original, but still worth a watch.', 6.2, '2017-05-07', 49, 51),
(94,4, 'Captivating storyline with powerful performances.', 8.1, '2021-07-22', 74, 26),
(95,18, 'An underwhelming experience despite the hype.', 4.7, '2020-10-10', 39, 61),
(96,14, 'Fantastic action sequences but lacks emotional depth.', 7.5, '2018-09-04', 66, 34),
(97,20, 'An inspiring story beautifully told.', 8.8, '2017-03-23', 84, 16),
(98,15, 'A forgettable story with a predictable plot.', 4.2, '2016-12-08', 29, 71),
(99,24, 'Excellent performances but the pacing is a bit slow.', 7.1, '2021-11-27', 65, 35),
(100,4, 'A visually stunning masterpiece with a complex storyline.', 9.3, '2019-02-14', 91, 9),
(101,14, 'The humor falls flat, and the plot feels recycled.', 5.0, '2017-10-19', 42, 58),
(102,21, 'A gripping drama that touches the heart.', 8.6, '2018-06-06', 80, 20),
(103,17, 'Entertaining but nothing groundbreaking.', 6.4, '2020-04-03', 58, 42),
(104,5, 'A disappointing sequel that doesn’t capture the magic of the first.', 4.9, '2019-12-22', 41, 59),
(105,12, 'A beautifully crafted story with an unforgettable soundtrack.', 9.1, '2022-03-15', 89, 11),
(106,19, 'The plot twists are predictable, making it less thrilling.', 5.3, '2017-01-28', 46, 54),
(107,23, 'An intense storyline with standout performances.', 8.3, '2021-08-09', 76, 24),
(108,6, 'The special effects are amazing, but the plot is lacking.', 6.6, '2018-12-17', 62, 38),
(109,2, 'A heartwarming story that stays with you.', 8.9, '2020-02-25', 87, 13),
(110,10, 'Mediocre script that fails to leave an impact.', 4.5, '2016-11-30', 34, 66),
(111,1, 'A must-watch for fans of the genre.', 8.0, '2019-06-21', 77, 23),
(112,7, 'An overly long story that fails to hold attention.', 5.4, '2021-03-06', 48, 52),
(113,22, 'A remarkable story that redefines storytelling.', 9.5, '2022-07-10', 94, 6),
(114,18, 'Too predictable to be engaging.', 5.6, '2018-05-19', 44, 56),
(115,9, 'A refreshing story with strong characters.', 8.2, '2020-08-02', 73, 27),
(116,11, 'Dull and uninspiring, not worth the time.', 3.8, '2017-09-27', 32, 68),
(117,3, 'Top-notch acting and a storyline that keeps you guessing.', 8.4, '2021-10-30', 79, 21),
(118,16, 'An overly complex plot that leaves you confused.', 5.2, '2019-01-11', 43, 57),
(119,13, 'A breathtaking experience with unforgettable visuals.', 9.0, '2022-05-14', 92, 8),
(120,8, 'Weak character development and a shallow plot.', 4.6, '2018-03-04', 36, 64),
(121,5, 'A solid plot with a feel-good ending.', 7.8, '2017-12-25', 69, 31),
(122,16, 'An inspiring story with a beautiful message.', 8.7, '2020-09-18', 85, 15),
(123,21, 'Disjointed plot with weak dialogue.', 4.4, '2019-07-23', 38, 62),
(124,1, 'A thrilling plot with unexpected twists.', 8.1, '2021-05-02', 75, 25),
(125,10, 'A good plot but felt a bit too long.', 6.7, '2018-11-12', 59, 41),
(126,22, 'A fresh take on a classic story, highly recommended.', 9.2, '2019-04-05', 90, 10),
(127,23, 'Underwhelming despite the star-studded cast.', 5.1, '2017-06-29', 50, 50),
(128,4, 'Amazing visuals but lacking in plot.', 6.0, '2020-01-14', 57, 43),
(129,9, 'A compelling story with powerful performances.', 8.5, '2018-10-11', 83, 17),
(130,12, 'An uninspired remake with nothing new to offer.', 3.9, '2016-08-03', 31, 69),
(131,24, 'An action-packed thriller that keeps you on the edge of your seat.', 8.8, '2019-03-27', 84, 16),
(132,3, 'Too much style, too little substance.', 4.8, '2021-02-08', 40, 60),
(133,19, 'A heartwarming tale with unforgettable characters.', 9.3, '2022-06-20', 91, 9),
(134,17, 'Fails to live up to expectations with a bland story.', 5.7, '2020-12-16', 55, 45),
(135,8, 'A mesmerizing journey that captivates from the first scene.', 8.9, '2018-07-15', 88, 12),
(136,2, 'Unnecessarily long with a tedious plot.', 4.1, '2017-02-21', 35, 65),
(137,18, 'A great balance of drama, action, and humor.', 7.9, '2021-04-18', 71, 29),
(138,11, 'Falls flat with its predictable storyline.', 5.9, '2020-11-03', 54, 46),
(139,7, 'A beautifully shot story with an original plot.', 8.2, '2019-08-07', 78, 22),
(140,14, 'Not engaging, feels like a waste of time.', 4.0, '2017-12-04', 33, 67),
(141,6, 'An intriguing plot with great acting.', 8.3, '2018-01-30', 76, 24),
(142,13, 'Dull and overly dramatic, not recommended.', 3.6, '2016-05-16', 28, 72),
(143,20, 'A gripping thriller with a fantastic storyline.', 9.1, '2019-05-25', 89, 11),
(144,15, 'Poor pacing with a lackluster ending.', 5.4, '2020-09-10', 49, 51),
(145,9, 'A charming story that’s beautifully executed.', 8.7, '2021-01-20', 85, 15),
(146,19, 'Uninteresting plot with a weak ending.', 4.5, '2017-07-06', 37, 63),
(147,11, 'A suspenseful and well-crafted mystery.', 8.4, '2019-10-27', 79, 21),
(148,15, 'Highly entertaining with a lot of laugh-out-loud moments.', 8.0, '2022-04-29', 77, 23),
(149,7, 'The visuals are stunning, but the story falls flat.', 5.8, '2018-03-15', 51, 49),
(150,12, 'A thought-provoking story with an impactful message.', 8.9, '2021-09-12', 87, 13),
(151,24, 'Poor dialogue and a confusing plot.', 4.3, '2019-11-05', 38, 62),
(152,14, 'An epic tale with brilliant performances.', 9.0, '2022-08-04', 90, 10),
(153,4, 'A bit overrated, the plot lacks originality.', 5.5, '2016-06-09', 46, 54),
(154,16, 'Excellent storyline and great acting.', 8.5, '2019-12-15', 83, 17),
(155,10, 'Feels forced and lacks emotional connection.', 4.9, '2020-07-21', 42, 58),
(156,2, 'A well-executed story with strong characters.', 8.2, '2021-05-08', 75, 25),
(157,17, 'Fails to engage, the plot is too slow.', 5.2, '2017-09-02', 43, 57),
(158,20, 'A stunning story with an incredible soundtrack.', 9.4, '2020-02-22', 92, 8),
(159,23, 'Good acting but a predictable story.', 6.5, '2018-06-14', 60, 40),
(160,5, 'A refreshing take on a familiar story.', 8.1, '2019-01-17', 74, 26),
(161,24, 'An intense installment with great performances by the cast.', 8.5, '2024-02-03', 98, 12),
(162,11, 'The plot twists are mind-boggling and executed perfectly!', 9.3, '2024-02-11', 143, 7),
(163,19, 'A well-crafted story with a fantastic score to match.', 8.8, '2024-02-19', 110, 8),
(164,16, 'Some pacing issues, but the story remains engaging.', 7.5, '2024-03-05', 65, 18),
(165,7, 'Heartfelt moments and stunning cinematography.', 9.1, '2024-03-12', 130, 10),
(166,17, 'An emotional rollercoaster that kept me hooked.', 9.0, '2024-03-25', 155, 6),
(167,8, 'A little predictable, but still enjoyable.', 7.8, '2024-04-01', 80, 15),
(168,6, 'One of the best installments of the season so far.', 9.4, '2024-04-10', 200, 3),
(169,14, 'Dialogue felt forced, but the visuals were top-notch.', 7.2, '2024-04-18', 75, 22),
(170,21, 'Perfectly paced with an unexpected twist!', 8.9, '2024-04-27', 145, 9),
(171,20, 'Great character development in this installment.', 8.7, '2024-05-02', 123, 11),
(172,18, 'Slow start, but the second half really delivers.', 7.6, '2024-05-14', 68, 19),
(173,4, 'Not as engaging as previous installments.', 6.9, '2024-05-20', 60, 30),
(174,22, 'An intense finale that ties up the storyline well.', 9.5, '2024-06-01', 210, 5),
(175,3, 'Beautifully directed with some memorable moments.', 8.6, '2024-06-10', 115, 12),
(176,12, 'The story arc took an interesting turn.', 8.2, '2024-06-18', 95, 14),
(177,23, 'Disappointed with the lack of character growth.', 6.5, '2024-06-25', 55, 33),
(178,15, 'Great acting, but the storyline feels recycled.', 7.4, '2024-07-02', 78, 20),
(179,2, 'A suspenseful installment with a satisfying ending.', 8.8, '2024-07-10', 132, 8),
(180,13, 'An average installment; it didn’t live up to the hype.', 6.7, '2024-07-15', 54, 29),
(181,10, 'The writing felt rushed, but the cast did their best.', 6.8, '2024-07-18', 57, 25),
(182,1, 'A powerful message conveyed with impressive storytelling.', 9.2, '2024-07-23', 150, 5),
(183,5, 'The installment had me on the edge of my seat!', 9.0, '2024-07-25', 175, 4),
(184,14, 'A visually stunning installment, though the plot was thin.', 8.0, '2024-07-30', 112, 18),
(185,21, 'Good installment, but it lacked the energy of previous ones.', 7.0, '2024-08-03', 68, 22),
(186,8, 'Brought tears to my eyes; very moving installment.', 9.3, '2024-08-08', 180, 6),
(187,18, 'A plot twist that was both shocking and well-executed.', 8.9, '2024-08-12', 140, 10),
(188,4, 'Disappointing ending to an otherwise solid installment.', 6.9, '2024-08-15', 62, 27),
(189,17, 'An epic conclusion to an amazing story arc.', 9.6, '2024-08-20', 200, 5),
(190,15, 'A slow build-up, but it paid off in the end.', 8.3, '2024-08-23', 107, 16),
(191,10, 'The narrative keeps getting better and better.', 9.2, '2024-08-27', 160, 4),
(192,22, 'Fantastic action scenes, though a bit over the top.', 8.1, '2024-08-30', 113, 13),
(193,3, 'Lacked substance, but it was still entertaining.', 7.2, '2024-09-02', 75, 25),
(194,11, 'A perfect balance of drama and suspense.', 9.4, '2024-09-05', 172, 6),
(195,9, 'An underwhelming installment that felt like filler.', 6.5, '2024-09-09', 55, 30),
(196,24, 'Incredible installment with high emotional stakes.', 9.5, '2024-09-12', 190, 8),
(197,16, 'Amazing visuals, but the story felt repetitive.', 7.9, '2024-09-15', 89, 20),
(198,19, 'A shocking twist that changes everything!', 8.8, '2024-09-18', 150, 8),
(199,20, 'Lacked the depth of previous installments.', 6.8, '2024-09-22', 60, 29),
(200,2, 'An absolute masterpiece from start to finish.', 9.7, '2024-09-25', 210, 3),
(201,23, 'The best installment so far this season!', 9.6, '2024-09-29', 198, 4),
(202,6, 'Great character growth and fantastic dialogue.', 8.7, '2024-10-02', 130, 11),
(203,12, 'The pacing was off, but it had great moments.', 7.5, '2024-10-06', 70, 24),
(204,7, 'A well-rounded installment with a satisfying payoff.', 8.6, '2024-10-09', 128, 10),
(205,13, 'Not the best installment, but it had its highlights.', 7.3, '2024-10-13', 78, 22),
(206,5, 'A deeply moving installment with powerful themes.', 9.4, '2024-10-17', 180, 7),
(207,1, 'Some predictable moments, but still enjoyable.', 7.6, '2024-10-20', 85, 17),
(208,18, 'A solid installment with excellent storytelling.', 8.5, '2024-10-23', 120, 9),
(209,15, 'An intense and gripping storyline.', 9.0, '2024-10-27', 165, 5),
(210,8, 'The climax was worth the build-up.', 8.9, '2024-10-30', 142, 8),
(211,22, 'A decent installment, though nothing special.', 7.0, '2024-11-01', 65, 21),
(212,19, 'Left me eagerly awaiting the next installment!', 9.1, '2024-11-03', 155, 6),
(213,5, 'A highly emotional storyline with great acting.', 9.2, '2024-11-06', 167, 5),
(214,23, 'Visually stunning but lacked plot depth.', 7.9, '2024-11-08', 85, 18),
(215,12, 'A flawless blend of action and drama.', 9.3, '2024-11-10', 178, 4),
(216,10, 'Felt like a filler installment, but it had its moments.', 6.7, '2024-11-12', 55, 29),
(217,3, 'The best installment of the season!', 9.8, '2024-11-14', 205, 3),
(218,16, 'An unexpected twist leaves a lasting impact.', 8.8, '2024-10-17', 150, 6),
(219,9, 'Great dialogue and character arcs.', 8.6, '2024-10-19', 130, 10),
(220,20, 'An ending that will stick with you.', 9.0, '2024-10-21', 175, 5),
(221,21, 'Disappointed with the direction the story took.', 6.6, '2024-10-24', 58, 26),
(222,9, 'A gripping installment with unexpected turns!', 9.1, '2024-01-02', 132, 8),
(223,17, 'Stunning visuals but the storyline was lacking.', 7.5, '2024-01-05', 102, 15),
(224,7, 'Powerful performances and well-executed tension.', 8.8, '2024-01-07', 156, 9),
(225,8, 'An emotional journey with high stakes.', 9.3, '2024-01-10', 189, 6),
(226,22, 'Brilliant pacing and fantastic direction.', 8.6, '2024-01-14', 143, 7),
(227,2, 'A beautiful blend of drama and suspense.', 8.4, '2024-01-16', 121, 10),
(228,19, 'A bit slow but a rewarding payoff in the end.', 7.8, '2024-01-18', 87, 20),
(229,20, 'The humor was spot on and lifted the installment.', 8.2, '2024-01-20', 132, 12),
(230,11, 'An intense installment with a shocking twist.', 9.2, '2024-01-23', 167, 4),
(231,3, 'Dialogue felt forced but the visuals made up for it.', 6.7, '2024-01-25', 98, 22),
(232,23, 'Heartwarming and tragic in equal measure.', 8.9, '2024-01-28', 155, 11),
(233,21, 'An innovative storyline that felt fresh.', 9.4, '2024-01-30', 192, 5),
(234,5, 'Some predictable moments, but still engaging.', 7.3, '2024-02-01', 95, 18),
(235,6, 'A slow burn that pays off with a big reveal.', 8.5, '2024-02-05', 110, 8),
(236,16, 'Action-packed and full of thrills!', 8.7, '2024-02-07', 159, 12),
(237,14, 'Great plot development and character arcs.', 9.0, '2024-02-09', 148, 6),
(238,10, 'Touching moments and a well-paced installment.', 8.1, '2024-02-11', 130, 9),
(239,1, 'The ending felt rushed, but it was still good.', 7.9, '2024-02-13', 111, 17),
(240,18, 'Unexpectedly emotional and deeply moving.', 9.3, '2024-02-15', 174, 5),
(241,24, 'A bit of a filler installment, but it had charm.', 6.9, '2024-02-18', 97, 21),
(242,4, 'Compelling from start to finish!', 9.1, '2024-02-21', 185, 3),
(243,12, 'The tension kept me on the edge of my seat.', 8.8, '2024-02-23', 162, 7),
(244,15, 'A fantastic balance of humor and drama.', 8.6, '2024-02-26', 143, 8),
(245,13, 'Predictable, but the acting was stellar.', 7.5, '2024-02-28', 114, 16),
(246,16, 'The storytelling here is truly top-notch.', 9.2, '2024-03-02', 170, 6),
(247,21, 'An impressive installment with clever dialogue.', 8.4, '2024-03-05', 145, 8),
(248,11, 'Underwhelming installment, but a few great scenes.', 6.8, '2024-03-07', 99, 24),
(249,24, 'A powerful conclusion to a thrilling arc.', 9.3, '2024-03-10', 190, 4),
(250,10, 'Some pacing issues, but overall well-done.', 7.7, '2024-03-12', 108, 19),
(251,2, 'An emotional rollercoaster that’s unforgettable.', 9.0, '2024-03-14', 176, 5),
(252,13, 'Good character moments, though a bit slow.', 7.8, '2024-03-16', 122, 13),
(253,20, 'Intense scenes and unexpected twists.', 8.9, '2024-03-18', 151, 6),
(254,23, 'A riveting experience with breathtaking visuals.', 9.1, '2024-03-21', 183, 7),
(255,9, 'A mix of suspense and well-timed humor.', 8.5, '2024-03-24', 147, 9),
(256,6, 'Felt like filler but had a few great lines.', 6.6, '2024-03-26', 85, 28),
(257,5, 'A thrilling installment with strong character arcs.', 9.2, '2024-03-28', 168, 6),
(258,19, 'Beautifully crafted and deeply resonant.', 9.5, '2024-04-01', 201, 3),
(259,4, 'Predictable storyline but entertaining enough.', 7.4, '2024-04-03', 103, 15),
(260,22, 'Great mix of action and character moments.', 8.7, '2024-04-06', 158, 8),
(261,12, 'Slow start but the climax was brilliant.', 8.3, '2024-04-08', 139, 12),
(262,8, 'Underwhelming, but well-shot scenes.', 6.9, '2024-04-11', 90, 22),
(263,7, 'A brilliant installment with amazing visuals.', 9.0, '2024-04-13', 170, 5),
(264,1, 'Could have been better, but worth the watch.', 7.2, '2024-04-15', 99, 19),
(265,14, 'A perfect blend of humor and action.', 8.9, '2024-04-18', 155, 10),
(266,17, 'The suspense was palpable throughout.', 9.2, '2024-04-20', 187, 4),
(267,15, 'The plot twist was jaw-dropping!', 9.4, '2024-04-23', 199, 2),
(268,3, 'Solid installment but lacked real tension.', 7.6, '2024-04-25', 108, 16),
(269,18, 'A heartwarming installment with great music.', 8.8, '2024-04-27', 153, 11),
(270,14, 'Decent action, but the plot was predictable.', 7.3, '2024-04-29', 104, 18),
(271,22, 'An amazing performance by the lead actors.', 9.1, '2024-05-01', 171, 6),
(272,18, 'Beautifully shot and wonderfully acted.', 8.9, '2024-05-03', 160, 9),
(273,2, 'Not the best installment, but some great moments.', 7.0, '2024-05-05', 96, 21),
(274,19, 'A slow installment that builds up nicely.', 8.3, '2024-05-08', 141, 12),
(275,1, 'Good installment but could have been better.', 7.7, '2024-05-10', 113, 20),
(276,23, 'A standout installment with emotional depth.', 9.0, '2024-05-12', 173, 8),
(277,17, 'Somewhat cliche, but well-executed scenes.', 7.9, '2024-05-14', 123, 17),
(278,6, 'Tense moments and a surprising twist.', 8.6, '2024-05-17', 150, 11),
(279,3, 'Amazing visual effects and a solid story.', 9.3, '2024-05-19', 181, 5),
(280,11, 'A bit slow but strong character moments.', 8.2, '2024-05-22', 128, 13),
(281,24, 'Over-the-top action, but it works well.', 8.7, '2024-05-24', 159, 10),
(282,16, 'Lacked depth, but visually spectacular.', 7.4, '2024-05-26', 103, 20),
(283,10, 'A thrilling adventure from start to finish.', 9.5, '2024-05-28', 200, 4),
(284,21, 'Great storytelling and an intense climax.', 9.0, '2024-05-31', 174, 8),
(285,7, 'A bit disappointing, but had some great acting.', 6.8, '2024-06-02', 89, 25),
(286,20, 'The humor was a nice touch to the story.', 8.1, '2024-06-04', 129, 11),
(287,4, 'An outstanding installment with a powerful message.', 9.2, '2024-06-06', 182, 6),
(288,5, 'A somewhat predictable but enjoyable plot.', 7.5, '2024-06-08', 102, 18),
(289,12, 'A rollercoaster of emotions!', 9.1, '2024-06-11', 168, 7),
(290,13, 'Impressive story with a memorable soundtrack.', 8.8, '2024-06-13', 157, 9),
(291,9, 'Great direction but the plot was lacking depth.', 7.6, '2024-06-15', 110, 20),
(292,8, 'A wonderfully intense installment!', 9.0, '2024-06-17', 176, 5),
(293,15, 'Some minor flaws but overall a solid installment.', 8.2, '2024-06-19', 130, 12),
(294,23, 'Unforgettable moments and top-notch acting.', 9.3, '2024-06-21', 180, 4),
(295,9, 'A captivating story with stunning visuals.', 9.0, '2024-01-15', 120, 5);


INSERT INTO Streaming_Sites (Site_ID, Site_Name, Site_URL, Subscription_Starting_Price) VALUES
(1, 'Netflix', 'https://www.netflix.com', 9.99),
(2, 'Amazon Prime Video', 'https://www.primevideo.com', 8.99),
(3, 'Disney+', 'https://www.disneyplus.com', 7.99),
(4, 'Hulu', 'https://www.hulu.com', 5.99),
(5, 'HBO Max', 'https://www.hbomax.com', 9.99),
(6, 'Apple TV+', 'https://www.apple.com/tv/', 4.99),
(7, 'Peacock', 'https://www.peacocktv.com', 4.99),
(8, 'Paramount+', 'https://www.paramountplus.com', 5.99),
(9, 'Discovery+', 'https://www.discoveryplus.com', 4.99),
(10, 'YouTube Premium', 'https://www.youtube.com/premium', 11.99);

INSERT INTO movieIsOfGenre (Movie_ID, Genre_ID) VALUES
(1, 1), (1, 5), (1, 9),      -- Inception: Action, Fantasy, Sci-Fi
(2, 1), (2, 8),              -- The Dark Knight: Action, Romance
(3, 1), (3, 9),              -- The Matrix: Action, Sci-Fi
(4, 2), (4, 5), (4, 9),      -- Avatar: Adventure, Fantasy, Sci-Fi
(5, 4), (5, 8),              -- Titanic: Drama, Romance
(6, 4),                      -- The Shawshank Redemption: Drama
(7, 4), (7, 7),              -- The Godfather: Drama, Mystery
(8, 2), (8, 5),              -- Star Wars: Episode IV - A New Hope: Adventure, Fantasy
(9, 2), (9, 9),              -- Jurassic Park: Adventure, Sci-Fi
(10, 5), (10, 12),           -- The Lion King: Fantasy, Animation
(11, 5), (11, 12),           -- Finding Nemo: Fantasy, Animation
(12, 3), (12, 12),           -- Toy Story: Comedy, Animation
(13, 4), (13, 7),            -- The Godfather: Part II: Drama, Mystery
(14, 5), (14, 12),           -- Finding Dory: Fantasy, Animation
(15, 2), (15, 5), (15, 9),   -- Star Wars: Episode V - The Empire Strikes Back: Adventure, Fantasy, Sci-Fi
(16, 1), (16, 2),            -- Mad Max: Fury Road: Action, Adventure
(17, 5), (17, 12),           -- Frozen II: Fantasy, Animation
(18, 2), (18, 3), (18, 5),   -- Jumanji: Welcome to the Jungle: Adventure, Comedy, Fantasy
(19, 1), (19, 3),            -- Deadpool: Action, Comedy
(20, 1), (20, 5), (20, 9),   -- Guardians of the Galaxy: Action, Fantasy, Sci-Fi
(21, 1), (21, 9),            -- Spider-Man: No Way Home: Action, Sci-Fi
(22, 1), (22, 4), (22, 5),   -- Black Panther: Action, Drama, Fantasy
(23, 4),                     -- Parasite: Drama
(24, 7), (24, 10),           -- The Silence of the Lambs: Mystery, Thriller
(25, 1), (25, 9),            -- The Avengers: Action, Sci-Fi
(26,1),(26,9),(26,7),         -- The Matrix Reloaded: Action, Sci-Fi, Mystery
(27,2),(27,5),(27,9),         -- Avatar: The Way of Water: Adventure, Fantasy, Sci-Fi
(28,1),(28,5),(28,3),(28,2),
(29,4),(29,10),
(30,2),(30,3),(30,7),(30,9),(30,12),
(31,4),(31,8),(31,11),
(32,5),(32,6),(32,7),(32,10),(32,2),
(33,11),(33,3),(33,4),
(34,4),(34,10),
(35,3),(35,4),
(36,1),(36,4),(36,7),
(37,1),(37,2),(37,8),(37,10),
(38,8),(38,10),(38,4),
(39,12),(39,5),(39,2),(39,4),
(40,4),
(41,4),(41,3),
(42,4),(42,10),
(43,1),(43,6),(43,10);


INSERT INTO showIsOfGenre (Show_ID, Genre_ID) VALUES
(1, 4),  -- Breaking Bad (Drama)
(1, 10), -- Breaking Bad (Thriller)
(2, 4),  -- Game of Thrones (Drama)
(2, 2),  -- Game of Thrones (Adventure)
(2, 1),  -- Game of Thrones (Action)
(2,5),
(3, 7),  -- Stranger Things (Mystery)
(3, 6),  -- Stranger Things (Horror)
(4, 4),  -- The Crown (Drama)
(5, 5),  -- The Mandalorian (Fantasy)
(5,1),
(5,2),
(6, 3),  -- The Office (US) (Comedy)
(6,4),
(6,5),
(7, 3),  -- Friends (Comedy)
(7,8),
(8, 3),  -- The Simpsons (Comedy)
(9, 7),  -- Sherlock (Mystery)
(9,2),
(10, 5), -- The Witcher (Fantasy)
(10,1),
(10,2),
(10,4),
(11, 3), -- The Big Bang Theory (Comedy)
(11,8),
(12, 4), -- The Handmaid's Tale (Drama)
(13, 5), -- Westworld (Fantasy)
(14, 10),-- Money Heist (Thriller)
(14, 7),
(15, 4), -- The Queen's Gambit (Drama)
(16,5),
(16,3),(16,2),(16,1),
(17,1),(17,2),(17,4),(17,5),(17,6),(17,7),(17,10),(17,12),
(18,1),(18,3),(18,4),(18,10),
(19,1),(19,4),(19,7),(19,10),
(20,12),(20,5),(20,4),(20,1),(20,2);



INSERT INTO movieDirectedBy (Movie_ID, Director_ID) VALUES
(1,21),
(2,21),
(3,23),(3,24),
(4,25),
(5,25),
(6,31),
(7,36),
(8,40),
(9,44),
(10,48),
(11,52),
(12,55),
(13,36),
(14,52),
(15,40),
(16,59),
(17,65),
(18,65),
(19,59),
(20,70),
(21,70),
(22,70),
(23,79),
(24,48),
(25,70),
(26,23),(26,24),
(27,25),
(28,85),
(29,36),
(30,55),
(31,89),
(32,91),
(33,93),
(34,96),
(35,99),
(36,100),
(37,103),
(38,103),
(39,108),
(40,111),
(41,114),
(42,119),
(43,122);


INSERT INTO showDirectedBy (Show_ID, Director_ID) VALUES
(1,125),
(2,129),
(3,136),
(4,141),
(5,145),
(6,149),
(7,155),
(8,159),
(9,163),(9,164),
(10,167),
(11,171),
(12,59),
(13,178),
(14,182),
(15,189),
(16,70),
(17,196),
(18,203),
(19,209),
(20,216);


INSERT INTO episodeDirectedBy (Show_ID, Episode_Number, Season_Number, Director_ID) VALUES
-- Show 1: Breaking Bad
(1,1,1,125),
(1,2,1,125),
(1,3,1,125),
(1,4,1,125),
(1,5,1,125),
(1,1,4,125),
(1,11,4,125),
(1,13,4,125),
(1,13,5,125),
(1,14,5,125),
(1,15,5,125),
(1,16,5,125),

-- Show 2: Game Of Thrones
(2,1,1,129),
(2,2,1,129),
(2,3,1,129),
(2,4,1,129),
(2,3,8,129),
(2,4,8,129),
(2,5,8,129),
(2,6,8,129),

-- Show 3: Stranger Things
(3,1,1,136),
(3,2,1,136),
(3,3,1,136),
(3,4,1,136),
(3,6,4,136),
(3,7,4,136),
(3,8,4,136),
(3,9,4,136),

-- Show 4: The Crown
(4, 1, 1, 141),
(4, 2, 1, 141),
(4, 3, 1, 141),
(4, 1, 2, 141),
(4, 2, 2, 141),
(4, 8, 6, 141),
(4, 9, 6, 141),
(4, 10, 6,141),

-- Show 5:  The Mandalorian
(5, 1, 1,145),
(5, 2, 1,145),
(5, 3, 1,145),
(5, 4, 1,145),
(5, 1, 2,145),
(5, 2, 2,145),
(5, 7, 3,145),
(5, 8, 3,145),

-- Show 6: The Office US
(6, 1, 1, 149),
(6, 2, 1, 149),
(6, 3, 1, 149),
(6, 4, 1, 149),
(6, 1, 2, 149),
(6, 2, 2, 149),
(6, 21, 9,149),
(6, 22, 9,149),
(6, 23, 9,149),

-- Show 7: Friends
(7, 1, 1, 155),
(7, 2, 1, 155),
(7, 3, 1, 155),
(7, 4, 1, 155),
(7, 1, 2, 155),
(7, 2, 2, 155),
(7, 17, 10,155),
(7, 18, 10,155),

-- Show 8: The Simpsons
(8, 1, 1, 159),
(8, 2, 1, 159),
(8, 1, 2, 159),
(8, 2, 2, 159),
(8, 1, 36,159),
(8, 2, 36,159),
(8, 3, 36,159),
(8, 4, 36,159),

-- Show 9: Sherlock
(9, 0, 1,163),
(9, 1, 1,163),
(9, 2, 1,163),
(9, 3, 1,164),
(9, 1, 2,164),
(9, 2, 2,163),
(9, 3, 2,164),
(9, 0, 3,164),
(9, 1, 3,163),
(9, 2, 3,163),
(9, 3, 3,164),

-- Show 10: The Witcher
(10, 1, 1,167),
(10, 2, 1,167),
(10, 3, 1,167),
(10, 4, 1,167),
(10, 1, 2,167),
(10, 2, 2,167),
(10, 6, 3,167),
(10, 7, 3,167),
(10, 8, 3,167),

-- Show 11: The Big Bang Theory
(11, 1, 1, 171),
(11, 2, 1, 171),
(11, 1, 2, 171),
(11, 2, 2, 171),
(11, 22, 12,171),
(11, 23, 12,171),
(11, 24, 12,171),

-- Show 12: The Handmaid's Tale
(12, 1, 1,59),
(12, 2, 1,59),
(12, 1, 2,59),
(12, 2, 2,59),
(12, 8, 5,59),
(12, 9, 5,59),

-- Show 13: Westworld
(13, 1, 1,178),
(13, 2, 1,178),
(13, 3, 1,178),
(13, 1, 2,178),
(13, 2, 2,178),
(13, 4, 2,178),

-- Show 14: Money Heist
(14, 1, 1, 182),
(14, 2, 1, 182),
(14, 3, 1, 182),
(14, 1, 2, 182),
(14, 2, 2, 182),
(14, 8, 5, 182),
(14, 9, 5, 182),
(14, 10, 5,182),

-- Show 15: The Queen's Gambit
(15, 1, 1, 189),
(15, 2, 1, 189),
(15, 3, 1, 189),
(15, 4, 1, 189),
(15, 5, 1, 189),
(15, 6, 1, 189),
(15, 7, 1, 189),

-- Show 16: Loki
(16, 1, 1, 70),
(16, 2, 1, 70),
(16, 3, 1, 70),
(16, 4, 1, 70),
(16, 3, 2, 70),
(16, 4, 2, 70),
(16, 5, 2, 70),
(16, 6, 2, 70),

-- Show 17: Attack On Titan
(17, 1, 1,  196),
(17, 2, 1,  196),
(17, 25, 1, 196),
(17, 6, 2,  196),
(17, 7, 2,  196),
(17, 12, 2, 196),
(17, 9, 3,  196),
(17, 11, 3, 196),
(17, 16, 3, 196),
(17, 17, 3, 196),
(17, 20, 4, 196),
(17, 21, 4, 196),
(17, 28, 4, 196),

-- Show 18: The Family Man
(18, 1, 1, 203),
(18, 2, 1, 203),
(18, 3, 1, 203),
(18, 6, 2, 203),
(18, 7, 2, 203),
(18, 8, 2, 203),
(18, 9, 2, 203),

-- Show 19: Squid Game
(19, 1, 1, 209),
(19, 2, 1, 209),
(19, 3, 1, 209),
(19, 4, 1, 209),
(19, 5, 1, 209),
(19, 6, 1, 209),
(19, 7, 1, 209),
(19, 8, 1, 209),
(19, 9, 1, 209),

-- Show 20: Arcane
(20, 1, 1, 216),
(20, 2, 1, 216),
(20, 3, 1, 216),
(20, 4, 1, 216),
(20, 5, 1, 216),
(20, 6, 1, 216),
(20, 7, 1, 216),
(20, 8, 1, 216),
(20, 9, 1, 216);

INSERT INTO movieProducedBy (Movie_ID, Producer_ID) VALUES
(1,21),(1,22),
(2,22),
(3,23),(3,24),
(4,25),(4,26),
(5,25),(5,26),
(6,31),(6,35),
(7,36), 
(8,40), 
(9,44),(9,45),
(10,48),
(11,52), 
(12,55),
(13,36),
(14,52), 
(15,40),
(16,59),
(17,65),
(18,65), 
(19,59),
(20,65),(20,70),
(21,70),
(22,70),
(23,79),
(24,52), 
(25,70),
(26,23),(26,24),
(27,24),(27,25),
(28,55),
(29,36),
(30,55),
(31,89),
(32,91),
(33,93),
(34,96),
(35,99),
(36,100),
(37,103),
(38,103),
(39,108),
(40,111),
(41,114),
(42,119),
(43,122);

INSERT INTO showProducedBy (Show_ID, Producer_ID) VALUES
(1,125),
(2,130),
(3,137),
(4,141),
(5,145),
(6,150),
(7,155),
(8,159),
(9,163),(9,164),
(10,167),
(11,171),
(12,59),
(13,178),
(14,182),
(15,188),
(16,70),
(17,197),
(18,204),
(19,209),
(20,217);

INSERT INTO episodeProducedBy (Show_ID, Episode_Number, Season_Number, Producer_ID) VALUES
-- Show 1: Breaking Bad
(1,1,1,125),
(1,2,1,125),
(1,3,1,125),
(1,4,1,125),
(1,5,1,125),
(1,1,4,125),
(1,11,4,125),
(1,13,4,125),
(1,13,5,125),
(1,14,5,125),
(1,15,5,125),
(1,16,5,125),

-- Show 2: Game Of Thrones
(2,1,1,130),
(2,2,1,130),
(2,3,1,130),
(2,4,1,130),
(2,3,8,130),
(2,4,8,130),
(2,5,8,130),
(2,6,8,130),

-- Show 3: Stranger Things
(3,1,1,137),
(3,2,1,137),
(3,3,1,137),
(3,4,1,137),
(3,6,4,137),
(3,7,4,137),
(3,8,4,137),
(3,9,4,137),

-- Show 4: The Crown
(4, 1, 1, 141),
(4, 2, 1, 141),
(4, 3, 1, 141),
(4, 1, 2, 141),
(4, 2, 2, 141),
(4, 8, 6, 141),
(4, 9, 6, 141),
(4, 10, 6,141),

-- Show 5:  The Mandalorian
(5, 1, 1,145),
(5, 2, 1,145),
(5, 3, 1,145),
(5, 4, 1,145),
(5, 1, 2,145),
(5, 2, 2,145),
(5, 7, 3,145),
(5, 8, 3,145),

-- Show 6: The Office US
(6, 1, 1, 150),
(6, 2, 1, 150),
(6, 3, 1, 150),
(6, 4, 1, 150),
(6, 1, 2, 150),
(6, 2, 2, 150),
(6, 21, 9,150),
(6, 22, 9,150),
(6, 23, 9,150),

-- Show 7: Friends
(7, 1, 1, 155),
(7, 2, 1, 155),
(7, 3, 1, 155),
(7, 4, 1, 155),
(7, 1, 2, 155),
(7, 2, 2, 155),
(7, 17, 10,155),
(7, 18, 10,155),

-- Show 8: The Simpsons
(8, 1, 1, 159),
(8, 2, 1, 159),
(8, 1, 2, 159),
(8, 2, 2, 159),
(8, 1, 36,159),
(8, 2, 36,159),
(8, 3, 36,159),
(8, 4, 36,159),

-- Show 9: Sherlock
(9, 0, 1,164),
(9, 1, 1,164),
(9, 2, 1,164),
(9, 3, 1,163),
(9, 1, 2,163),
(9, 2, 2,164),
(9, 3, 2,163),
(9, 0, 3,163),
(9, 1, 3,164),
(9, 2, 3,164),
(9, 3, 3,163),

-- Show 10: The Witcher
(10, 1, 1,167),
(10, 2, 1,167),
(10, 3, 1,167),
(10, 4, 1,167),
(10, 1, 2,167),
(10, 2, 2,167),
(10, 6, 3,167),
(10, 7, 3,167),
(10, 8, 3,167),

-- Show 11: The Big Bang Theory
(11, 1, 1, 171),
(11, 2, 1, 171),
(11, 1, 2, 171),
(11, 2, 2, 171),
(11, 22, 12,171),
(11, 23, 12,171),
(11, 24, 12,171),

-- Show 12: The Handmaid's Tale
(12, 1, 1,59),
(12, 2, 1,59),
(12, 1, 2,59),
(12, 2, 2,59),
(12, 8, 5,59),
(12, 9, 5,59),


-- Show 13: Westworld
(13, 1, 1,178),
(13, 2, 1,178),
(13, 3, 1,178),
(13, 1, 2,178),
(13, 2, 2,178),
(13, 4, 2,178),

-- Show 14: Money Heist
(14, 1, 1, 182),
(14, 2, 1, 182),
(14, 3, 1, 182),
(14, 1, 2, 182),
(14, 2, 2, 182),
(14, 8, 5, 182),
(14, 9, 5, 182),
(14, 10, 5,182),

-- Show 15: The Queen's Gambit
(15, 1, 1, 188),
(15, 2, 1, 188),
(15, 3, 1, 188),
(15, 4, 1, 188),
(15, 5, 1, 188),
(15, 6, 1, 188),
(15, 7, 1, 188),

-- Show 16: Loki
(16, 1, 1, 70),
(16, 2, 1, 70),
(16, 3, 1, 70),
(16, 4, 1, 70),
(16, 3, 2, 70),
(16, 4, 2, 70),
(16, 5, 2, 70),
(16, 6, 2, 70),

-- Show 17: Attack On Titan
(17, 1, 1,  197),
(17, 2, 1,  197),
(17, 25, 1, 197),
(17, 6, 2,  197),
(17, 7, 2,  197),
(17, 12, 2, 197),
(17, 9, 3,  197),
(17, 11, 3, 197),
(17, 16, 3, 197),
(17, 17, 3, 197),
(17, 20, 4, 197),
(17, 21, 4, 197),
(17, 28, 4, 197),

-- Show 18: The Family Man
(18, 1, 1, 204),
(18, 2, 1, 204),
(18, 3, 1, 204),
(18, 6, 2, 204),
(18, 7, 2, 204),
(18, 8, 2, 204),
(18, 9, 2, 204),

-- Show 19: Squid Game
(19, 1, 1, 209),
(19, 2, 1, 209),
(19, 3, 1, 209),
(19, 4, 1, 209),
(19, 5, 1, 209),
(19, 6, 1, 209),
(19, 7, 1, 209),
(19, 8, 1, 209),
(19, 9, 1, 209),

-- Show 20: Arcane
(20, 1, 1, 217),
(20, 2, 1, 217),
(20, 3, 1, 217),
(20, 4, 1, 217),
(20, 5, 1, 217),
(20, 6, 1, 217),
(20, 7, 1, 217),
(20, 8, 1, 217),
(20, 9, 1, 217);


INSERT INTO movieActedBy (Movie_ID, Actor_ID, Character_Number, Character_Name, Role_Type) VALUES
-- Movie 1: Inception
(1,1,1, 'Cobb', 'Male Lead'),
(1,2,2, 'Arthur', 'Supporting'),
(1,3,3, 'Ariadne', 'Female Lead'),
(1,4,4, 'Saito', 'Supporting'),

-- Movie 2: The Dark Knight
(2, 5, 1, 'Bruce Wayne', 'Male Lead'),
(2, 5, 2, 'Batman', 'Male Lead'),
(2, 6, 3, 'Joker', 'Antagonist'),
(2, 7, 4, 'Harvey Dent', 'Supporting'),
(2, 8, 5, 'Alfred', 'Supporting'),
(2, 9, 6, 'Rachel', 'Female Lead'),
(2, 10,7, 'Gordon', 'Supporting'),
(2, 11,8, 'Lucius Fox', 'Supporting'),

-- Movie 3: The Matrix
(3, 12, 1, 'Neo', 'Male Lead'),
(3, 13, 2, 'Morpheus', 'Supporting'),
(3, 14, 3, 'Trinity', 'Female Lead'),
(3, 15, 4, 'Oracle', 'Supporting'),

-- Movie 4: Avatar
(4, 16, 1, 'Jake Sully', 'Male Lead'),
(4, 17, 2, 'Neyitri', 'Female Lead'),
(4, 18, 3, 'Dr. Grace Augustine', 'Supporting'),
(4, 19, 4, 'Trudy Chacon', 'Supporting'),
(4, 20, 5, 'Colonel Miles', 'Antagonist'),

-- Movie 5: Titanic
(5, 1, 1, 'Jack Dawson', 'Male Lead'),
(5, 27, 2, 'Rose D.B', 'Female Lead'),
(5, 28, 3, 'Cal Hockley', 'Supporting'),

-- Movie 6: The Shawshank Redemption
(6, 11, 1, 'Ellis Boy Redding', 'Supporting'),
(6, 29, 2, 'Andy Dufresne', 'Male Lead'),
(6, 30, 3, 'Warden Nunton', 'Antagonist'),

-- Movie 7: The Godfather
(7, 32, 1, 'Don Vito Corleone', 'Male Lead'),
(7, 33, 2, 'Michael', 'Supporting'),
(7, 34, 3, 'Sonny', 'Supporting'),

-- Movie 8: Star Wars: Episode IV - A New Hope
(8, 37, 1, 'Luke Skywalker', 'Male Lead'),
(8, 38, 2, 'Han Solo', 'Supporting'),
(8, 39, 3, 'Princess Lela Organa', 'Female Lead'),

-- Movie 9: Jurassic Park
(9, 41, 1, 'Grant', 'Main cast'),
(9, 42, 2, 'Ellie', 'Main cast'),
(9, 43, 3, 'Malcolm', 'Main cast'),

-- Movie 10: The Lion King
(10, 46, 1, 'Simba(voice)', 'Protagonist'),
(10, 47, 2, 'Mufasa', 'Supporting'),

-- Movie 11: Finding Nemo
(11, 49, 1, 'Marlin(voice)', 'Main cast'),
(11, 50, 2, 'Dory(voice)', 'Main cast'),
(11, 51, 3, 'Nemo', 'Fish'),
(11, 165,4, 'Mr. Bailey(voice)', 'Supporting'),


-- Movie 12: Toy Story
(12, 53, 1, 'Woody(voice)', 'Supporting'),
(12, 54, 2, 'Buzz Lightyear', 'Main cast'),
(12, 162,3, 'Jesse(voice)', 'Main cast'),

-- Movie 13: godfather 2
(13, 33, 1, 'Michael', 'Male Lead'),
(13, 57, 2, 'Vito Corleone', 'Supporting'),
(13, 58, 3, 'Tom Hagen', 'Supporting'),

-- Movie 14: find dory
(14, 49, 1, 'Marlin(voice)', 'Main cast'),
(14, 50, 2, 'Dory(voice)', 'Main cast'),
(14, 165,3, 'Mr. Bailey(voice)', 'Supporting'),

-- Movie 15: star wars 5
(15, 37, 1, 'Luke Skywalker', 'Male Lead'),
(15, 38, 2, 'Han Solo', 'Supporting'),
(15, 39, 3, 'Princess Lela Organa', 'Female Lead'),

-- Movie 16: mad max fury road
(16, 60, 1, 'Max Rockatansky', 'Male Lead'),
(16, 61, 2, 'Imperator Furiosa', 'Female Lead'),

-- Movie 17: frozen 2
(17, 62, 1, 'Anna(voice)', 'Main cast'),
(17, 63, 2, 'Olaf(voice)', 'Snowman'),
(17, 64, 3, 'Elsa(voice)', 'Main cast'),

-- Movie 18: jumanji jungle
(18, 66, 1, 'Spencer', 'Male Lead'),
(18, 67, 2, 'Martha', 'Female Lead'),

-- Movie 19: dedpol
(19, 64, 1, 'Vanessa', 'Female Lead'),
(19, 66, 2, 'Weasel', 'Supporting'),
(19, 68, 3, 'Wade', 'Protagonist'),

-- Movie 20: Guardians of the Galaxy
(20, 69, 1, 'Peter Quill', 'Protagonist'),
(20, 60, 2, 'Groot(voice)', 'Main cast'),
(20, 41, 3, 'Rocket(voice)', 'Main cast'),
(20, 43, 4, 'Drax', 'Main cast'),

-- Movie 21: no way home
(21, 71, 1, 'Peter Parker', 'Protagonist'),
(21, 71, 2, 'Spiderman', 'Protagonist'),
(21, 72, 3, 'MJ', 'Female Lead'),
(21, 73, 4, 'Doctor Strange', 'Main cast'),

-- Movie 22: black panther
(22, 74, 1, 'T''Challa', 'Protagonist'),
(22, 75, 2, 'Eric Killmonger', 'Antagonist'),

-- Movie 23: Parasite
(23, 76, 1, 'Ki Taek', 'Protagonist'),
(23, 77, 2, 'Dong Ik', 'Supporting'),
(23, 78, 3, 'Yeon Kyo', 'Supporting'),
(23, 211, 4, 'Geun Se', 'Main cast'),

-- Movie 24: The Silence of the Lambs
(24, 80, 1, 'Clarice Starling', 'Protagonist'),
(24, 81, 2, 'Dr. Hannibal Lecter', 'Antagonist'),

-- Movie 25: The Avengers
(25, 82, 1, 'Tony Stark', 'Main cast'),
(25, 82, 2, 'Iron Man', 'Main cast'),
(25, 83, 3, 'Steve Rogers', 'Main cast'),
(25, 83, 4, 'Captain America', 'Main cast'),
(25, 84, 5, 'Natasha Romanoff', 'Main cast'),
(25, 84, 6, 'Black Widow', 'Main cast'),
(25, 193, 7, 'Loki', 'Antagonist'),

-- Movie 26: The Matrix Reloaded
(26, 12, 1, 'Neo', 'Male Lead'),
(26, 13, 2, 'Morpheus', 'Supporting'),
(26, 14, 3, 'Trinity', 'Female Lead'),

-- Movie 27: Avatar way of water
(27, 16, 1, 'Jake Sully', 'Male Lead'),
(27, 17, 2, 'Neyitri', 'Female Lead'),
(27, 18, 3, 'Dr. Grace Augustine', 'Supporting'),

-- Movie 28: The Last Airbender
(28, 86, 1, 'Aang', 'Protagonist'),
(28, 87, 2, 'Katara', 'Main cast'),

-- Movie 29: The Godfather Part III
(29, 33, 1, 'Michael', 'Main cast'),
(29, 88, 2, 'Kay Adamds', 'Main cast'),

-- Movie 30: Toy Story 2	
(30, 53, 1, 'Woody(voice)', 'Supporting'),
(30, 54, 2, 'Buzz Lightyear', 'Main cast'),
(30, 162,3, 'Jesse(voice)', 'Main cast'),

-- Movie 31: Mar adentro
(31, 90, 1, 'Ramon Sampedro', 'Protagonist'),
(31, 139, 2, 'Manuela''s son', 'Extra'),

-- Movie 32: fauno
(32, 92, 1, 'Ofelia', 'Female Lead'),

-- Movie 33: Intouchables
(33, 94, 1, 'Philippe', 'Antagonist'),
(33, 95, 2, 'Driss', 'Protagonist'),

-- Movie 34: Anatomie d'une chute
(34, 97, 1, 'Sandra Voyter', 'Antagonist'),

-- Movie 35: The Zone of Interest
(35, 97, 1, 'Hedwig Hoss', 'Main cast'),
(35, 98, 2, 'Rudolf Hoss', 'Main cast'),

-- Movie 36: Im Westen nichts Neues
(36, 101, 1, 'Paul Baumer', 'Protagonist'),
(36, 102, 2, 'Stanislaus Katczinsky', 'Main cast'),

-- Movie 37: Wo hu cang long
(37, 106, 1, 'Master Li Mu Bai', 'Male Lead'),
(37, 107, 2, 'Yu Shu Lien', 'Female Lead'),

-- Movie 38: Se, jie
(38, 104, 1, 'Mr. Yee', 'Antagonist'),
(38, 105, 2, 'Wong Chia Chi', 'Protagonist'),
(38, 142, 3, 'Foreign agent', 'Extra'),

-- Movie 39: Kimitachi wa dô ikiru ka
(39, 109, 1, 'Mahito Maki(voice)', 'Protagonist'),
(39, 110, 2, 'Kiriko(voice)', 'Supporting'),

-- Movie 40: Perfect Days
(40, 112, 1, 'Hirayama', 'Protagonist'),
(40, 113, 2, 'Takashi', 'Supporting'),
(40, 202, 3, 'Priest', 'Side character'),

-- Movie 41: 3 Idiots
(41, 115, 1, 'Ranchoddas Chanchad', 'Male Lead'),
(41, 116, 2, 'Farhan', 'Main cast'),
(41, 117, 3, 'Raju Rastogi', 'Main cast'),
(41, 118, 4, 'Pia', 'Female Lead'),

-- Movie 42: Lagaan: Once Upon a Time in India
(42, 115, 1, 'Bhuvan', 'Protagonist'),
(42, 120, 2, 'Bhura', 'Supporting'),
(42, 121, 3, 'Gauri', 'Female Lead'),

-- Movie 43: Busanhaeng
(43, 123, 1, 'Seok-Woo', 'Antagonist'),
(43, 124, 2, 'Seong-kyeong', 'Protagonist');

INSERT INTO showActedBy (Show_ID, Actor_ID, Character_Number, Character_Name, Role_Type) VALUES
-- Show 1: Breaking Bad
(1, 126, 1, 'Walter White', 'Lead'),
(1, 127, 2, 'Jesse Pinkman', 'Lead'),
(1, 128, 3, 'Skyler White', 'Supporting'),
(1, 113, 4, 'Gao', 'Side character'),

-- Show 2: Game of Thrones
(2, 131, 1, 'Daenerys Targaryen', 'Lead'),
(2, 132, 2, 'Tyrion Lannister', 'Main cast'),
(2, 133, 3, 'Sansa Stark', 'Supporting'),
(2, 134, 4, 'Bran Stark', 'Supporting'),
(2, 135, 5, 'Arya Stark', 'Main cast'),
(2, 38,  6, 'Jon Snow', 'Main cast'),
(2, 41,  7, 'Lord Varys', 'Supporting'),

-- Show 3: Stranger Things
(3, 138, 1, 'Eleven', 'Lead'),
(3, 139, 2, 'Finn Wolfhard', 'Main cast'),
(3, 140, 3, 'Maya Hawke', 'Supporting'),

-- Show 4: The Crown
(4, 142, 1, 'Queen Elizabeth II', 'Main cast'),
(4, 143, 2, 'Queen Elizabeth II(old)', 'Main cast'),
(4, 144, 3, 'Queen Elizabeth II(older)', 'Main cast'),

-- Show 5: The Mandalorian
(5, 146, 1, 'The Mandalorian', 'Protagonist'),
(5, 147, 2, 'Nevarro', 'Supporting'),
(5, 148, 3, 'Bo-Katan Kryze', 'Extra'),

-- Show 6: The Office US
(6, 151, 1, 'Michael Scott', 'Lead'),
(6, 152, 2, 'Pam Beasly', 'Main cast'),
(6, 153, 3, 'Jim Halpert', 'Main cast'),
(6, 154, 4, 'Dwight Schrute', 'Main character'), -- Best girl
(6,  86, 5, 'Roy', 'Side character'),

-- Show 7: Friends
(7, 156, 1, 'Rachel', 'Main cast'),
(7, 157, 2, 'Joey Tribbiani', 'Main cast'),
(7, 158, 3, 'Chandler', 'Main cast'),

-- Show 8: The Simpsons
(8, 160, 1, 'Homer Simpson', 'Main cast'),
(8, 161, 2, 'Bart Simpson', 'Main cast'),
(8, 162, 3, 'Marge Simpson', 'Main cast'),

-- Show 9: Sherlock
(9, 73,  1, 'Sherlock Holmes', 'Protagonist'),
(9, 163, 2, 'Mycroft Holmes', 'Supporting'),
(9, 165, 3, 'Dr. John Watson', 'Sidekick'),
(9, 166, 4, 'DI Lestrade', 'Supporting'),
(9, 47,  5, 'James Moriarty', 'Antagonist'),
(9, 63,  6, 'Sir Edwin', 'Side character'),

-- Show 10: The Witcher
(10, 168, 1, 'Geralt of Rivia', 'Protagonist'),
(10, 169, 2, 'Ciri', 'Main cast'),
(10, 170, 3, 'Yennefer', 'Main cast'),

-- Show 11: The Big Bang Theory
(11, 172, 1, 'Leonard Hofstadter', 'Main cast'),
(11, 173, 2, 'Sheldon Cooper', 'Protagonist'),
(11, 174, 3, 'Penny', 'Main cast'),

-- Show 12: The Handmaid's Tale
(12, 175, 1,'June Osborne', 'Lead'),
(12, 176, 2,'Serena Joy Waterford', 'Main cast'),
(12, 177, 3,'Aunt Lydia Clemens', 'Supporting'),

-- Show 13: Westworld
(13, 179, 1, 'Dolores Abernathy', 'Lead'),
(13, 180, 2, 'Bernard Lowe', 'Main cast'),
(13, 181, 3, 'Man in Black', 'Supporting'),

-- Show 14: Money Heist
(14, 183, 1, 'Tokio', 'Main cast'),
(14, 184, 2, 'El Profesor', 'Mastermind'),
(14, 185, 3, 'Raquel Murillo', 'Main cast'),
(14, 186, 4, 'Berlin', 'Lead'),
(14, 187, 5, 'Rio', 'Main Cast'),

-- Show 15: The Queen's Gambit
(15, 190, 1, 'Beth Harmon', 'Protagonist'),
(15, 191, 2, 'Vasily Borgov', 'Antagonist'),
(15, 192, 3, 'Harry Beltik', 'Supporting'),
(15, 1, 4, 'Mr. Shaibel', 'Supporting'),
(15, 32, 5, 'Allston Wheatley', 'Extra'),

-- Show 16: Loki
(16, 193, 1, 'Loki', 'Lead'),
(16, 194, 2, 'Mobius', 'Antagonist'),
(16, 195, 3, 'Sylvie', 'Main cast'),

-- Show 17: Attack On Titan
(17, 198, 1, 'Eren Yaeger(voice)', 'Protagonist'),
(17, 199, 2, 'Mikasa Ackermann', 'Main cast'),
(17, 200, 3, 'Armin Arlert', 'Main cast'),
(17, 201, 5, 'Reiner Braun', 'Antagonist'),
(17, 202, 6, 'Floch Forster', 'Antagonist'),

-- Show 18: The Family Man
(18, 205, 1, 'Srikant Tiwari', 'Lead'),
(18, 206, 2, 'JK Talpade', 'Main cast'),
(18, 207, 3, 'Dhriti', 'Supporting'),
(18, 208, 4, 'Atharv', 'Supporting'),

-- Show 19: Squid Game
(19, 210, 1, 'Seong Gi-hun', 'Protagonist'),
(19, 211, 2, 'Cho Sang-woo', 'Minor antagonist'),
(19, 212, 3, 'Nandito', 'Supporting'),

-- Show 20: Arcane
(20, 213, 1, 'Vi', 'Protagonist'),
(20, 214, 2, 'Silco', 'Minor antagonist'),
(20, 215, 3, 'Powder', 'Antagonist');


INSERT INTO episodeActedBy (Show_ID, Episode_Number, Season_Number, Actor_ID, Character_Number, Character_Name, Role_Type) VALUES
-- Show 1: Breaking Bad
(1,1,1, 126, 1, 'Walter White', 'Lead'),
(1,1,1, 127, 2, 'Jesse Pinkman', 'Lead'),
(1,1,1, 128, 3, 'Skyler White', 'Supporting'),

(1,2,1, 126, 1, 'Walter White', 'Lead'),
(1,2,1, 127, 2, 'Jesse Pinkman', 'Lead'),
(1,2,1, 128, 3, 'Skyler White', 'Supporting'),

(1,3,1, 126, 1, 'Walter White', 'Lead'),
(1,3,1, 127, 2, 'Jesse Pinkman', 'Lead'),
(1,3,1, 128, 3, 'Skyler White', 'Supporting'),

(1,4,1, 126, 1, 'Walter White', 'Lead'),
(1,4,1, 127, 2, 'Jesse Pinkman', 'Lead'),
(1,4,1, 128, 3, 'Skyler White', 'Supporting'),

(1,5,1, 126, 1, 'Walter White', 'Lead'),
(1,5,1, 127, 2, 'Jesse Pinkman', 'Lead'),
(1,5,1, 128, 3, 'Skyler White', 'Supporting'),

(1,1,4, 126, 1, 'Walter White', 'Lead'),
(1,1,4, 127, 2, 'Jesse Pinkman', 'Lead'),
(1,1,4, 128, 3, 'Skyler White', 'Supporting'),
(1,1,4, 113, 4, 'Gao', 'Side character'),

(1,11,4, 126, 1, 'Walter White', 'Lead'),
(1,11,4, 127, 2, 'Jesse Pinkman', 'Lead'),
(1,11,4, 128, 3, 'Skyler White', 'Supporting'),

(1,13,4, 126, 1, 'Walter White', 'Lead'),
(1,13,4, 127, 2, 'Jesse Pinkman', 'Lead'),
(1,13,4, 128, 3, 'Skyler White', 'Supporting'),

(1,13,5, 126, 1, 'Walter White', 'Lead'),
(1,13,5, 127, 2, 'Jesse Pinkman', 'Lead'),
(1,13,5, 128, 3, 'Skyler White', 'Supporting'),

(1,14,5, 126, 1, 'Walter White', 'Lead'),
(1,14,5, 127, 2, 'Jesse Pinkman', 'Lead'),
(1,14,5, 128, 3, 'Skyler White', 'Supporting'),

(1,15,5, 126, 1, 'Walter White', 'Lead'),
(1,15,5, 127, 2, 'Jesse Pinkman', 'Lead'),
(1,15,5, 128, 3, 'Skyler White', 'Supporting'),

(1,16,5, 126, 1, 'Walter White', 'Lead'),
(1,16,5, 127, 2, 'Jesse Pinkman', 'Lead'),
(1,16,5, 128, 3, 'Skyler White', 'Supporting'),

-- Show 2: Game Of Thrones
(2,1,1, 131, 1, 'Daenerys Targaryen', 'Lead'),
(2,1,1, 132, 2, 'Tyrion Lannister', 'Main cast'),
(2,1,1, 133, 3, 'Sansa Stark', 'Supporting'),
(2,1,1, 134, 4, 'Bran Stark', 'Supporting'),
(2,1,1, 135, 5, 'Arya Stark', 'Main cast'),
(2,1,1, 38,  6, 'Jon Snow', 'Main cast'),
(2,1,1, 41,  7, 'Lord Varys', 'Supporting'),

(2,2,1, 131, 1, 'Daenerys Targaryen', 'Lead'),
(2,2,1, 132, 2, 'Tyrion Lannister', 'Main cast'),
(2,2,1, 133, 3, 'Sansa Stark', 'Supporting'),
(2,2,1, 134, 4, 'Bran Stark', 'Supporting'),
(2,2,1, 135, 5, 'Arya Stark', 'Main cast'),
(2,2,1, 38,  6, 'Jon Snow', 'Main cast'),
(2,2,1, 41,  7, 'Lord Varys', 'Supporting'),

(2,3,1, 131, 1, 'Daenerys Targaryen', 'Lead'),
(2,3,1, 132, 2, 'Tyrion Lannister', 'Main cast'),
(2,3,1, 133, 3, 'Sansa Stark', 'Supporting'),
(2,3,1, 134, 4, 'Bran Stark', 'Supporting'),
(2,3,1, 135, 5, 'Arya Stark', 'Main cast'),

(2,4,1, 131, 1, 'Daenerys Targaryen', 'Lead'),
(2,4,1, 132, 2, 'Tyrion Lannister', 'Main cast'),
(2,4,1, 133, 3, 'Sansa Stark', 'Supporting'),
(2,4,1, 134, 4, 'Bran Stark', 'Supporting'),
(2,4,1, 135, 5, 'Arya Stark', 'Main cast'),
(2,4,1, 38,  6, 'Jon Snow', 'Main cast'),
(2,4,1, 41,  7, 'Lord Varys', 'Supporting'),

(2,3,8, 131, 1, 'Daenerys Targaryen', 'Lead'),
(2,3,8, 132, 2, 'Tyrion Lannister', 'Main cast'),
(2,3,8, 133, 3, 'Sansa Stark', 'Supporting'),
(2,3,8, 134, 4, 'Bran Stark', 'Supporting'),
(2,3,8, 135, 5, 'Arya Stark', 'Main cast'),
(2,3,8, 38,  6, 'Jon Snow', 'Main cast'),

(2,4,8, 131, 1, 'Daenerys Targaryen', 'Lead'),
(2,4,8, 132, 2, 'Tyrion Lannister', 'Main cast'),
(2,4,8, 133, 3, 'Sansa Stark', 'Supporting'),
(2,4,8, 134, 4, 'Bran Stark', 'Supporting'),
(2,4,8, 135, 5, 'Arya Stark', 'Main cast'),

(2,5,8, 131, 1, 'Daenerys Targaryen', 'Lead'),
(2,5,8, 132, 2, 'Tyrion Lannister', 'Main cast'),
(2,5,8, 133, 3, 'Sansa Stark', 'Supporting'),
(2,5,8, 134, 4, 'Bran Stark', 'Supporting'),
(2,5,8, 135, 5, 'Arya Stark', 'Main cast'),
(2,5,8, 38,  6, 'Jon Snow', 'Main cast'),
(2,5,8, 41,  7, 'Lord Varys', 'Supporting'),

(2,6,8, 131, 1, 'Daenerys Targaryen', 'Lead'),
(2,6,8, 132, 2, 'Tyrion Lannister', 'Main cast'),
(2,6,8, 133, 3, 'Sansa Stark', 'Supporting'),
(2,6,8, 134, 4, 'Bran Stark', 'Supporting'),
(2,6,8, 135, 5, 'Arya Stark', 'Main cast'),

-- Show 3: Stranger Things
(3,1,1, 138, 1, 'Eleven', 'Lead'),
(3,1,1, 139, 2, 'Finn Wolfhard', 'Main cast'),
(3,1,1, 140, 3, 'Maya Hawke', 'Supporting'),

(3,2,1, 138, 1, 'Eleven', 'Lead'),
(3,2,1, 139, 2, 'Finn Wolfhard', 'Main cast'),
(3,2,1, 140, 3, 'Maya Hawke', 'Supporting'),

(3,3,1, 138, 1, 'Eleven', 'Lead'),
(3,3,1, 139, 2, 'Finn Wolfhard', 'Main cast'),
(3,3,1, 140, 3, 'Maya Hawke', 'Supporting'),

(3,4,1, 138, 1, 'Eleven', 'Lead'),
(3,4,1, 139, 2, 'Finn Wolfhard', 'Main cast'),
(3,4,1, 140, 3, 'Maya Hawke', 'Supporting'),

(3,6,4, 138, 1, 'Eleven', 'Lead'),
(3,6,4, 139, 2, 'Finn Wolfhard', 'Main cast'),
(3,6,4, 140, 3, 'Maya Hawke', 'Supporting'),

(3,7,4, 138, 1, 'Eleven', 'Lead'),
(3,7,4, 139, 2, 'Finn Wolfhard', 'Main cast'),
(3,7,4, 140, 3, 'Maya Hawke', 'Supporting'),

(3,8,4, 138, 1, 'Eleven', 'Lead'),
(3,8,4, 139, 2, 'Finn Wolfhard', 'Main cast'),
(3,8,4, 140, 3, 'Maya Hawke', 'Supporting'),

(3,9,4, 138, 1, 'Eleven', 'Lead'),
(3,9,4, 139, 2, 'Finn Wolfhard', 'Main cast'),
(3,9,4, 140, 3, 'Maya Hawke', 'Supporting'),

-- Show 4: The Crown
(4,1,1, 142, 1, 'Queen Elizabeth II', 'Main cast'),
(4,1,1, 143, 2, 'Queen Elizabeth II(old)', 'Main cast'),
(4,1,1, 144, 3, 'Queen Elizabeth II(older)', 'Main cast'),

(4,2,1, 142, 1, 'Queen Elizabeth II', 'Main cast'),
(4,2,1, 143, 2, 'Queen Elizabeth II(old)', 'Main cast'),
(4,2,1, 144, 3, 'Queen Elizabeth II(older)', 'Main cast'),

(4,3,1, 142, 1, 'Queen Elizabeth II', 'Main cast'),
(4,3,1, 143, 2, 'Queen Elizabeth II(old)', 'Main cast'),
(4,3,1, 144, 3, 'Queen Elizabeth II(older)', 'Main cast'),

(4,1,2, 142, 1, 'Queen Elizabeth II', 'Main cast'),
(4,1,2, 143, 2, 'Queen Elizabeth II(old)', 'Main cast'),
(4,1,2, 144, 3, 'Queen Elizabeth II(older)', 'Main cast'),

(4,2,2, 142, 1, 'Queen Elizabeth II', 'Main cast'),
(4,2,2, 143, 2, 'Queen Elizabeth II(old)', 'Main cast'),
(4,2,2, 144, 3, 'Queen Elizabeth II(older)', 'Main cast'),

(4,8,6, 142, 1, 'Queen Elizabeth II', 'Main cast'),
(4,8,6, 143, 2, 'Queen Elizabeth II(old)', 'Main cast'),
(4,8,6, 144, 3, 'Queen Elizabeth II(older)', 'Main cast'),

(4,9,6, 142, 1, 'Queen Elizabeth II', 'Main cast'),
(4,9,6, 143, 2, 'Queen Elizabeth II(old)', 'Main cast'),
(4,9,6, 144, 3, 'Queen Elizabeth II(older)', 'Main cast'),

(4,10,6, 142, 1, 'Queen Elizabeth II', 'Main cast'),
(4,10,6, 143, 2, 'Queen Elizabeth II(old)', 'Main cast'),
(4,10,6, 144, 3, 'Queen Elizabeth II(older)', 'Main cast'),

-- Show 5:  The Mandalorian
(5,1,1, 146, 1, 'The Mandalorian', 'Protagonist'),
(5,1,1, 147, 2, 'Nevarro', 'Supporting'),
(5,1,1, 148, 3, 'Bo-Katan Kryze', 'Extra'),

(5,2,1, 146, 1, 'The Mandalorian', 'Protagonist'),
(5,2,1, 147, 2, 'Nevarro', 'Supporting'),
(5,2,1, 148, 3, 'Bo-Katan Kryze', 'Extra'),

(5,3,1, 146, 1, 'The Mandalorian', 'Protagonist'),
(5,3,1, 147, 2, 'Nevarro', 'Supporting'),
(5,3,1, 148, 3, 'Bo-Katan Kryze', 'Extra'),

(5,4,1, 146, 1, 'The Mandalorian', 'Protagonist'),
(5,4,1, 147, 2, 'Nevarro', 'Supporting'),
(5,4,1, 148, 3, 'Bo-Katan Kryze', 'Extra'),

(5,1,2, 146, 1, 'The Mandalorian', 'Protagonist'),
(5,1,2, 147, 2, 'Nevarro', 'Supporting'),
(5,1,2, 148, 3, 'Bo-Katan Kryze', 'Extra'),

(5,2,2, 146, 1, 'The Mandalorian', 'Protagonist'),
(5,2,2, 147, 2, 'Nevarro', 'Supporting'),
(5,2,2, 148, 3, 'Bo-Katan Kryze', 'Extra'),

(5,7,3, 146, 1, 'The Mandalorian', 'Protagonist'),
(5,7,3, 147, 2, 'Nevarro', 'Supporting'),
(5,7,3, 148, 3, 'Bo-Katan Kryze', 'Extra'),

(5,8,3, 146, 1, 'The Mandalorian', 'Protagonist'),
(5,8,3, 147, 2, 'Nevarro', 'Supporting'),
(5,8,3, 148, 3, 'Bo-Katan Kryze', 'Extra'),


-- Show 6: The Office US
(6,1,1, 151, 1, 'Michael Scott', 'Lead'),
(6,1,1, 152, 2, 'Pam Beasly', 'Main cast'),
(6,1,1, 153, 3, 'Jim Halpert', 'Main cast'),
(6,1,1, 154, 4, 'Dwight Schrute', 'Main character'),
(6,1,1,  86, 5, 'Roy', 'Side character'),

(6,2,1, 151, 1, 'Michael Scott', 'Lead'),
(6,2,1, 152, 2, 'Pam Beasly', 'Main cast'),
(6,2,1, 153, 3, 'Jim Halpert', 'Main cast'),
(6,2,1, 154, 4, 'Dwight Schrute', 'Main character'),

(6,3,1, 151, 1, 'Michael Scott', 'Lead'),
(6,3,1, 152, 2, 'Pam Beasly', 'Main cast'),
(6,3,1, 153, 3, 'Jim Halpert', 'Main cast'),
(6,3,1, 154, 4, 'Dwight Schrute', 'Main character'),
(6,3,1,  86, 5, 'Roy', 'Side character'),

(6,4,1, 151, 1, 'Michael Scott', 'Lead'),
(6,4,1, 152, 2, 'Pam Beasly', 'Main cast'),
(6,4,1, 153, 3, 'Jim Halpert', 'Main cast'),
(6,4,1, 154, 4, 'Dwight Schrute', 'Main character'),

(6,1,2, 151, 1, 'Michael Scott', 'Lead'),
(6,1,2, 152, 2, 'Pam Beasly', 'Main cast'),
(6,1,2, 153, 3, 'Jim Halpert', 'Main cast'),
(6,1,2, 154, 4, 'Dwight Schrute', 'Main character'),
(6,1,2,  86, 5, 'Roy', 'Side character'),

(6,2,2, 151, 1, 'Michael Scott', 'Lead'),
(6,2,2, 152, 2, 'Pam Beasly', 'Main cast'),
(6,2,2, 153, 3, 'Jim Halpert', 'Main cast'),
(6,2,2, 154, 4, 'Dwight Schrute', 'Main character'),

(6,21,9, 151, 1, 'Michael Scott', 'Lead'),
(6,21,9, 152, 2, 'Pam Beasly', 'Main cast'),
(6,21,9, 153, 3, 'Jim Halpert', 'Main cast'),
(6,21,9, 154, 4, 'Dwight Schrute', 'Main character'),

(6,22,9, 151, 1, 'Michael Scott', 'Lead'),
(6,22,9, 152, 2, 'Pam Beasly', 'Main cast'),
(6,22,9, 153, 3, 'Jim Halpert', 'Main cast'),
(6,22,9, 154, 4, 'Dwight Schrute', 'Main character'),

(6,23,9, 151, 1, 'Michael Scott', 'Lead'),
(6,23,9, 152, 2, 'Pam Beasly', 'Main cast'),
(6,23,9, 153, 3, 'Jim Halpert', 'Main cast'),
(6,23,9, 154, 4, 'Dwight Schrute', 'Main character'),

-- Show 7: Friends
(7,1,1, 156, 1, 'Rachel', 'Main cast'),
(7,1,1, 157, 2, 'Joey Tribbiani', 'Main cast'),
(7,1,1, 158, 3, 'Chandler', 'Main cast'),

(7,2,1, 156, 1, 'Rachel', 'Main cast'),
(7,2,1, 157, 2, 'Joey Tribbiani', 'Main cast'),
(7,2,1, 158, 3, 'Chandler', 'Main cast'),

(7,3,1, 156, 1, 'Rachel', 'Main cast'),
(7,3,1, 157, 2, 'Joey Tribbiani', 'Main cast'),
(7,3,1, 158, 3, 'Chandler', 'Main cast'),

(7,4,1, 156, 1, 'Rachel', 'Main cast'),
(7,4,1, 157, 2, 'Joey Tribbiani', 'Main cast'),
(7,4,1, 158, 3, 'Chandler', 'Main cast'),

(7,1,2, 156, 1, 'Rachel', 'Main cast'),
(7,1,2, 157, 2, 'Joey Tribbiani', 'Main cast'),
(7,1,2, 158, 3, 'Chandler', 'Main cast'),

(7,2,2, 156, 1, 'Rachel', 'Main cast'),
(7,2,2, 157, 2, 'Joey Tribbiani', 'Main cast'),
(7,2,2, 158, 3, 'Chandler', 'Main cast'),

(7,17,10, 156, 1, 'Rachel', 'Main cast'),
(7,17,10, 157, 2, 'Joey Tribbiani', 'Main cast'),
(7,17,10, 158, 3, 'Chandler', 'Main cast'),

(7,18,10, 156, 1, 'Rachel', 'Main cast'),
(7,18,10, 157, 2, 'Joey Tribbiani', 'Main cast'),
(7,18,10, 158, 3, 'Chandler', 'Main cast'),

-- Show 8: The Simpsons
(8,1,1, 160, 1, 'Homer Simpson', 'Main cast'),
(8,1,1, 161, 2, 'Bart Simpson', 'Main cast'),
(8,1,1, 162, 3, 'Marge Simpson', 'Main cast'),

(8,2,1, 160, 1, 'Homer Simpson', 'Main cast'),
(8,2,1, 161, 2, 'Bart Simpson', 'Main cast'),
(8,2,1, 162, 3, 'Marge Simpson', 'Main cast'),

(8,1,2, 160, 1, 'Homer Simpson', 'Main cast'),
(8,1,2, 161, 2, 'Bart Simpson', 'Main cast'),
(8,1,2, 162, 3, 'Marge Simpson', 'Main cast'),

(8,2,2, 160, 1, 'Homer Simpson', 'Main cast'),
(8,2,2, 161, 2, 'Bart Simpson', 'Main cast'),
(8,2,2, 162, 3, 'Marge Simpson', 'Main cast'),

(8,1,36, 160, 1, 'Homer Simpson', 'Main cast'),
(8,1,36, 161, 2, 'Bart Simpson', 'Main cast'),
(8,1,36, 162, 3, 'Marge Simpson', 'Main cast'),

(8,2,36, 160, 1, 'Homer Simpson', 'Main cast'),
(8,2,36, 161, 2, 'Bart Simpson', 'Main cast'),
(8,2,36, 162, 3, 'Marge Simpson', 'Main cast'),

(8,3,36, 160, 1, 'Homer Simpson', 'Main cast'),
(8,3,36, 161, 2, 'Bart Simpson', 'Main cast'),
(8,3,36, 162, 3, 'Marge Simpson', 'Main cast'),

(8,4,36, 160, 1, 'Homer Simpson', 'Main cast'),
(8,4,36, 161, 2, 'Bart Simpson', 'Main cast'),
(8,4,36, 162, 3, 'Marge Simpson', 'Main cast'),

-- Show 9: Sherlock
(9,0,1, 73, 1, 'Sherlock Holmes', 'Protagonist'),
(9,0,1, 163, 2, 'Mycroft Holmes', 'Supporting'),
(9,0,1, 165, 3, 'Dr. John Watson', 'Sidekick'),
(9,0,1, 166, 4, 'DI Lestrade', 'Supporting'),

(9,1,1, 73, 1, 'Sherlock Holmes', 'Protagonist'),
(9,1,1, 163, 2, 'Mycroft Holmes', 'Supporting'),
(9,1,1, 165, 3, 'Dr. John Watson', 'Sidekick'),
(9,1,1, 166, 4, 'DI Lestrade', 'Supporting'),
(9,1,1,  47, 5, 'James Moriarty', 'Antagonist'),

(9,2,1, 73,  1, 'Sherlock Holmes', 'Protagonist'),
(9,2,1, 163, 2, 'Mycroft Holmes', 'Supporting'),
(9,2,1, 165, 3, 'Dr. John Watson', 'Sidekick'),
(9,2,1, 166, 4, 'DI Lestrade', 'Supporting'),
(9,2,1, 63,  5, 'Sir Edwin', 'Side character'),


(9,3,1, 73, 1, 'Sherlock Holmes', 'Protagonist'),
(9,3,1, 163, 2, 'Mycroft Holmes', 'Supporting'),
(9,3,1, 165, 3, 'Dr. John Watson', 'Sidekick'),
(9,3,1, 166, 4, 'DI Lestrade', 'Supporting'),
(9,3,1,  47, 5, 'James Moriarty', 'Antagonist'),

(9,1,2, 73, 1, 'Sherlock Holmes', 'Protagonist'),
(9,1,2, 163, 2, 'Mycroft Holmes', 'Supporting'),
(9,1,2, 165, 3, 'Dr. John Watson', 'Sidekick'),
(9,1,2, 166, 4, 'DI Lestrade', 'Supporting'),
(9,1,2, 63,  5, 'Sir Edwin', 'Side character'),


(9,2,2, 73, 1, 'Sherlock Holmes', 'Protagonist'),
(9,2,2, 163, 2, 'Mycroft Holmes', 'Supporting'),
(9,2,2, 165, 3, 'Dr. John Watson', 'Sidekick'),
(9,2,2, 166, 4, 'DI Lestrade', 'Supporting'),
(9,2,2,  47, 5, 'James Moriarty', 'Antagonist'),
(9,2,2, 63,  6, 'Sir Edwin', 'Side character'),


(9,3,2, 73, 1, 'Sherlock Holmes', 'Protagonist'),
(9,3,2, 163, 2, 'Mycroft Holmes', 'Supporting'),
(9,3,2, 165, 3, 'Dr. John Watson', 'Sidekick'),
(9,3,2, 166, 4, 'DI Lestrade', 'Supporting'),
(9,3,2,  47, 5, 'James Moriarty', 'Antagonist'),

(9,0,3, 73, 1, 'Sherlock Holmes', 'Protagonist'),
(9,0,3, 163, 2, 'Mycroft Holmes', 'Supporting'),
(9,0,3, 165, 3, 'Dr. John Watson', 'Sidekick'),
(9,0,3, 166, 4, 'DI Lestrade', 'Supporting'),

(9,1,3, 73, 1, 'Sherlock Holmes', 'Protagonist'),
(9,1,3, 163, 2, 'Mycroft Holmes', 'Supporting'),
(9,1,3, 165, 3, 'Dr. John Watson', 'Sidekick'),
(9,1,3, 166, 4, 'DI Lestrade', 'Supporting'),

(9,2,3, 73, 1, 'Sherlock Holmes', 'Protagonist'),
(9,2,3, 163, 2, 'Mycroft Holmes', 'Supporting'),
(9,2,3, 165, 3, 'Dr. John Watson', 'Sidekick'),
(9,2,3, 166, 4, 'DI Lestrade', 'Supporting'),

(9,3,3, 73, 1, 'Sherlock Holmes', 'Protagonist'),
(9,3,3, 163, 2, 'Mycroft Holmes', 'Supporting'),
(9,3,3, 165, 3, 'Dr. John Watson', 'Sidekick'),
(9,3,3, 166, 4, 'DI Lestrade', 'Supporting'),

-- Show 10: The Witcher
(10,1,1, 168, 1, 'Geralt of Rivia', 'Protagonist'),
(10,1,1, 169, 2, 'Ciri', 'Main cast'),
(10,1,1, 170, 3, 'Yennefer', 'Main cast'),

(10,2,1, 168, 1, 'Geralt of Rivia', 'Protagonist'),
(10,2,1, 169, 2, 'Ciri', 'Main cast'),
(10,2,1, 170, 3, 'Yennefer', 'Main cast'),

(10,3,1, 168, 1, 'Geralt of Rivia', 'Protagonist'),
(10,3,1, 169, 2, 'Ciri', 'Main cast'),
(10,3,1, 170, 3, 'Yennefer', 'Main cast'),

(10,4,1, 168, 1, 'Geralt of Rivia', 'Protagonist'),
(10,4,1, 169, 2, 'Ciri', 'Main cast'),
(10,4,1, 170, 3, 'Yennefer', 'Main cast'),

(10,1,2, 168, 1, 'Geralt of Rivia', 'Protagonist'),
(10,1,2, 169, 2, 'Ciri', 'Main cast'),
(10,1,2, 170, 3, 'Yennefer', 'Main cast'),

(10,2,2, 168, 1, 'Geralt of Rivia', 'Protagonist'),
(10,2,2, 169, 2, 'Ciri', 'Main cast'),
(10,2,2, 170, 3, 'Yennefer', 'Main cast'),

(10,6,3, 168, 1, 'Geralt of Rivia', 'Protagonist'),
(10,6,3, 169, 2, 'Ciri', 'Main cast'),
(10,6,3, 170, 3, 'Yennefer', 'Main cast'),

(10,7,3, 168, 1, 'Geralt of Rivia', 'Protagonist'),
(10,7,3, 169, 2, 'Ciri', 'Main cast'),
(10,7,3, 170, 3, 'Yennefer', 'Main cast'),

(10,8,3, 168, 1, 'Geralt of Rivia', 'Protagonist'),
(10,8,3, 169, 2, 'Ciri', 'Main cast'),
(10,8,3, 170, 3, 'Yennefer', 'Main cast'),

-- Show 11: The Big Bang Theory
(11,1,1, 172, 1, 'Leonard Hofstadter', 'Main cast'),
(11,1,1, 173, 2, 'Sheldon Cooper', 'Protagonist'),
(11,1,1, 174, 3, 'Penny', 'Main cast'),

(11,2,1, 172, 1, 'Leonard Hofstadter', 'Main cast'),
(11,2,1, 173, 2, 'Sheldon Cooper', 'Protagonist'),
(11,2,1, 174, 3, 'Penny', 'Main cast'),

(11,1,2, 172, 1, 'Leonard Hofstadter', 'Main cast'),
(11,1,2, 173, 2, 'Sheldon Cooper', 'Protagonist'),
(11,1,2, 174, 3, 'Penny', 'Main cast'),

(11,2,2, 172, 1, 'Leonard Hofstadter', 'Main cast'),
(11,2,2, 173, 2, 'Sheldon Cooper', 'Protagonist'),
(11,2,2, 174, 3, 'Penny', 'Main cast'),

(11,22,12, 172, 1, 'Leonard Hofstadter', 'Main cast'),
(11,22,12, 173, 2, 'Sheldon Cooper', 'Protagonist'),
(11,22,12, 174, 3, 'Penny', 'Main cast'),

(11,23,12, 172, 1, 'Leonard Hofstadter', 'Main cast'),
(11,23,12, 173, 2, 'Sheldon Cooper', 'Protagonist'),
(11,23,12, 174, 3, 'Penny', 'Main cast'),

(11,24,12, 172, 1, 'Leonard Hofstadter', 'Main cast'),
(11,24,12, 173, 2, 'Sheldon Cooper', 'Protagonist'),
(11,24,12, 174, 3, 'Penny', 'Main cast'),

-- Show 12: The Handmaid's Tale
(12,1,1, 175, 1,'June Osborne', 'Lead'),
(12,1,1, 176, 2,'Serena Joy Waterford', 'Main cast'),
(12,1,1, 177, 3,'Aunt Lydia Clemens', 'Supporting'),

(12,2,1, 175, 1,'June Osborne', 'Lead'),
(12,2,1, 176, 2,'Serena Joy Waterford', 'Main cast'),
(12,2,1, 177, 3,'Aunt Lydia Clemens', 'Supporting'),

(12,1,2, 175, 1,'June Osborne', 'Lead'),
(12,1,2, 176, 2,'Serena Joy Waterford', 'Main cast'),
(12,1,2, 177, 3,'Aunt Lydia Clemens', 'Supporting'),

(12,2,2, 175, 1,'June Osborne', 'Lead'),
(12,2,2, 176, 2,'Serena Joy Waterford', 'Main cast'),
(12,2,2, 177, 3,'Aunt Lydia Clemens', 'Supporting'),

(12,8,5, 175, 1,'June Osborne', 'Lead'),
(12,8,5, 176, 2,'Serena Joy Waterford', 'Main cast'),
(12,8,5, 177, 3,'Aunt Lydia Clemens', 'Supporting'),

(12,9,5, 175, 1,'June Osborne', 'Lead'),
(12,9,5, 176, 2,'Serena Joy Waterford', 'Main cast'),
(12,9,5, 177, 3,'Aunt Lydia Clemens', 'Supporting'),

-- Show 13: Westworld
(13,1,1, 179, 1, 'Dolores Abernathy', 'Lead'),
(13,1,1, 180, 2, 'Bernard Lowe', 'Main cast'),
(13,1,1, 181, 3, 'Man in Black', 'Supporting'),

(13,2,1, 179, 1, 'Dolores Abernathy', 'Lead'),
(13,2,1, 180, 2, 'Bernard Lowe', 'Main cast'),
(13,2,1, 181, 3, 'Man in Black', 'Supporting'),

(13,3,1, 179, 1, 'Dolores Abernathy', 'Lead'),
(13,3,1, 180, 2, 'Bernard Lowe', 'Main cast'),
(13,3,1, 181, 3, 'Man in Black', 'Supporting'),

(13,1,2, 179, 1, 'Dolores Abernathy', 'Lead'),
(13,1,2, 180, 2, 'Bernard Lowe', 'Main cast'),
(13,1,2, 181, 3, 'Man in Black', 'Supporting'),

(13,2,2, 179, 1, 'Dolores Abernathy', 'Lead'),
(13,2,2, 180, 2, 'Bernard Lowe', 'Main cast'),
(13,2,2, 181, 3, 'Man in Black', 'Supporting'),

(13,4,2, 179, 1, 'Dolores Abernathy', 'Lead'),
(13,4,2, 180, 2, 'Bernard Lowe', 'Main cast'),
(13,4,2, 181, 3, 'Man in Black', 'Supporting'),

-- Show 14: Money Heist
(14,1,1, 183, 1, 'Tokio', 'Main cast'),
(14,1,1, 184, 2, 'El Profesor', 'Mastermind'),
(14,1,1, 185, 3, 'Raquel Murillo', 'Main cast'),
(14,1,1, 186, 4, 'Berlin', 'Lead'),
(14,1,1, 187, 5, 'Rio', 'Main Cast'),

(14,2,1, 183, 1, 'Tokio', 'Main cast'),
(14,2,1, 184, 2, 'El Profesor', 'Mastermind'),
(14,2,1, 185, 3, 'Raquel Murillo', 'Main cast'),
(14,2,1, 186, 4, 'Berlin', 'Lead'),
(14,2,1, 187, 5, 'Rio', 'Main Cast'),

(14,3,1, 183, 1, 'Tokio', 'Main cast'),
(14,3,1, 184, 2, 'El Profesor', 'Mastermind'),
(14,3,1, 185, 3, 'Raquel Murillo', 'Main cast'),
(14,3,1, 186, 4, 'Berlin', 'Lead'),
(14,3,1, 187, 5, 'Rio', 'Main Cast'),

(14,1,2, 183, 1, 'Tokio', 'Main cast'),
(14,1,2, 184, 2, 'El Profesor', 'Mastermind'),
(14,1,2, 185, 3, 'Raquel Murillo', 'Main cast'),
(14,1,2, 186, 4, 'Berlin', 'Lead'),
(14,1,2, 187, 5, 'Rio', 'Main Cast'),

(14,2,2, 183, 1, 'Tokio', 'Main cast'),
(14,2,2, 184, 2, 'El Profesor', 'Mastermind'),
(14,2,2, 185, 3, 'Raquel Murillo', 'Main cast'),
(14,2,2, 186, 4, 'Berlin', 'Lead'),
(14,2,2, 187, 5, 'Rio', 'Main Cast'),

(14,8,5, 183, 1, 'Tokio', 'Main cast'),
(14,8,5, 184, 2, 'El Profesor', 'Mastermind'),
(14,8,5, 185, 3, 'Raquel Murillo', 'Main cast'),
(14,8,5, 186, 4, 'Berlin', 'Lead'),
(14,8,5, 187, 5, 'Rio', 'Main Cast'),

(14,9,5, 183, 1, 'Tokio', 'Main cast'),
(14,9,5, 184, 2, 'El Profesor', 'Mastermind'),
(14,9,5, 185, 3, 'Raquel Murillo', 'Main cast'),
(14,9,5, 186, 4, 'Berlin', 'Lead'),
(14,9,5, 187, 5, 'Rio', 'Main Cast'),

(14,10,5, 183, 1, 'Tokio', 'Main cast'),
(14,10,5, 184, 2, 'El Profesor', 'Mastermind'),
(14,10,5, 185, 3, 'Raquel Murillo', 'Main cast'),
(14,10,5, 186, 4, 'Berlin', 'Lead'),
(14,10,5, 187, 5, 'Rio', 'Main Cast'),

-- Show 15: The Queen's Gambit
(15,1,1, 190, 1, 'Beth Harmon', 'Protagonist'),
(15,1,1, 1, 2, 'Mr. Shaibel', 'Supporting'),

(15,2,1, 190, 1, 'Beth Harmon', 'Protagonist'),
(15,2,1, 192, 2, 'Harry Beltik', 'Supporting'),

(15,3,1, 190, 1, 'Beth Harmon', 'Protagonist'),
(15,3,1, 191, 2, 'Vasily Borgov', 'Antagonist'),
(15,3,1, 192, 3, 'Harry Beltik', 'Supporting'),

(15,4,1, 190, 1, 'Beth Harmon', 'Protagonist'),
(15,4,1, 191, 2, 'Vasily Borgov', 'Antagonist'),
(15,4,1, 192, 3, 'Harry Beltik', 'Supporting'),

(15,5,1, 190, 1, 'Beth Harmon', 'Protagonist'),
(15,5,1, 192, 2, 'Harry Beltik', 'Supporting'),
(15,5,1, 32,  3, 'Allston Wheatley', 'Extra'),

(15,6,1, 190, 1, 'Beth Harmon', 'Protagonist'),
(15,6,1, 191, 2, 'Vasily Borgov', 'Antagonist'),
(15,6,1, 192, 3, 'Harry Beltik', 'Supporting'),

(15,7,1, 190, 1, 'Beth Harmon', 'Protagonist'),
(15,7,1, 191, 2, 'Vasily Borgov', 'Antagonist'),
(15,7,1, 192, 3, 'Harry Beltik', 'Supporting'),

-- Show 16: Loki
(16,1,1, 193, 1, 'Loki', 'Lead'),

(16,2,1, 193, 1, 'Loki', 'Lead'),
(16,2,1, 194, 2, 'Mobius', 'Antagonist'),

(16,3,1, 193, 1, 'Loki', 'Lead'),
(16,3,1, 195, 3, 'Sylvie', 'Main cast'),

(16,4,1, 193, 1, 'Loki', 'Lead'),
(16,4,1, 194, 2, 'Mobius', 'Antagonist'),

(16,3,2, 193, 1, 'Loki', 'Lead'),
(16,3,2, 195, 3, 'Sylvie', 'Main cast'),

(16,4,2, 193, 1, 'Loki', 'Lead'),
(16,4,2, 194, 2, 'Mobius', 'Antagonist'),

(16,5,2, 193, 1, 'Loki', 'Lead'),
(16,5,2, 194, 2, 'Mobius', 'Antagonist'),
(16,5,2, 195, 3, 'Sylvie', 'Main cast'),

(16,6,2, 193, 1, 'Loki', 'Lead'),
(16,6,2, 194, 2, 'Mobius', 'Antagonist'),
(16,6,2, 195, 3, 'Sylvie', 'Main cast'),

-- Show 17: Attack On Titan
(17,1,1, 198, 1, 'Eren Yaeger(voice)', 'Protagonist'),
(17,1,1, 199, 2, 'Mikasa Ackermann', 'Main cast'),
(17,1,1, 200, 3, 'Armin Arlert', 'Main cast'),

(17,2,1, 198, 1, 'Eren Yaeger(voice)', 'Protagonist'),
(17,2,1, 199, 2, 'Mikasa Ackermann', 'Main cast'),
(17,2,1, 200, 3, 'Armin Arlert', 'Main cast'),

(17,6,2, 198, 1, 'Eren Yaeger(voice)', 'Protagonist'),
(17,6,2, 199, 2, 'Mikasa Ackermann', 'Main cast'),
(17,6,2, 200, 3, 'Armin Arlert', 'Main cast'),
(17,6,2, 201, 5, 'Reiner Braun', 'Antagonist'),

(17,7,2, 198, 1, 'Eren Yaeger(voice)', 'Protagonist'),
(17,7,2, 200, 3, 'Armin Arlert', 'Main cast'),
(17,7,2, 201, 5, 'Reiner Braun', 'Antagonist'),

(17,12,2, 198, 1, 'Eren Yaeger(voice)', 'Protagonist'),
(17,12,2, 199, 2, 'Mikasa Ackermann', 'Main cast'),
(17,12,2, 200, 3, 'Armin Arlert', 'Main cast'),
(17,12,2, 201, 5, 'Reiner Braun', 'Antagonist'),

(17,9,3, 198, 1, 'Eren Yaeger(voice)', 'Protagonist'),
(17,9,3, 199, 2, 'Mikasa Ackermann', 'Main cast'),

(17,11,3, 198, 1, 'Eren Yaeger(voice)', 'Protagonist'),
(17,11,3, 199, 2, 'Mikasa Ackermann', 'Main cast'),
(17,11,3, 200, 3, 'Armin Arlert', 'Main cast'),

(17,16,3, 198, 1, 'Eren Yaeger(voice)', 'Protagonist'),
(17,16,3, 199, 2, 'Mikasa Ackermann', 'Main cast'),
(17,16,3, 200, 3, 'Armin Arlert', 'Main cast'),
(17,16,3, 201, 5, 'Reiner Braun', 'Antagonist'),
(17,16,3, 202, 6, 'Floch Forster', 'Antagonist'),

(17,17,3, 198, 1, 'Eren Yaeger(voice)', 'Protagonist'),
(17,17,3, 199, 2, 'Mikasa Ackermann', 'Main cast'),
(17,17,3, 200, 3, 'Armin Arlert', 'Main cast'),
(17,17,3, 201, 5, 'Reiner Braun', 'Antagonist'),
(17,17,3, 202, 6, 'Floch Forster', 'Antagonist'),

(17,20,4, 198, 1, 'Eren Yaeger(voice)', 'Protagonist'),
(17,20,4, 199, 2, 'Mikasa Ackermann', 'Main cast'),
(17,20,4, 200, 3, 'Armin Arlert', 'Main cast'),

(17,21,4, 198, 1, 'Eren Yaeger(voice)', 'Protagonist'),
(17,21,4, 199, 2, 'Mikasa Ackermann', 'Main cast'),
(17,21,4, 200, 3, 'Armin Arlert', 'Main cast'),
(17,21,4, 201, 5, 'Reiner Braun', 'Antagonist'),
(17,21,4, 202, 6, 'Floch Forster', 'Antagonist'),

(17,28,4, 198, 1, 'Eren Yaeger(voice)', 'Protagonist'),
(17,28,4, 199, 2, 'Mikasa Ackermann', 'Main cast'),
(17,28,4, 200, 3, 'Armin Arlert', 'Main cast'),

-- Show 18: The Family Man
(18,1,1, 205, 1, 'Srikant Tiwari', 'Lead'),
(18,1,1, 206, 2, 'JK Talpade', 'Main cast'),
(18,1,1, 207, 3, 'Dhriti', 'Supporting'),
(18,1,1, 208, 4, 'Atharv', 'Supporting'),

(18,2,1, 205, 1, 'Srikant Tiwari', 'Lead'),
(18,2,1, 206, 2, 'JK Talpade', 'Main cast'),
(18,2,1, 207, 3, 'Dhriti', 'Supporting'),
(18,2,1, 208, 4, 'Atharv', 'Supporting'),

(18,3,1, 205, 1, 'Srikant Tiwari', 'Lead'),
(18,3,1, 206, 2, 'JK Talpade', 'Main cast'),
(18,3,1, 207, 3, 'Dhriti', 'Supporting'),
(18,3,1, 208, 4, 'Atharv', 'Supporting'),

(18,6,2, 205, 1, 'Srikant Tiwari', 'Lead'),
(18,6,2, 206, 2, 'JK Talpade', 'Main cast'),
(18,6,2, 207, 3, 'Dhriti', 'Supporting'),
(18,6,2, 208, 4, 'Atharv', 'Supporting'),

(18,7,2, 205, 1, 'Srikant Tiwari', 'Lead'),
(18,7,2, 206, 2, 'JK Talpade', 'Main cast'),
(18,7,2, 207, 3, 'Dhriti', 'Supporting'),
(18,7,2, 208, 4, 'Atharv', 'Supporting'),

(18,8,2, 205, 1, 'Srikant Tiwari', 'Lead'),
(18,8,2, 206, 2, 'JK Talpade', 'Main cast'),
(18,8,2, 207, 3, 'Dhriti', 'Supporting'),
(18,8,2, 208, 4, 'Atharv', 'Supporting'),

(18,9,2, 205, 1, 'Srikant Tiwari', 'Lead'),
(18,9,2, 206, 2, 'JK Talpade', 'Main cast'),
(18,9,2, 207, 3, 'Dhriti', 'Supporting'),
(18,9,2, 208, 4, 'Atharv', 'Supporting'),

-- Show 19: Squid Game
(19,1,1, 210, 1, 'Seong Gi-hun', 'Protagonist'),
(19,1,1, 211, 2, 'Cho Sang-woo', 'Minor antagonist'),
(19,1,1, 212, 3, 'Nandito', 'Supporting'),

(19,2,1, 210, 1, 'Seong Gi-hun', 'Protagonist'),
(19,2,1, 211, 2, 'Cho Sang-woo', 'Minor antagonist'),
(19,2,1, 212, 3, 'Nandito', 'Supporting'),

(19,3,1, 210, 1, 'Seong Gi-hun', 'Protagonist'),
(19,3,1, 211, 2, 'Cho Sang-woo', 'Minor antagonist'),
(19,3,1, 212, 3, 'Nandito', 'Supporting'),

(19,4,1, 210, 1, 'Seong Gi-hun', 'Protagonist'),
(19,4,1, 211, 2, 'Cho Sang-woo', 'Minor antagonist'),
(19,4,1, 212, 3, 'Nandito', 'Supporting'),

(19,5,1, 210, 1, 'Seong Gi-hun', 'Protagonist'),
(19,5,1, 211, 2, 'Cho Sang-woo', 'Minor antagonist'),
(19,5,1, 212, 3, 'Nandito', 'Supporting'),

(19,6,1, 210, 1, 'Seong Gi-hun', 'Protagonist'),
(19,6,1, 211, 2, 'Cho Sang-woo', 'Minor antagonist'),
(19,6,1, 212, 3, 'Nandito', 'Supporting'),

(19,7,1, 210, 1, 'Seong Gi-hun', 'Protagonist'),
(19,7,1, 211, 2, 'Cho Sang-woo', 'Minor antagonist'),
(19,7,1, 212, 3, 'Nandito', 'Supporting'),

(19,8,1, 210, 1, 'Seong Gi-hun', 'Protagonist'),
(19,8,1, 211, 2, 'Cho Sang-woo', 'Minor antagonist'),


(19,9,1, 210, 1, 'Seong Gi-hun', 'Protagonist'),
(19,9,1, 211, 2, 'Cho Sang-woo', 'Minor antagonist'),


-- Show 20: Arcane
(20,1,1, 213, 1, 'Vi', 'Protagonist'),
(20,1,1, 215, 3, 'Powder', 'Antagonist'),

(20,2,1, 213, 1, 'Vi', 'Protagonist'),
(20,2,1, 215, 3, 'Powder', 'Antagonist'),

(20,3,1, 213, 1, 'Vi', 'Protagonist'),
(20,3,1, 214, 2, 'Silco', 'Minor antagonist'),
(20,3,1, 215, 3, 'Powder', 'Antagonist'),

(20,4,1, 213, 1, 'Vi', 'Protagonist'),
(20,4,1, 214, 2, 'Silco', 'Minor antagonist'),
(20,4,1, 215, 3, 'Powder', 'Antagonist'),

(20,5,1, 213, 1, 'Vi', 'Protagonist'),
(20,5,1, 214, 2, 'Silco', 'Minor antagonist'),
(20,5,1, 215, 3, 'Powder', 'Antagonist'),

(20,6,1, 213, 1, 'Vi', 'Protagonist'),
(20,6,1, 214, 2, 'Silco', 'Minor antagonist'),
(20,6,1, 215, 3, 'Powder', 'Antagonist'),

(20,7,1, 213, 1, 'Vi', 'Protagonist'),
(20,7,1, 214, 2, 'Silco', 'Minor antagonist'),
(20,7,1, 215, 3, 'Powder', 'Antagonist'),

(20,8,1, 213, 1, 'Vi', 'Protagonist'),
(20,8,1, 214, 2, 'Silco', 'Minor antagonist'),
(20,8,1, 215, 3, 'Powder', 'Antagonist'),

(20,9,1, 213, 1, 'Vi', 'Protagonist'),
(20,9,1, 214, 2, 'Silco', 'Minor antagonist'),
(20,9,1, 215, 3, 'Powder', 'Antagonist');



INSERT INTO movieAwarded (Movie_ID, Award_ID, Year_Of_Awarding) VALUES
-- Awards for 'Inception'
(1, 1, 2011),  -- Best Picture
(1, 13, 2011),  -- Best Direction

-- Awards for 'The Dark Knight'
(2, 1, 2009),  -- Best Picture
(2, 13, 2009),  -- Best Direction

-- Awards for 'The Matrix'
(3, 1, 2000),  -- Best Picture

-- Awards for 'Avatar'
(4, 1, 2010),  -- Best Picture
(4, 13, 2010),  -- Best Direction

-- Awards for 'Titanic'
(5, 1, 1998),  -- Best Picture

-- Awards for 'The Shawshank Redemption'
(6, 1, 1995),  -- Best Picture

-- Awards for 'The Godfather'
(7, 1, 1973),  -- Best Picture
(7, 13, 1973),  -- Best Direction

-- Awards for 'Star Wars: Episode IV - A New Hope'
(8, 1, 1978),  -- Best Picture
(8, 13, 1978),  -- Best Direction

-- Awards for 'Jurassic Park'
(9, 1, 1994),  -- Best Picture

-- Awards for 'The Lion King'
(10, 1, 1995), -- Best Picture
(10, 14, 1995), -- Best Animated Feature

-- Awards for 'Finding Nemo'
(11, 1, 2004), -- Best Picture

-- Awards for 'Toy Story'
(12, 14, 1996), -- Best Animated Feature

-- Awards for 'The Godfather: Part II'
(13, 1, 1975), -- Best Picture

-- Awards for 'Finding Dory'
(14, 14, 2017), -- Best Animated Feature

-- Awards for 'Black Panther'
(22, 1, 2019), -- Best Picture
(22, 13, 2019), -- Best Direction

-- Awards for 'Parasite'
(23, 1, 2020), -- Best Picture
(23, 13, 2020), -- Best Direction

-- Awards for 'The Avengers'
(25, 1, 2013), -- Best Picture

(29, 1, 1991),
(31, 13, 2005 ),
(32, 1, 2007),
(33, 13, 2012),
(36, 1, 2023), (36, 13, 2023),
(37, 13, 2001),
(41, 1, 2010), (41, 13, 2010),
(39, 13, 2023);

INSERT INTO showAwarded (Show_ID, Award_ID, Year_Of_Awarding) VALUES
(1, 9, 2014),  -- Breaking Bad, Emmy Awards, Outstanding Drama Series
(2, 9, 2016),  -- Game of Thrones, Emmy Awards, Outstanding Drama Series
(3, 9, 2017),  -- Stranger Things, Emmy Awards, Outstanding Drama Series
(4, 9, 2017),  -- The Crown, Emmy Awards, Outstanding Drama Series
(5, 10, 2020), -- The Mandalorian, Emmy Awards, Outstanding Comedy Series
(6, 10, 2010), -- The Office (US), Emmy Awards, Outstanding Comedy Series
(7, 10, 2003), -- Friends, Emmy Awards, Outstanding Comedy Series
(9, 9, 2014),  -- Sherlock, Emmy Awards, Outstanding Drama Series
(10, 9, 2020), -- The Witcher, Emmy Awards, Outstanding Drama Series
(12, 9, 2018), -- The Handmaid's Tale, Emmy Awards, Outstanding Drama Series
(14, 9, 2021), -- Money Heist, Emmy Awards, Outstanding Drama Series
(15, 9, 2021), -- The Queen's Gambit, Emmy Awards, Outstanding Drama Series
(19, 9, 2022),
(20, 9, 2022);


INSERT INTO personAwarded (Person_ID, Award_ID, Year_Of_Awarding) VALUES 
(1,3,1998),
(4,3,1992),
(5,5,2018),
(6,5,2021),
(7,3,2020),
(8,7,1977),
(10,3,1976),
(11,11,1998),
(13,5,1993),
(14,4,2011),
(19,12,1995),
(20,7,2017),
(21,2,2021),
(23,2,1994),
(24,2,2009),
(26,5,1992),
(27,12,1994),
(28,7,2005),
(29,3,1981),
(36, 2, 1999),
(32,3,1993),
(33,5,1992),
(34,7,2012),
(35,3,1990),
(37,3,1986),
(38,3,2003),
(39,6,1981),
(40,2,2000),
(41,5,2003),
(42,8,2021),
(45,4,1997),
(46,7,2004),
(47,7,1995),
(49,11,1977),
(51,11,2014),
(53,3,1989),
(54,11,2018),
(56,5,1984),
(57,5,2022),
(58,11,1979),
(60,5,2013),
(62,6,2005),
(63,5,2013),
(64,8,2012),
(68,3,2002),
(69,3,2022),
(70,2,2018),
(74,11,2019),
(75,3,2006),
(78,4,2014),
(79,2,1995),
(82,5,2018),
(83,11,2001),
(84,4,2016),
(88,8,1999),
(90,11,2000),
(91,7,2005),
(92,6,2018),
(101,7,2019),
(102,11,2002),
(105,8,2021),
(106,11,2003),
(108, 2, 2005),
(110,4,2012),
(112,5,2015),
(113,7,2017),
(114,2,1979),
(116,3,2014),
(117,3,1996),
(120,11,1994),
(121,6,2018),
(126,5,2002),
(127,3,2001),
(130,7,1996),
(134,3,2023),
(135,4,2018),
(140,12,2023),
(141,2,1984),
(142,6,2006),
(144,8,1978),
(146,5,1997),
(148,6,2002),
(153,11,2009),
(154,5,1997),
(156,12,1987),
(168,5,2001),
(169,12,2020),
(170,4,2012),
(173,5,2002),
(175,12,1999),
(177,4,1973),
(178,2,2019),
(179,8,2009),
(180,7,2011),
(181,5,1972),
(187,7,2022),
(188,5,2023),
(191,5,2009),
(192,11,2021),
(194,11,2015),
(196,2, 2022),
(200,6,2004),
(199,6,2013),
(202,3,2008),
(204,7,2016),
(206,5,2022),
(207,6,2023);

INSERT INTO movieAvailableIn (Movie_ID, Language_ID) VALUES
(1,1),(1,2),(1,3),(1,4),
(2,1),(2,2),(2,3),(2,7),
(3,1),(3,4),(3,5),(3,6),(3,7),
(4,1),(4,2),(4,5),(4,8),
(5,1),(5,8),
(6,1),(6,5),(6,7),
(7,1),(7,2),
(8,1),(8,2),(8,3),(8,7),(8,8),
(9,1),(9,2),(9,4),(9,8),
(10,1),(10,4),(10,5),(10,7),
(11,1),(11,4),(11,7),(11,8),
(12,1),(12,4),(12,5),(12,8),
(13,1),(13,2),(13,3),(13,4),(13,5),
(14,1),(14,2),(14,3),(14,6),(14,7),(14,8),
(15,1),(15,5),
(16,1),(16,6),
(17,1),(17,2),
(18,1),
(19,1),(19,4),(19,5),(19,6),
(20,1),(20,2),
(21,1),(21,2),(21,5),(21,7),
(22,1),
(23,6),(23,8),
(24,1),
(25,1),(25,2),(25,3),(25,4),(25,5),(25,6),(25,7),(25,8),
(26,1),(26,2),(26,6),(26,7),(26,8),
(27,1),(27,2),(27,3),(27,4),
(28,1),
(29,1),(29,2),(29,3),
(30,1),(30,2),(30,3),(30,4),
(31,2),
(32,1),(32,2),(32,3),
(33,1),(33,3),(33,4),
(34,1),(34,2),(34,3),(34,8),
(35,1),(35,4),
(36,1),(36,3),(36,4),(36,6),(36,7),
(37,5),(37,7),(37,8),
(38,5),(38,6),
(39,1),(39,4),(39,6),
(40,6),
(41,1),(41,7),
(42,1),(42,7),
(43,1),(43,2),(43,3),(43,4),(43,5),(43,6),(43,7),(43,8);

INSERT INTO showAvailableIn (Show_ID, Language_ID) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), 
(2, 1), (2, 2), (2, 3),
(3, 1), (3, 2), (3, 3), (3, 4),
(4, 1), (4, 2),
(5, 1), (5, 2), (5, 3), (5, 4), (5, 5),
(6, 1), (6, 2), (6, 3), (6, 4), (6, 8),
(7, 1), (7, 2), (7, 3),
(8, 1),
(9, 1), (9, 4), 
(10, 1), (10, 2), (10, 5), (10, 6),
(11, 1), (11, 4),(11, 7),
(12, 1), (12, 2), (12, 3), (12, 4), (12, 5),
(13, 1), (13, 2), (13, 6), (13, 8),
(14, 1), (14, 2), (14, 5), (14, 7),
(15, 1), (15, 4), (15, 5),
(16, 1), (16, 2), (16, 3), (16, 4), (16, 5), (16, 6),
(17, 1), (17, 3), (17, 6), (17, 7),
(18, 7),
(19, 1), (19, 2), (19, 6), (19, 8),
(20, 1), (20, 2), (20, 3);


INSERT INTO movieReviewed (Review_ID, Movie_ID) VALUES
(277, 1), (146, 1),
(47, 2), (260, 2),
(170, 3), (289, 3),
(168, 4), (13, 4),
(285, 5), (66, 5),
(23, 6), (229, 6),
(181, 7), (224, 7),
(282, 8), (175, 8),
(139, 9), (128, 9),
(116, 10), (233, 10),
(216, 11), (24, 11),
(99, 12), (265, 12),
(178, 13), (87, 13),
(225, 14), (21, 14),
(176, 15), (25, 15),
(263, 16), (252, 16),
(125, 17), (117, 17),
(81, 18), (11, 18),
(267, 19), (272, 19),
(284, 20), (209, 20),
(37, 21), (249, 21),
(163, 22), (150, 22),
(27, 23), (276, 23),
(201, 24), (195, 24),
(42, 25), (231, 25),
(77, 26), (274, 26),
(119, 27), (113, 27),
(110, 28), (154, 28),
(41, 29), (264, 29),
(104, 30), (211, 30),
(255, 31), (19, 31),
(228, 32), (138, 32),
(38, 33), (185, 33),
(218, 34), (248, 34),
(8, 35), (275, 35),
(89, 36), (45, 36),
(69, 37), (198, 37),
(52, 38), (115, 38),
(130, 39), (22, 39),
(58, 40), (92, 40),
(30, 41), (261, 41),
(172, 42), (120, 42),
(192, 43), (197, 43);

INSERT INTO showReviewed (Review_ID, Show_ID) VALUES
(151, 1), (221, 1),
(123, 2), (46, 2),
(84, 3), (173, 3),
(155, 4), (4, 4),
(227, 5), (279, 5),
(213, 6), (33, 6),
(258, 7), (294, 7),
(166, 8), (266, 8),
(245, 9), (76, 9),
(283, 10), (240, 10),
(118, 11), (270, 11),
(35, 12), (78, 12),
(193, 13), (109, 13),
(65, 14), (222, 14),
(111, 15), (129, 15),
(1, 16), (102, 16),
(70, 17), (5, 17),
(26, 18), (179, 18),
(14, 19), (191, 19),
(247, 20), (121, 20);

INSERT INTO episodeReviewed (Review_ID, Show_ID, Episode_Number, Season_Number) VALUES
(142, 1, 1, 1),
(223, 1, 2, 1),
(271, 1, 3, 1),
(85, 1, 4, 1),
(133, 1, 5, 1),
(253, 1, 1, 4),
(190, 1, 11, 4),
(68, 1, 13, 4),
(152, 1, 13, 5),
(214, 1, 14, 5),
(127, 1, 15, 5),
(217, 1, 16, 5),
(12, 2, 1, 1),
(79, 2, 2, 1),
(161, 2, 3, 1),
(188, 2, 4, 1),
(103, 2, 3, 8),
(63, 2, 4, 8),
(67, 2, 5, 8),
(86, 2, 6, 8),
(97, 3, 1, 1),
(251, 3, 2, 1),
(215, 3, 3, 1),
(95, 3, 4, 1),
(287, 3, 6, 4),
(286, 3, 7, 4),
(202, 3, 8, 4),
(40, 3, 9, 4),
(242, 4, 1, 1),
(53, 4, 2, 1),
(244, 4, 3, 1),
(199, 4, 1, 2),
(157, 4, 2, 2),
(15, 4, 8, 6),
(230, 4, 9, 6),
(295, 4, 10, 6),
(73, 5, 1, 1),
(273, 5, 2, 1),
(239, 5, 3, 1),
(200, 5, 4, 1),
(186, 5, 1, 2),
(156, 5, 2, 2),
(177, 5, 7, 3),
(237, 5, 8, 3),
(290, 6, 1, 1),
(256, 6, 2, 1),
(56, 6, 3, 1),
(187, 6, 4, 1),
(28, 6, 1, 2),
(259, 6, 2, 2),
(147, 6, 21, 9),
(16, 6, 22, 9),
(205, 6, 23, 9),
(94, 7, 1, 1),
(207, 7, 2, 1),
(174, 7, 3, 1),
(234, 7, 4, 1),
(108, 7, 1, 2),
(57, 7, 2, 2),
(208, 7, 17, 10),
(59, 7, 18, 10),
(149, 8, 1, 1),
(278, 8, 2, 1),
(137, 8, 1, 2),
(254, 8, 2, 2),
(257, 8, 1, 36),
(210, 8, 2, 36),
(269, 8, 3, 36),
(132, 8, 4, 36),
(140, 9, 0, 1),
(18, 9, 1, 1),
(220, 9, 2, 1),
(9, 9, 3, 1),
(32, 9, 1, 2),
(43, 9, 2, 2),
(6, 9, 3, 2),
(232, 9, 0, 3),
(131, 9, 1, 3),
(54, 9, 2, 3),
(167, 9, 3, 3),
(80, 10, 1, 1),
(158, 10, 2, 1),
(90, 10, 3, 1),
(29, 10, 4, 1),
(2, 10, 1, 2),
(160, 10, 2, 2),
(49, 10, 6, 3),
(98, 10, 7, 3),
(72, 10, 8, 3),
(31, 11, 1, 1),
(88, 11, 2, 1),
(136, 11, 1, 2),
(34, 11, 2, 2),
(243, 11, 22, 12),
(196, 11, 23, 12),
(10, 11, 24, 12),
(134, 12, 1, 1),
(48, 12, 2, 1),
(184, 12, 1, 2),
(189, 12, 2, 2),
(50, 12, 8, 5),
(204, 12, 9, 5),
(236, 13, 1, 1),
(114, 13, 2, 1),
(124, 13, 3, 1),
(293, 13, 1, 2),
(60, 13, 2, 2),
(71, 13, 4, 2),
(171, 14, 1, 1),
(91, 14, 2, 1),
(169, 14, 3, 1),
(219, 14, 1, 2),
(82, 14, 2, 2),
(246, 14, 8, 5),
(145, 14, 9, 5),
(61, 14, 10, 5),
(144, 15, 1, 1),
(162, 15, 2, 1),
(55, 15, 3, 1),
(153, 15, 4, 1),
(141, 15, 5, 1),
(262, 15, 6, 1),
(112, 15, 7, 1),
(206, 16, 1, 1),
(143, 16, 2, 1),
(226, 16, 3, 1),
(39, 16, 4, 1),
(3, 16, 3, 2),
(106, 16, 4, 2),
(281, 16, 5, 2),
(183, 16, 6, 2),
(135, 17, 1, 1),
(100, 17, 2, 1),
(203, 17, 25, 1),
(291, 17, 6, 2),
(212, 17, 7, 2),
(180, 17, 12, 2),
(126, 17, 9, 3),
(250, 17, 11, 3),
(62, 17, 16, 3),
(96, 17, 17, 3),
(107, 17, 20, 4),
(36, 17, 21, 4),
(164, 17, 28, 4),
(75, 18, 1, 1),
(122, 18, 2, 1),
(93, 18, 3, 1),
(241, 18, 6, 2),
(280, 18, 7, 2),
(235, 18, 8, 2),
(101, 18, 9, 2),
(51, 19, 1, 1),
(44, 19, 2, 1),
(17, 19, 3, 1),
(292, 19, 4, 1),
(105, 19, 5, 1),
(64, 19, 6, 1),
(268, 19, 7, 1),
(20, 19, 8, 1),
(165, 19, 9, 1),
(159, 20, 1, 1),
(7, 20, 2, 1),
(148, 20, 3, 1),
(74, 20, 4, 1),
(238, 20, 5, 1),
(288, 20, 6, 1),
(182, 20, 7, 1),
(194, 20, 8, 1),
(83, 20, 9, 1);


INSERT INTO movieStreamsHere (Movie_ID, Site_ID) VALUES
(1, 7), 
(2, 2), 
(3, 3), 
(4, 7), 
(5, 1), 
(6, 8), 
(7, 7), 
(8, 9), 
(9, 4), 
(10, 8), 
(11, 9), 
(12, 6), 
(13, 10), 
(14, 4),
(15, 5),
(16, 7),
(17, 9),
(18, 1),
(19, 7),
(20, 5),
(21, 5),
(22, 6),
(23, 6),
(24, 10),
(25, 3),
(26, 2),
(27, 10),
(28, 3),
(29, 9),
(30, 2),
(31, 1),
(32, 1),
(33, 7),
(34, 4),
(35, 3),
(36, 1),
(37, 9),
(38, 4),
(39, 2),
(40, 6),
(41, 10),
(42, 6),
(43, 9);

INSERT INTO showStreamsHere (Show_ID, Site_ID) VALUES
(1, 6),
(2, 1),
(3, 4),
(4, 2),
(5, 5),
(6, 7),
(7, 5),
(8, 3),
(9, 8),
(10, 2),
(11, 10),
(12, 5),
(13, 1),
(14, 3),
(15, 2),
(16, 4),
(17, 9),
(18, 2),
(19, 1),
(20, 8);

INSERT INTO movieSequel (Movie_ID, Sequel_ID) VALUES
(3,26),
(4,27),
(7,13),
(8,15),
(12,30),
(13,29);


INSERT INTO moviePrequel (Movie_ID, Prequel_ID) VALUES
(13,7),
(15,8),
(26,3),
(27,4),
(29,13),
(30,12);

INSERT INTO movieWatchlisted (User_ID, Movie_ID) VALUES
(1, 1), 
(1, 35), 
(1, 19), 
(1, 17), 
(1, 39), 
(1, 41), 
(1, 23), 
(2, 10), 
(2, 31), 
(2, 2), 
(2, 33), 
(2, 38), 
(3, 18), 
(3, 2), 
(3, 29), 
(3, 22), 
(3, 35), 
(3, 27), 
(4, 23), 
(4, 31), 
(4, 16),
(4, 17),
(4, 30),
(5, 40),
(5, 9),
(5, 42),
(5, 6),
(5, 2),
(5, 11),
(6, 38),
(6, 14),
(6, 17),
(6, 21),
(6, 23),
(6, 9),
(6, 33),
(6, 43),
(6, 19),
(7, 38),
(7, 10),
(7, 19),
(7, 31),
(7, 13),
(7, 32),
(7, 27),
(8, 14),
(8, 11),
(8, 4),
(8, 22),
(8, 34),
(8, 38),
(8, 30),
(8, 39),
(8, 12),
(9, 26),
(9, 12),
(9, 39),
(9, 14),
(9, 33),
(9, 28),
(9, 1),
(10, 8),
(10, 26),
(10, 2),
(10, 11),
(10, 42),
(10, 23),
(11, 43),
(11, 28), 
(11, 15),
(11, 14),
(11, 39),
(11, 17),
(11, 31),
(12, 25),
(12, 9),
(12, 37),
(12, 31),
(12, 42),
(12, 26),
(12, 1),
(12, 10),
(12, 17),
(13, 8),
(13, 11),
(13, 38),
(13, 15),
(13, 18),
(13, 10),
(13, 35),
(13, 24),
(14, 29),
(14, 37),
(14, 28),
(14, 10),
(14, 24),
(15, 15),
(15, 24),
(15, 29),
(16, 38),
(16, 14),
(16, 5),
(16, 28),
(16, 19),
(16, 29),
(16, 24),
(17, 6),
(17, 4),
(17, 27),
(18, 40),
(18, 29),
(18, 30),
(18, 5),
(18, 19),
(18, 3),
(18, 14),
(18, 32),
(19, 29),
(19, 36),
(19, 7),
(19, 30),
(19, 21),
(19, 14),
(19, 22),
(20, 11),
(20, 16),
(20, 10),
(20, 6),
(20, 22),
(20, 36),
(20, 43),
(20, 18),
(21, 8),
(21, 4), 
(21, 42),
(21, 36),
(21, 33),
(21, 29),
(21, 17),
(21, 34),
(21, 14),
(22, 4),
(22, 29),
(22, 15),
(22, 2),
(22, 26),
(22, 11),
(22, 8),
(22, 28),
(22, 24),
(23, 18),
(23, 4),
(23, 26),
(23, 23),
(23, 10),
(23, 30),
(23, 22),
(23, 27),
(24, 23),
(24, 17),
(24, 19),
(24, 38),
(24, 32),
(24, 20);

INSERT INTO showWatchlisted (User_ID, Show_ID) VALUES
(1, 5),
(1, 2),
(1, 16),
(1, 9),
(1, 20),
(1, 8),
(2, 20),
(2, 1),
(2, 12),
(2, 4),
(3, 16),
(3, 14),
(3, 13),
(4, 10),
(4, 1),
(4, 12),
(5, 14),
(5, 11),
(5, 12),
(5, 16),
(5, 20),
(5, 7),
(6, 11),
(6, 6),
(6, 7),
(6, 14),
(6, 15),
(7, 15),
(7, 13),
(7, 9),
(7, 17),
(7, 20),
(7, 8),
(8, 20),
(8, 11),
(8, 7),
(9, 14),
(9, 9),
(9, 2),
(9, 11),
(9, 1),
(9, 20),
(9, 7),
(10, 3),
(10, 20),
(10, 2),
(10, 10),
(10, 16),
(11, 20),
(11, 5),
(11, 2),
(11, 14),
(11, 18),
(12, 12),
(12, 2),
(12, 6),
(12, 18),
(12, 1),
(12, 8),
(12, 10),
(13, 15),
(13, 6),
(13, 5),
(13, 19),
(13, 17),
(14, 19),
(14, 9),
(14, 17),
(14, 10),
(14, 5),
(14, 8),
(15, 13), 
(15, 5),
(15, 18),
(15, 19),
(15, 2),
(15, 12),
(16, 12),
(16, 5),
(16, 4),
(16, 2),
(17, 1),
(17, 8),
(17, 11),
(17, 15),
(17, 9),
(17, 19),
(17, 7),
(18, 18),
(18, 15),
(18, 13),
(18, 7),
(19, 5),
(19, 17),
(19, 7),
(19, 13),
(19, 14),
(20, 19),
(20, 11),
(20, 4),
(20, 13),
(20, 8),
(20, 20),
(20, 16),
(21, 4),
(21, 2),
(21, 20),
(21, 16),
(21, 13),
(21, 9),
(22, 12),
(22, 20),
(22, 16),
(22, 15),
(22, 10),
(22, 3),
(23, 1),
(23, 4),
(23, 9),
(23, 7),
(23, 2),
(24, 8),
(24, 14),
(24, 16),
(24, 11),
(24, 1),
(24, 20),
(24, 10);