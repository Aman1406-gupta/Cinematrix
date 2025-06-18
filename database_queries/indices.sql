CREATE INDEX idx_movies_title ON Movies (Title);
CREATE INDEX idx_movies_release_date ON Movies (Release_Date);
CREATE INDEX idx_movies_rating ON Movies (Movie_Rating);

CREATE INDEX idx_tvshows_title ON TV_Shows (Title);
CREATE INDEX idx_tvshows_start_date ON TV_Shows (Start_Date);
CREATE INDEX idx_tvshows_rating ON TV_Shows (TVShow_Rating);

CREATE INDEX idx_episodes_show ON Episodes (Show_ID);
CREATE INDEX idx_episodes_title ON Episodes (Title);
CREATE INDEX idx_episodes_release_date ON Episodes (Release_Date);
CREATE INDEX idx_episodes_rating ON Episodes (Episode_Rating);

CREATE INDEX idx_genres_name ON Genres (Genre_Name);

CREATE INDEX idx_awards_name ON Awards (Award_Name);
CREATE INDEX idx_awards_category ON Awards (Award_Category);

CREATE INDEX idx_people_full_name ON People (Person_First_Name, Person_Last_Name);
CREATE INDEX idx_people_dob ON People (Person_DOB);
CREATE INDEX idx_people_nationality ON People (Person_Nationality);

CREATE INDEX idx_director_style ON Director (Directorial_Style);

CREATE INDEX idx_producer_methodology ON Producer (Production_Methodology);

CREATE INDEX idx_actor_role_range ON Actor (Role_Range);

CREATE INDEX idx_languages_name ON Languages (Language_Name);

CREATE INDEX idx_reviews_user ON Reviews (User_ID);
CREATE INDEX idx_reviews_rating ON Reviews (Media_Rating);
CREATE INDEX idx_reviews_date ON Reviews (Review_Date);

CREATE INDEX idx_users_id ON Users (User_ID);
CREATE INDEX idx_users_username ON Users (Username);
CREATE INDEX idx_users_mail ON Users (User_Mail);

CREATE INDEX idx_streaming_sites_name ON Streaming_Sites (Site_Name);

CREATE INDEX idx_age_ratings_name ON Age_Ratings (Age_Rating_Name);

CREATE INDEX idx_movie_genre ON movieIsOfGenre (Movie_ID);
CREATE INDEX idx_genre_movie ON movieIsOfGenre (Genre_ID);

CREATE INDEX idx_movie_director ON movieDirectedBy (Movie_ID);
CREATE INDEX idx_director_movie ON movieDirectedBy (Director_ID);

CREATE INDEX idx_movie_producer ON movieProducedBy (Movie_ID);
CREATE INDEX idx_producer_movie ON movieProducedBy (Producer_ID);

CREATE INDEX idx_movie_acted_by_movie ON movieActedBy (Movie_ID);
CREATE INDEX idx_movie_acted_by_actor ON movieActedBy (Actor_ID);

CREATE INDEX idx_movie_awarded_movie ON movieAwarded (Movie_ID);
CREATE INDEX idx_movie_awarded_award ON movieAwarded (Award_ID);

CREATE INDEX idx_movie_available_in_movie ON movieAvailableIn (Movie_ID);
CREATE INDEX idx_movie_available_in_language ON movieAvailableIn (Language_ID);

CREATE INDEX idx_movie_reviewed_movie ON movieReviewed (Movie_ID);

CREATE INDEX idx_movie_streams_here_movie ON movieStreamsHere (Movie_ID);
CREATE INDEX idx_movie_streams_here_site ON movieStreamsHere (Site_ID);

CREATE INDEX idx_show_is_of_genre_show ON showIsOfGenre (Show_ID);
CREATE INDEX idx_show_is_of_genre_genre ON showIsOfGenre (Genre_ID);

CREATE INDEX idx_show_directed_by_show ON showDirectedBy (Show_ID);
CREATE INDEX idx_show_directed_by_director ON showDirectedBy (Director_ID);

CREATE INDEX idx_show_produced_by_show ON showProducedBy (Show_ID);
CREATE INDEX idx_show_produced_by_producer ON showProducedBy (Producer_ID);

CREATE INDEX idx_show_acted_by_show ON showActedBy (Show_ID);
CREATE INDEX idx_show_acted_by_actor ON showActedBy (Actor_ID);

CREATE INDEX idx_show_awarded_show ON showAwarded (Show_ID);
CREATE INDEX idx_show_awarded_award ON showAwarded (Award_ID);

CREATE INDEX idx_show_available_in_show ON showAvailableIn (Show_ID);
CREATE INDEX idx_show_available_in_language ON showAvailableIn (Language_ID);

CREATE INDEX idx_show_reviewed_show ON showReviewed (Show_ID);

CREATE INDEX idx_show_streams_here_show ON showStreamsHere (Show_ID);
CREATE INDEX idx_show_streams_here_site ON showStreamsHere (Site_ID);

CREATE INDEX idx_episode_directed_by_episode ON episodeDirectedBy (Show_ID, Episode_Number, Season_Number);
CREATE INDEX idx_episode_directed_by_director ON episodeDirectedBy (Director_ID);

CREATE INDEX idx_episode_produced_by_episode ON episodeProducedBy (Show_ID, Episode_Number, Season_Number);
CREATE INDEX idx_episode_produced_by_producer ON episodeProducedBy (Producer_ID);

CREATE INDEX idx_episode_acted_by_episode ON episodeActedBy (Show_ID, Episode_Number, Season_Number);
CREATE INDEX idx_episode_acted_by_actor ON episodeActedBy (Actor_ID);

CREATE INDEX idx_episode_reviewed_episode ON episodeReviewed (Show_ID, Episode_Number, Season_Number);

CREATE INDEX idx_person_awarded_person ON personAwarded (Person_ID);
CREATE INDEX idx_person_awarded_award ON personAwarded (Award_ID);

CREATE INDEX idx_movie_sequel_movie ON movieSequel (Movie_ID);
CREATE INDEX idx_movie_sequel_sequel ON movieSequel (Sequel_ID);

CREATE INDEX idx_movie_prequel_movie ON moviePrequel (Movie_ID);
CREATE INDEX idx_movie_prequel_prequel ON moviePrequel (Prequel_ID);
