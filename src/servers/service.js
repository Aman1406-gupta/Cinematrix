let bcrypt=require("bcrypt");
const { mysqlConnection, mongo } = require('../dbconnection');
// const nodemailer= require("nodemailer");
// let recu=require("../model/user");
// let product=require("../model/product")
// let transactiondata=require("../model/transactiondata")
let jwt=require("jsonwebtoken");
require("dotenv").config();
let rootmail;
let newdata;

// function update_amount(previous_amount,new_amount){
//     let amount=previous_amount+(new_amount*0.25);
//     return (amount);
// }

////////////////////////////////

exports.ser_home=async(req,rep)=>{
    return new Promise((resolve, reject) => {
        mysqlConnection.query('SELECT * FROM Users WHERE User_Mail = ?', [rootmail], (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }

            if (results.length === 0) {
                console.log("Admin doesn't exist");
                return reject(new Error("Admin doesn't exist"));
            }

            const admindatarec = results[0];
            resolve( { admindatarec } );
        });
    });
}

exports.ser_insert=async (req,rep)=>{
    let name=req.body.name;
    let email=req.body.email;
    let dob=req.body.dob;
    let Nationality=req.body.nationality;
    let pass=req.body.pass;
    let hashpass=await bcrypt.hash(pass,10);
    let terms=req.body.terms;
    let watchlisturl = `/watchlist/${name.replace(/\s+/g, '_').toLowerCase()}`;

    return new Promise((resolve, reject) => {
        mysqlConnection.query('SELECT * FROM Users WHERE User_Mail = ?', [email], (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }

            const previousdata = results[0];

            if(previousdata){
                console.log("unable to create account, email already exist as user");
                rep.redirect("/signup");
            }
            else{
                mysqlConnection.query(
                    'INSERT INTO Users (Username, User_Mail, User_Password_Encrypted, User_Role, User_DOB, User_Country, Watchlist_URL) values (?, ?, ?, "User", ?, ?, ?)', [name, email, hashpass, dob, Nationality, watchlisturl],
                    (err, Result) => {
                        if (err) {
                            console.error('Token update failed:', err);
                            return reject(new Error("Token update failed"));
                        }

                        if (Result.affectedRows === 0) {
                            console.error('No rows updated');
                            return reject(new Error("No rows updated"));
                        }

                        console.log('Your account has been created!');
                        rep.redirect("/signin")
                    }
                );
            }
        });
    });
}

exports.ser_validation = (req, rep) => {
    return new Promise((resolve, reject) => {
        const email = req.body.email;
        const pass = req.body.pass;
        
        mysqlConnection.query('SELECT * FROM Users WHERE User_Mail = ?', [email], (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }

            if (results.length === 0) {
                console.log("Admin doesn't exist");
                return reject(new Error("Admin doesn't exist"));
            }

            // const newdata = results[0];
            newdata = results[0];   
            rootmail=newdata.User_Mail;

            bcrypt.compare(pass, newdata.User_Password_Encrypted, (err, isPasswordValid) => {
                if (err) {
                    console.error('Password comparison failed:', err);
                    return reject(new Error("Password comparison failed"));
                }

                if (!isPasswordValid) {
                    console.log('Password is incorrect');
                    return reject(new Error("Incorrect password"));
                }

                const token = jwt.sign({ id: newdata.User_ID }, process.env.secret_key);
                if (!token) {
                    console.error('Unable to generate token');
                    return reject(new Error("Token generation failed"));
                }

                mysqlConnection.query(
                    'UPDATE Users SET User_Authentication_Key = ? WHERE User_ID = ?',
                    [token, newdata.User_ID],
                    (err, updateResult) => {
                        if (err) {
                            console.error('Token update failed:', err);
                            return reject(new Error("Token update failed"));
                        }

                        if (updateResult.affectedRows === 0) {
                            console.error('No rows updated');
                            return reject(new Error("No rows updated"));
                        }

                        console.log('You are logged in');
                        rep.cookie("token", token);
                        resolve( { newdata } );
                    }
                );
            });
        });
    });
};

exports.ser_adminprofile=async(req,rep)=>{
    return new Promise((resolve, reject) => {
        mysqlConnection.query('SELECT User_ID, Username, User_Mail, User_Password_Encrypted, User_Role, User_Authentication_Key, User_DOB, User_Country, Watchlist_URL, DATE_FORMAT(User_Last_Online, "%H:%i %Y-%m-%d") AS User_Last_Online, DATE_FORMAT(User_Join_Date, "%Y-%m-%d") AS User_Join_Date FROM Users WHERE User_Mail = ?', [rootmail], (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }

            if (results.length === 0) {
                console.log("Admin doesn't exist");
                return reject(new Error("Admin doesn't exist"));
            }
            const admindatarec = results[0];
            resolve( { admindatarec } );
        });
    });
}

exports.ser_userprofileupdate=async(req,rep)=>{

    let user_password=req.body.pass;
    let user_name=req.body.name;
    let hashpass=await bcrypt.hash(user_password,10);
    if (!user_password) {
        rep.redirect('/adminprofile');
    }

    return new Promise((resolve, reject) => {
        mysqlConnection.query('UPDATE Users set User_Password_Encrypted = ?, Username = ? where User_Mail = ?', [hashpass, user_name, rootmail], (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }

            if (results.length === 0) {
                console.log("Admin doesn't exist");
                return reject(new Error("Admin doesn't exist"));
            }
            console.log('Details changed successfully');
            rep.redirect('/adminprofile');
        });
    });
}

exports.ser_signout=async(req,rep)=>{
    try{
        rep.clearCookie("token");
        return new Promise((resolve, reject) => {
            mysqlConnection.query('UPDATE Users set User_Authentication_Key = NULL where User_Mail = ?', [rootmail], (err, results) => {
                if (err) {
                    console.error('Error in logging out!', err);
                    return reject(new Error("Database query failed"));
                }
                if (results.length === 0) {
                    console.log("Admin doesn't exist");
                    return reject(new Error("Admin doesn't exist"));
                }
                console.log("You have been logged out successfully!")
                resolve();
            });
        });
    }
    catch{
        console.log("error in setting cookie null")
    }
}

exports.ser_deleteac=async(req,rep)=>{
    try{
        rep.clearCookie("token");
        return new Promise((resolve, reject) => {
            mysqlConnection.query('DELETE from Users where User_Mail = ?', [rootmail], (err, results) => {
                if (err) {
                    console.error('Error in deleting account!', err);
                    return reject(new Error("Database query failed"));
                }
                if (results.length === 0) {
                    console.log("Admin doesn't exist");
                    return reject(new Error("Admin doesn't exist"));
                }
                console.log("Your account has been deleted successfully!")
                resolve();
            });
        });
    }
    catch{
        console.log("error in setting cookie null")
    }
}

exports.ser_showmovie=async(req,rep,flag)=>{
    let message = "";
    if (flag == 0) {
        return new Promise((resolve, reject) => {
            mysqlConnection.query('SELECT Movie_ID, Title as Movie_Title, YEAR(Release_Date) as Year_Of_Release, Movie_Rating, Num_Ratings_Movies FROM movies;', (err, results) => {
                if (err) {
                    console.error('Database query failed:', err);
                    return reject(new Error("Database query failed"));
                }
                if (results.length === 0) {
                    message = "No movies for the given filter exists!";
                }
                const moviedata = results;
                resolve( { moviedata, newdata, message } );
            });
        });
    }
    else {
        return new Promise((resolve, reject) => {
            const title = req.body.filtertitle;
            const age = req.body.filterage;
            const genre = req.body.filtergenre;
            const language = req.body.filterlanguage;
            const year = req.body.filteryear;
            let awardcat = req.body.filterawardcat;
            const minrevenue = req.body.filterminrevenue;
            const order = req.body.filterorder;
    
            if (awardcat != 'IS NOT NULL OR AW.Award_Name IS NULL)') {
                awardcat = "= '" + awardcat + "')";
            }
            
            let query = `   SELECT DISTINCT * FROM
                                (SELECT 
                                    M.Movie_ID,
                                    M.Title AS Movie_Title,
                                    YEAR(M.Release_Date) AS Year_Of_Release,
                                    M.Movie_Rating,
                                    M.Num_Ratings_Movies
                                FROM 
                                    Movies M
                                    JOIN movieIsOfGenre MG ON M.Movie_ID = MG.Movie_ID
                                    JOIN Genres G ON MG.Genre_ID = G.Genre_ID
                                    JOIN movieAvailableIn MA ON M.Movie_ID = MA.Movie_ID
                                    JOIN Languages L ON MA.Language_ID = L.Language_ID
                                    LEFT JOIN movieAwarded MAW ON M.Movie_ID = MAW.Movie_ID
                                    LEFT JOIN Awards AW ON MAW.Award_ID = AW.Award_ID
                                WHERE 
                                    TRUE
                                    AND M.Title LIKE ? 
                                    AND G.Genre_Name LIKE ? 
                                    AND L.Language_Name LIKE ?
                                    AND (AW.Award_Category ${awardcat}
                                    AND M.Revenue > ? 
                                    AND YEAR(M.Release_Date) > ? 
                                    AND M.Age_Rating_ID IN (
                                        SELECT Age_Rating_ID 
                                        FROM Age_Ratings 
                                        WHERE Age_Rating_Name LIKE ?
                                    )
                                ) INTERMEDIATE 
                                ${order};`;
            mysqlConnection.query(query,[title,genre,language,minrevenue,year,age],(err, results) => {
                if (err) {
                    console.error('Database query failed:', err);
                    return reject(new Error("Database query failed"));  
                }
                if (results.length === 0) {
                    message = "No movie for the given filter exists!";
                }
                const moviedata = results;
                resolve( { moviedata, newdata, message } );
            });
        });
    }
}

exports.ser_tpshowmovie=async(req,rep)=>{
    return new Promise((resolve, reject) => {
        mysqlConnection.query('SELECT Movie_ID, Title, YEAR(Release_Date) Release_Year, Movie_Rating, Num_Ratings_Movies FROM Movies ORDER BY Movie_Rating DESC LIMIT 20;', (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }

            if (results.length === 0) {
                console.log("Movies don't exist");
                return reject(new Error("Movies don't exist"));
            }
            const moviedata = results;
            resolve( { moviedata, newdata } );
        });
    });
}

exports.ser_reshowmovie=async(req,rep)=>{
    return new Promise((resolve, reject) => {
        mysqlConnection.query('SELECT Movie_ID, Title, YEAR(Release_Date) Release_Year, Movie_Rating, Num_Ratings_Movies FROM Movies ORDER BY Release_Date DESC LIMIT 20;', (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }

            if (results.length === 0) {
                console.log("Movies don't exist");
                return reject(new Error("Movies don't exist"));
            }
            const moviedata = results;
            resolve( { moviedata, newdata } );
        });
    });
}

exports.ser_seriesshow=async(req,rep,flag)=>{
    let message = "";
    if(flag==0){    
        return new Promise((resolve, reject) => {
            let query = `
                        SELECT 
                            TS.Show_ID,
                            TS.Title AS TVShow_Title,
                            COUNT(DISTINCT E.Season_Number) AS Number_Of_Seasons,
                            YEAR(TS.Start_Date) AS Start_Year,
                            TS.TVShow_Rating,
                            TS.Num_Ratings_TV
                        FROM 
                            TV_Shows TS
                            JOIN showIsOfGenre SG ON TS.Show_ID = SG.Show_ID
                            JOIN Episodes E ON TS.Show_ID = E.Show_ID
                        GROUP BY 
                            TS.Show_ID;
                        `;
            mysqlConnection.query(query, (err, results) => {
                if (err) {
                    console.error('Database query failed:', err);
                    return reject(new Error("Database query failed"));
                }
    
                if (results.length === 0) {
                    message = "No series for the given filter exists!";
                }
                const seriesdata = results;
                resolve( { seriesdata, newdata, message } );
            });
        });
    }
    else{
        return new Promise((resolve, reject) => {
            const title = req.body.filtertitle;
            const age = req.body.filterage;
            const genre = req.body.filtergenre;
            const language = req.body.filterlanguage;
            const year = req.body.filteryear;
            let awardcat = req.body.filterawardcat;
            const order = req.body.filterorder;

            if (awardcat != 'IS NOT NULL OR AW.Award_Name IS NULL)') {
                awardcat = "= '" + awardcat + "')";
            }

            let query = `SELECT DISTINCT * FROM
                                    (SELECT 
                                        TS.Show_ID,
                                        TS.Title AS TVShow_Title,
                                        COUNT(DISTINCT E.Season_Number) AS Number_Of_Seasons,
                                        YEAR(TS.Start_Date) AS Start_Year,
                                        TS.TVShow_Rating,
                                        TS.Num_Ratings_TV
                                    FROM 
                                        TV_Shows TS
                                        JOIN showIsOfGenre SG ON TS.Show_ID = SG.Show_ID
                                        JOIN Genres G ON SG.Genre_ID = G.Genre_ID
                                        JOIN showAvailableIn SA ON TS.Show_ID = SA.Show_ID
                                        JOIN Languages L ON SA.Language_ID = L.Language_ID
                                        LEFT JOIN showAwarded SW ON TS.Show_ID = SW.Show_ID
                                        LEFT JOIN Awards AW ON SW.Award_ID = AW.Award_ID
                                        JOIN Episodes E ON TS.Show_ID = E.Show_ID
                                    WHERE 
                                        TS.Title LIKE ?
                                        AND G.Genre_Name LIKE ?
                                        AND L.Language_Name LIKE ?
                                        AND (AW.Award_Category ${awardcat}
                                        AND YEAR(TS.Start_Date) > ?
                                        AND TS.Age_Rating_ID IN (
                                            SELECT Age_Rating_ID 
                                            FROM Age_Ratings 
                                            WHERE Age_Rating_Name LIKE ?
                                        )
                                    GROUP BY 
                                        TS.Show_ID
                                    ) INTERMEDIATE 
                                    ${order};`;

                mysqlConnection.query(query,[title,genre,language,year,age],(err, results) => {
                if (err) {
                    console.error('Database query failed:', err);
                    return reject(new Error("Database query failed"));
                }
    
                if (results.length === 0) {
                    message = "No series for the given filter exists!";
                }
                const seriesdata = results;
                resolve( { seriesdata, newdata, message } );
            });
        });
    }
}

exports.ser_tpseriesshow=async(req,rep)=>{
    return new Promise((resolve, reject) => {
        mysqlConnection.query('SELECT S.Show_ID, S.Title, N.Number_Of_Seasons, YEAR(S.Start_Date) Release_Year, S.TVShow_Rating, S.Num_Ratings_TV FROM TV_Shows S JOIN (SELECT  Show_ID, COUNT(DISTINCT(Season_Number)) Number_Of_Seasons FROM Episodes GROUP BY Show_ID) N ON N.Show_ID = S.Show_ID ORDER BY S.TVShow_Rating DESC LIMIT 20;', (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }

            if (results.length === 0) {
                console.log("Series don't exist");
                return reject(new Error("Series don't exist"));
            }
            const seriesdata = results;
            resolve( { seriesdata, newdata } );
        });
    });
}

exports.ser_reseriesshow=async(req,rep)=>{
    return new Promise((resolve, reject) => {
        mysqlConnection.query('SELECT S.Show_ID, S.Title, N.Number_Of_Seasons, YEAR(S.Start_Date) Release_Year, S.TVShow_Rating, S.Num_Ratings_TV FROM TV_Shows S JOIN (SELECT  Show_ID, COUNT(DISTINCT(Season_Number)) Number_Of_Seasons FROM Episodes GROUP BY Show_ID) N ON N.Show_ID = S.Show_ID ORDER BY S.Start_Date DESC LIMIT 20;', (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }

            if (results.length === 0) {
                console.log("Series don't exist");
                return reject(new Error("Series don't exist"));
            }
            const seriesdata = results;
            resolve( { seriesdata, newdata } );
        });
    });
}

exports.ser_celebview=async(req,rep,flag)=>{
    let message = "";
    if(flag == 0){
        return new Promise((resolve, reject) => {
            mysqlConnection.query(`SELECT Person_ID, CONCAT(Person_First_Name," ",Person_Last_Name) Full_Name, Person_Gender, FLOOR(DATEDIFF(CURDATE(), Person_DOB) / 365.25) Age FROM People;
                SELECT DISTINCT(Person_Nationality) AS Nationality FROM People ORDER BY Nationality ASC;`, (err, results) => {
                if (err) {
                    console.error('Database query failed:', err);
                    return reject(new Error("Database query failed"));
                }
                if (results[0].length === 0) {
                    message = "No Celebrity for the given filter exists!";
                }
                const celebdata = results[0];
                const nationalitydata = results[1];
                resolve( { celebdata,newdata,message,nationalitydata } );
            });
        });
    }
    else{
        return new Promise((resolve, reject) => {
            const name = req.body.filtername;
            const gender = req.body.filtergender;
            const nationality = req.body.filternationality;
            const profession = req.body.filterprofession;

            let prof2 = profession;
            if (profession == "People") {
                prof2 = "Person";
            }
            let query = `   SELECT DISTINCT * FROM
                                (SELECT 
                                    P.Person_ID,
                                    CONCAT(P.Person_First_Name, ' ', P.Person_Last_Name) AS Full_Name,
                                    P.Person_Gender,
                                    YEAR(CURDATE()) - YEAR(P.Person_DOB) - (DATE_FORMAT(CURDATE(), '%m%d') < DATE_FORMAT(P.Person_DOB, '%m%d')) AS Age
                                FROM 
                                    People P
                                JOIN 
                                    ${profession} T ON P.Person_ID = T.${prof2}_ID
                                WHERE 
                                    (P.Person_First_Name LIKE ? OR P.Person_Last_Name LIKE ?)
                                    AND P.Person_Gender LIKE ?
                                    AND P.Person_Nationality LIKE ?
                                GROUP BY 
                                    P.Person_ID
                                ) INTERMEDIATE 
                                ;
                                SELECT DISTINCT(Person_Nationality) AS Nationality FROM People ORDER BY Nationality ASC;`;
            mysqlConnection.query(query,[name,name,gender,nationality],(err, results) => {
                if (err) {
                    console.error('Database query failed:', err);
                    return reject(new Error("Database query failed"));  
                }
                if (results[0].length === 0) {
                    message = "No Celebrity for the given filter exists!";
                }
                const celebdata = results[0];
                const nationalitydata = results[1];
                resolve( { celebdata,newdata,message,nationalitydata } );
            });
        }); 
    }
}

exports.ser_pcelebview=async(req,rep)=>{
    return new Promise((resolve, reject) => {
        mysqlConnection.query('SELECT Person_ID, CONCAT(Person_First_Name," ",Person_Last_Name) Celebrity_Name, Person_Gender, FLOOR(DATEDIFF(CURDATE(), Person_DOB) / 365.25) Age FROM People ORDER BY Person_DOB DESC LIMIT 20;', (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }

            if (results.length === 0) {
                console.log("Celebs don't exist");
                return reject(new Error("Celebs don't exist"));
            }
            const celebdata = results;
            resolve( { celebdata, newdata } );
        });
    });
}

exports.ser_btcelebview=async(req,rep)=>{
    return new Promise((resolve, reject) => {
        mysqlConnection.query('SELECT Person_ID, CONCAT(Person_First_Name, " ", Person_Last_Name) Celebrity_Name, Person_Gender, FLOOR(DATEDIFF(CURDATE(), Person_DOB) / 365.25) Age, DATE_FORMAT(Person_DOB, "%Y-%m-%d") Person_DOB FROM People WHERE MONTH(Person_DOB) = MONTH(CURDATE()) AND DAY(Person_DOB) = DAY(CURDATE());', (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }
            let message = {message: ""};
            if (results.length === 0) {
                message = {message: "No celebrities were born today"};
            }
            const celebdata = results;
            resolve( { celebdata, message, newdata } );
        });
    });
}

exports.ser_view_movie_details=async(movieid,rep)=>{
    return new Promise((resolve, reject) => {
        mysqlConnection.query(`
            SELECT Movie_ID, Description, Title, Movie_Rating, DATE_FORMAT(Release_Date, "%Y-%m-%d") Release_Date, Num_Ratings_Movies, Budget, Revenue, Duration, Movie_Trailer_URL, Age_Rating_Name FROM Movies JOIN age_ratings ON Movies.Age_Rating_ID = age_ratings.Age_Rating_ID where Movie_ID=?;
            SELECT G.Genre_Name FROM Genres G JOIN movieIsOfGenre MIG ON G.Genre_ID = MIG.Genre_ID WHERE MIG.Movie_ID = ?;
            SELECT L.Language_Name FROM movieAvailableIn MA JOIN Languages L ON MA.Language_ID = L.Language_ID WHERE MA.Movie_ID = ?;
            SELECT A.Award_Name, A.Award_Category, MA.Year_Of_Awarding FROM movieAwarded MA JOIN Awards A ON MA.Award_ID = A.Award_ID WHERE MA.Movie_ID = ?;
            SELECT MA.Actor_ID, CONCAT(A.Person_First_Name, ' ', A.Person_Last_Name) AS Actor_Name, MA.Character_Name, MA.Role_Type FROM movieActedBy MA JOIN Actor AC ON MA.Actor_ID = AC.Actor_ID JOIN People A ON MA.Actor_ID = A.Person_ID WHERE MA.Movie_ID = ?;
            SELECT MD.Director_ID, CONCAT(P.Person_First_Name, ' ', P.Person_Last_Name) AS Director_Name, D.Directorial_Style FROM movieDirectedBy MD JOIN Director D ON MD.Director_ID = D.Director_ID JOIN People P ON MD.Director_ID = P.Person_ID WHERE MD.Movie_ID = ?;
            SELECT PR.Producer_ID, CONCAT(P.Person_First_Name, ' ', P.Person_Last_Name) AS Producer_Name, PR.Production_Methodology FROM movieProducedBy MP JOIN Producer PR ON MP.Producer_ID = PR.Producer_ID JOIN People P ON MP.Producer_ID = P.Person_ID WHERE MP.Movie_ID = ?;
            SELECT * FROM (SELECT MS.Movie_ID, S.Site_Name, S.Site_URL, S.Subscription_Starting_Price FROM Streaming_Sites S JOIN movieStreamsHere MS ON S.Site_ID = MS.Site_ID) INTERMEDIATE WHERE Movie_ID = ?;
            SELECT M.Movie_ID, M.Title AS Prequel_Title, YEAR(M.Release_Date) Release_Year, M.Movie_Rating, M.Num_Ratings_Movies FROM moviePrequel MP JOIN Movies M ON MP.Prequel_ID = M.Movie_ID WHERE MP.Movie_ID = ?;
            SELECT M.Movie_ID, M.Title AS Sequel_Title, YEAR(M.Release_Date) Release_Year, M.Movie_Rating, M.Num_Ratings_Movies FROM movieSequel MS JOIN Movies M ON MS.Sequel_ID = M.Movie_ID WHERE MS.Movie_ID = ?;
            SELECT U.User_ID, MR.Movie_ID, MR.Review_ID, U.Username, Review_Comment, Media_Rating, Like_Count, Dislike_Count, CONCAT(TIMESTAMPDIFF(DAY, R.Review_Date, NOW()), ' days ago') AS Days_Since_Review FROM movieReviewed MR JOIN Reviews R ON MR.Review_ID = R.Review_ID JOIN Users U ON R.User_ID = U.User_ID WHERE MR.Movie_ID = ?;
                `, [movieid, movieid, movieid, movieid, movieid, movieid, movieid, movieid, movieid, movieid, movieid], (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }

            if (results[0].length === 0) {
                console.log("Movie doesn't exist");
                return reject(new Error("Movie doesn't exist"));
            }
            const moviedetails = results[0][0];
            const genredetails = results[1];
            const languagedetails = results[2];
            const awarddetails = results[3];
            const actordetails = results[4];
            const directordetails = results[5];
            const producerdetails = results[6];
            const streamdetails = results[7];
            const prequeldetails = results[8];
            const sequeldetails = results[9];
            const reviewdetails = results[10];
            resolve( { moviedetails,genredetails,languagedetails,awarddetails,actordetails,directordetails,producerdetails,streamdetails,prequeldetails,sequeldetails,reviewdetails,newdata } );
        });
    });    
}

exports.ser_view_tvshow_details=async(tvshowid,rep)=>{
    return new Promise((resolve, reject) => {
        mysqlConnection.query(`SELECT Show_ID, Title, DATE_FORMAT(Start_Date, "%Y-%m-%d") Start_Date, DATE_FORMAT(End_Date, "%Y-%m-%d") End_Date, TVShow_Rating, Num_Ratings_TV, Description, TVShow_Trailer_URL, Age_Rating_Name FROM TV_Shows JOIN age_ratings on tv_shows.Age_Rating_ID = age_ratings.Age_Rating_ID where Show_ID = ?;
                               SELECT E.Show_ID, COUNT(DISTINCT E.Season_Number) AS Number_of_Seasons, COUNT(*) AS Number_of_Episodes FROM Episodes E WHERE E.Show_ID = ? GROUP BY E.Show_ID;    
                               SELECT Show_ID, Season_Number, Episode_Number, Title, DATE_FORMAT(Release_Date, "%Y-%m-%d") Release_Date, Episode_Rating, Num_Ratings_Ep FROM Episodes WHERE Show_ID = ? ORDER BY Season_Number ASC;
                               SELECT G.Genre_Name FROM showisofgenre SG JOIN Genres G ON SG.Genre_ID = G.Genre_ID WHERE SG.Show_ID = ?;
                               SELECT AC.Actor_ID, CONCAT(A.Person_First_Name, ' ', A.Person_Last_Name) AS Actor_Name, SA.Character_Name, SA.Role_Type FROM showActedBy SA JOIN Actor AC ON SA.Actor_ID = AC.Actor_ID JOIN People A ON SA.Actor_ID = A.Person_ID WHERE SA.Show_ID = ?;
                               SELECT D.Director_ID, CONCAT(P.Person_First_Name, ' ', P.Person_Last_Name) AS Director_Name, D.Directorial_Style FROM showDirectedBy SD JOIN Director D ON SD.Director_ID = D.Director_ID JOIN People P ON SD.Director_ID = P.Person_ID WHERE SD.Show_ID = ?;
                               SELECT PR.Producer_ID, CONCAT(P.Person_First_Name, ' ', P.Person_Last_Name) AS Producer_Name, PR.Production_Methodology FROM showProducedBy SP JOIN Producer PR ON SP.Producer_ID = PR.Producer_ID JOIN People P ON SP.Producer_ID = P.Person_ID WHERE SP.Show_ID = ?;
                               SELECT A.Award_Name, A.Award_Category, SA.Year_Of_Awarding FROM showAwarded SA JOIN Awards A ON SA.Award_ID = A.Award_ID WHERE SA.Show_ID = ?;
                               SELECT L.Language_Name FROM showAvailableIn SA JOIN Languages L ON SA.Language_ID = L.Language_ID WHERE SA.Show_ID = ?;
                               SELECT * FROM (SELECT SS.Show_ID, S.Site_Name, S.Site_URL, S.Subscription_Starting_Price FROM Streaming_Sites S JOIN showstreamshere SS ON S.Site_ID = SS.Site_ID) INTERMEDIATE WHERE Show_ID = ?;
                               SELECT U.User_ID, SR.Show_ID, SR.Review_ID, U.Username, Review_Comment, Media_Rating, Like_Count, Dislike_Count, CONCAT(TIMESTAMPDIFF(DAY, R.Review_Date, NOW()), ' days ago') AS Days_Since_Review FROM showReviewed SR JOIN Reviews R ON SR.Review_ID = R.Review_ID JOIN Users U ON R.User_ID = U.User_ID WHERE SR.Show_ID = ?;
                              `,[tvshowid,tvshowid,tvshowid,tvshowid,tvshowid,tvshowid,tvshowid,tvshowid,tvshowid,tvshowid,tvshowid], (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }

            if (results[0].length === 0) {
                console.log("tvshow doesn't exist");
                return reject(new Error("tvshow doesn't exist"));
            }
            const tvshowdetails = results[0][0];
            const seaandepdata=results[1][0];
            const episodedetails=results[2];
            const genredetails=results[3];
            const actordetails=results[4];
            const directordetails=results[5];
            const producerdetails=results[6];
            const awarddetails=results[7];
            const languagedetails=results[8];
            const streamdetails=results[9];
            const reviewdetails = results[10];
            resolve( { tvshowdetails,seaandepdata,episodedetails,genredetails,actordetails,directordetails,producerdetails,awarddetails,languagedetails,streamdetails,reviewdetails,newdata } );
        });
    });
}

exports.ser_view_episode_details=async(tvshowid,sno,eno,rep)=>{
    return new Promise((resolve, reject) => {
        mysqlConnection.query(`SELECT E.Show_ID, E.Episode_Number, E.Season_Number, E.Title, E.Duration, DATE_FORMAT(E.Release_Date, "%Y-%m-%d") Release_Date, E.Num_Ratings_Ep, E.Episode_Rating, E.Description, T.Title Show_Title FROM Episodes E JOIN TV_Shows T ON E.Show_ID = T.Show_ID WHERE E.Show_ID = ? AND Season_Number = ? AND Episode_Number = ?;
                               SELECT P.Person_ID, CONCAT(P.Person_First_Name, ' ', P.Person_Last_Name) AS Actor_Name, EA.Character_Name, EA.Role_Type FROM episodeActedBy EA JOIN Actor AC ON EA.Actor_ID = AC.Actor_ID JOIN People P ON EA.Actor_ID = P.Person_ID WHERE EA.Show_ID = ? AND EA.Season_Number = ? AND EA.Episode_Number = ?;
                               SELECT P.Person_ID, CONCAT(P.Person_First_Name, ' ', P.Person_Last_Name) AS Director_Name, D.Directorial_Style FROM episodeDirectedBy ED JOIN Director D ON ED.Director_ID = D.Director_ID JOIN People P ON ED.Director_ID = P.Person_ID WHERE ED.Show_ID = ? AND ED.Season_Number = ? AND ED.Episode_Number = ?;
                               SELECT P.Person_ID, CONCAT(P.Person_First_Name, ' ', P.Person_Last_Name) AS Producer_Name, PR.Production_Methodology FROM episodeProducedBy EP JOIN Producer PR ON EP.Producer_ID = PR.Producer_ID JOIN People P ON EP.Producer_ID = P.Person_ID WHERE EP.Show_ID = ? AND EP.Season_Number = ? AND EP.Episode_Number = ?;
                               SELECT U.User_ID, ER.Show_ID, ER.Episode_Number, ER.Season_Number, ER.Review_ID, U.Username, Review_Comment, Media_Rating, Like_Count, Dislike_Count, CONCAT(TIMESTAMPDIFF(DAY, R.Review_Date, NOW()), ' days ago') AS Days_Since_Review FROM episodeReviewed ER JOIN Reviews R ON ER.Review_ID = R.Review_ID JOIN Users U ON R.User_ID = U.User_ID WHERE ER.Show_ID = ? AND ER.Season_Number = ? AND ER.Episode_Number = ?;
                              `,[tvshowid,sno,eno,tvshowid,sno,eno,tvshowid,sno,eno,tvshowid,sno,eno,tvshowid,sno,eno], (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }

            if (results[0].length === 0) {
                console.log("Episode doesn't exist");
                return reject(new Error("Episode doesn't exist"));
            }
            const epdetails = results[0][0];    
            const actordetails=results[1];
            const directordetails=results[2];
            const producerdetails=results[3];
            const reviewdetails = results[4];
            resolve( { epdetails,actordetails,directordetails,producerdetails,reviewdetails,newdata } );
        });
    });
}

exports.ser_view_celeb_details=async(celebid,rep)=>{
    return new Promise((resolve, reject) => {
        mysqlConnection.query(`
                                SELECT CONCAT(Person_First_Name, ' ', Person_Last_Name) AS Name, DATE_FORMAT(Person_DOB, "%Y-%m-%d") AS DOB, Person_Gender AS Gender, FLOOR(DATEDIFF(CURDATE(), Person_DOB) / 365.25) AS Age, Person_Nationality AS Nationality FROM People P WHERE Person_ID = ?;
                                SELECT Directorial_Style FROM Director WHERE Director_ID = ?;
                                SELECT Role_Range FROM Actor WHERE Actor_ID = ?;
                                SELECT Production_Methodology FROM Producer WHERE Producer_ID = ?;
                                SELECT a.Award_Name, a.Award_Category, pa.Year_Of_Awarding FROM personAwarded pa JOIN Awards a ON pa.Award_ID = a.Award_ID WHERE pa.Person_ID = ?;
                                SELECT COUNT(*) Num_Count FROM (SELECT Movie_ID FROM movieDirectedBy WHERE Director_ID = ? UNION ALL SELECT Show_ID FROM showDirectedBy WHERE Director_ID = ?) INTERMEDIATE;
                                SELECT COUNT(*) Num_Count FROM (SELECT Movie_ID FROM movieActedBy WHERE Actor_ID = ? UNION ALL SELECT Show_ID FROM showActedBy WHERE Actor_ID = ?) INTERMEDIATE;
                                SELECT COUNT(*) Num_Count FROM (SELECT Movie_ID FROM movieProducedBy WHERE Producer_ID = ? UNION ALL SELECT Show_ID FROM showProducedBy WHERE Producer_ID = ?) INTERMEDIATE;
                                SELECT m.Title AS Movie_Title, m.Num_Ratings_Movies AS Number_of_Ratings FROM Movies m JOIN movieActedBy ma ON m.Movie_ID = ma.Movie_ID WHERE ma.Actor_ID = ? ORDER BY m.Num_Ratings_Movies DESC LIMIT 1;
                                SELECT m.Title AS Movie_Title, m.Num_Ratings_Movies AS Number_of_Ratings FROM Movies m JOIN movieProducedBy mp ON m.Movie_ID = mp.Movie_ID WHERE mp.Producer_ID = ? ORDER BY m.Num_Ratings_Movies DESC LIMIT 1;
                                SELECT m.Title AS Movie_Title, m.Num_Ratings_Movies AS Number_of_Ratings FROM Movies m JOIN movieDirectedBy md ON m.Movie_ID = md.Movie_ID WHERE md.Director_ID = ? ORDER BY m.Num_Ratings_Movies DESC LIMIT 1;
                              `,[celebid,celebid,celebid,celebid,celebid,celebid,celebid,celebid,celebid,celebid,celebid,celebid,celebid,celebid], (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }

            if (results[0].length === 0) {
                console.log("celeb don't exist");
                return reject(new Error("celeb don't exist"));
            }
            const celebdata = results[0][0];
            const ds = results[1];
            const rr = results[2];
            const pm = results[3];
            const awarddetails = results[4];
            const dnum = results[5];
            const anum = results[6];
            const pnum = results[7];
            const afam = results[8];
            const pfam = results[9];
            const dfam = results[10];
            resolve( { celebdata,ds,rr,pm,awarddetails,dnum,anum,pnum,afam,pfam,dfam,newdata } );
        });
    });
}

exports.ser_awardac=async(req,rep,flag)=>{
    let message = "";
    if(flag==0){
        let awarddata = [];
        message = "dummy";
        return {awarddata, newdata, message};
    }
    else{
        return new Promise((resolve, reject) => {
            const year = req.body.filteryear;
            let awardcat = req.body.filterawardcat;

            let query = "";
            let actionpath = "";

            if (awardcat == "Best Animated Feature" || awardcat == "Best Direction" || awardcat == "Best Picture") {
                query = `SELECT 
                            M.Movie_ID as Recipient_ID,
                            CONCAT(M.Title) AS Recipient,
                            MA.Year_Of_Awarding,
                            A.Award_Category    
                        FROM 
                            movieAwarded MA
                        JOIN 
                            Movies M ON MA.Movie_ID = M.Movie_ID
                        JOIN 
                            Awards A ON MA.Award_ID = A.Award_ID 
                        WHERE 
                            A.Award_Category = '${awardcat}'
                            AND MA.Year_Of_Awarding LIKE '${year}';
                        `;
                actionpath = "/view_movie_details";
            }
            else {
                query = `SELECT 
                            P.Person_ID as Recipient_ID,
                            CONCAT(P.Person_First_Name, ' ', P.Person_Last_Name) AS Recipient,
                            PA.Year_Of_Awarding,
                            A.Award_Category    
                        FROM 
                            personAwarded PA
                        JOIN 
                            People P ON PA.Person_ID = P.Person_ID
                        JOIN 
                            Awards A ON PA.Award_ID = A.Award_ID 
                        WHERE 
                            A.Award_Category = '${awardcat}'
                            AND PA.Year_Of_Awarding LIKE '${year}';
                        `;
                actionpath = "/view_celeb_details";
            }

            mysqlConnection.query(query,(err, results) => {
                if (err) {
                    console.error('Database query failed:', err);
                    return reject(new Error("Database query failed"));  
                }
                if (results.length === 0) {
                    message = "No data found for this filter.";
                }
                const awarddata = results;
                resolve( { awarddata, newdata, message,actionpath } );
            });
        });
    }
}

exports.ser_awardem=async(req,rep,flag)=>{
    let message = "";
    if(flag==0){
        let awarddata = [];
        message = "dummy";
        return {awarddata, newdata, message};
    }
    else{
        return new Promise((resolve, reject) => {
            const year = req.body.filteryear;
            let awardcat = req.body.filterawardcat;

            let query = "";
            let actionpath = "";
            if (awardcat == "Outstanding Comedy Series" || awardcat == "Outstanding Drama Series") {
                query = `SELECT 
                            T.Show_ID as Recipient_ID,
                            CONCAT(T.Title) AS Recipient,
                            SA.Year_Of_Awarding,
                            A.Award_Category    
                        FROM 
                            showAwarded SA
                        JOIN 
                            TV_Shows T ON SA.Show_ID = T.Show_ID
                        JOIN 
                            Awards A ON SA.Award_ID = A.Award_ID 
                        WHERE 
                            A.Award_Category = '${awardcat}'
                            AND SA.Year_Of_Awarding LIKE '${year}';
                        `;
                actionpath = "/view_tvshow_details";
            }
            else {
                query = `SELECT 
                        P.Person_ID as Recipient_ID,
                        CONCAT(P.Person_First_Name, ' ', P.Person_Last_Name) AS Recipient,
                        PA.Year_Of_Awarding,
                        A.Award_Category    
                        FROM 
                        personAwarded PA
                        JOIN 
                        People P ON PA.Person_ID = P.Person_ID
                        JOIN 
                        Awards A ON PA.Award_ID = A.Award_ID 
                        WHERE 
                        A.Award_Category = '${awardcat}'
                        AND PA.Year_Of_Awarding LIKE '${year}';
                        `;
                actionpath = "/view_celeb_details";
            }
            mysqlConnection.query(query,(err, results) => {
                if (err) {
                    console.error('Database query failed:', err);
                    return reject(new Error("Database query failed"));  
                }
                if (results.length === 0) {
                    message = "No data found for this filter.";
                }
                const awarddata = results;
                resolve( { awarddata, newdata, message,actionpath } );
            });
        });
    }
}

exports.ser_deletemovie=async(req,rep,movieid)=>{
    return new Promise((resolve, reject) => {
        mysqlConnection.query('DELETE FROM Movies WHERE Movie_ID = ?;',[movieid], (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }
            console.log(`The movie with ${movieid} has been deleted`);
            resolve( { newdata } );
        });
    });
}

exports.ser_deletetvshow=async(req,rep,tvshowid)=>{
    return new Promise((resolve, reject) => {
        mysqlConnection.query('DELETE FROM TV_Shows WHERE Show_ID = ?;',[tvshowid], (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }
            console.log(`The TV Show with ${tvshowid} has been deleted`);
            resolve( { newdata } );
        });
    });
}

exports.ser_delete_review_movie=async(req,rep,reviewid)=>{
    let movieid=req.body.movieid;
    return new Promise((resolve, reject) => {
        mysqlConnection.query('DELETE FROM Reviews WHERE Review_ID =?',[reviewid], (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }
            console.log(`The Review with ${reviewid} has been deleted`);
            resolve( {movieid, newdata } );
        });
    });
}

exports.ser_delete_review_show=async(req,rep,reviewid)=>{
    let showid=req.body.showid;
    return new Promise((resolve, reject) => {
        mysqlConnection.query('DELETE FROM Reviews WHERE Review_ID =?',[reviewid], (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }
            console.log(`The Review with ${reviewid} has been deleted`);
            resolve( {showid, newdata } );
        });
    });
}

exports.ser_delete_review_episode=async(req,rep,reviewid)=>{
    let showid=req.body.showid;
    let sno=req.body.sno;
    let eno=req.body.eno;
    return new Promise((resolve, reject) => {
        mysqlConnection.query('DELETE FROM Reviews WHERE Review_ID =?',[reviewid], (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }
            console.log(`The Review with ${reviewid} has been deleted`);
            resolve( {showid,sno,eno,newdata } );
        });
    });
}

exports.ser_review_user=async(req,rep,userid)=>{
    return new Promise((resolve, reject) => {
        mysqlConnection.query('SELECT User_ID, Username, User_Mail, User_Password_Encrypted, User_Role, User_Authentication_Key, User_DOB, User_Country, Watchlist_URL, DATE_FORMAT(User_Last_Online, "%H:%i %Y-%m-%d") AS User_Last_Online, DATE_FORMAT(User_Join_Date, "%Y-%m-%d") AS User_Join_Date FROM Users WHERE User_ID = ?',[userid], (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }
            if (results.length === 0) {
                message = "No User with given username doesn't exists!";
            }
            let userdatarec = results[0];
            resolve( {userdatarec,newdata} );
        });
    });
}

//////////////////////////////

// exports.ser_registeruser=async (req,rep)=>{
//     let name=req.body.name;
//     let email=req.body.email;
//     let mobile=req.body.mobile;
//     let pass=req.body.pass;
//     let hashpass=await bcrypt.hash(pass,10);
//     let terms=req.body.terms;
//     let parentmail=rootmail;

//     let previousdata=await recu.find({email:email},{email:1})
//     if(previousdata.email){
//         console.log("unable to create account, email already exist as user");
//     }
//     else{
//         let re= new recu({
//             name:name,email:email,mobile:mobile,parentmail:parentmail,pass:hashpass,terms:terms
//         })
//         await re.save();

//         //to add user_id=_id generated default by mongodb
//         let userd=await recu.find({email:email},{});
//         let new_id;
//         for (const i of userd) {
//             new_id=i._id;
//         }
//         let user_id= await recu.findOneAndUpdate({email:email},{user_id:new_id})
//         console.log("user account has been created with user id"+" "+ new_id);

//         //for money distribution
//         let parent_wallet=recu.findOne({email:parentmail},{amount_earned:1})
//         console.log(parent_wallet)
//         if(userd.parentmail){
//             let new_parent_wallet=parent_wallet.amount_earned+250
//             let parent=recu.findOneAndUpdate({email:parentmail},{amount_earned:new_parent_wallet})
//         }
//         else{
//             let amount_earned=recu.findOneAndUpdate({email:userd.email},{amount_earned:1000})
//         }
//     }
// }

// exports.ser_addproduct=async (req,rep)=>{
//     let productname=req.body.productname;
//     let price=req.body.price;
//     let stock=req.body.stock;

//     let re= new product({
//         productname:productname,price:price,quantityleft:stock,parentmail:rootmail
//     })
//     await re.save()

//     //to add product_id=_id generated default by mongodb
    
//     let productd=await product.find({productid:""},{});
//     let new_id;

//     for (const i in productd) {
//         if (Object.hasOwnProperty.call(productd, i)) {
//             const e = productd[i];
//             new_id=e._id;
//         }
//     }
//     let product_id= await product.findOneAndUpdate({productid:""},{productid:new_id})
//     console.log("product has been inserted with product id"+" "+ new_id);

// }

// exports.ser_showproduct_admin=async(req,rep)=>{
//     let productdata=await product.find({},{})
//     let user_data=await recu.find({email:rootmail},{})
//     user_data=user_data[0];
//     console.log(user_data)
//     let parentdatashown=await recu.find({email:user_data.parentmail},{})
//     parentdatashown=parentdatashown[0];
//     return({productdata:productdata,parentdatashown:parentdatashown});
// }

// exports.ser_viewusercomodity=async(req,rep)=>{
//     let user_id=req.body.id;
//     let userdatatobeshownrec=await recu.find({user_id:user_id},{});
//     let datatobeshown;
//     console.log(userdatatobeshownrec);
//     for (const i in userdatatobeshownrec) {
//         if (Object.hasOwnProperty.call(userdatatobeshownrec, i)) {
//             const e = userdatatobeshownrec[i];
//             datatobeshown=e;
//         }
//     }
//     return(datatobeshown);
// }

// let user_id_for_update;
// let rootdata;
// exports.ser_userupdate=async(req,rep)=>{
//     let user_id=req.body.id;
//     let datashown=await recu.findOne({user_id:user_id},{})
//     user_id_for_update=datashown
//     console.log(user_id_for_update)

//     rootdata=await recu.findOne({email:rootmail},{})
//     // console.log(rootdata)
//     return({datashown:datashown,rootdata:rootdata});
// }

// exports.ser_update_points_form=async(req,rep)=>{
//     let user_id=req.body.id;
//     let datashown=await recu.find({user_id:user_id},{})
//     let finaldatashown;
//     for (const i in datashown) {
//         if (Object.hasOwnProperty.call(datashown, i)) {
//             const element = datashown[i];
//             finaldatashown=element;
//         }
//     }
//     return(finaldatashown)
// }

// exports.ser_update_points=async(req,rep)=>{
//     let user_id=req.body.id;
//     let user_details=await recu.find({user_id:user_id},{_id:0});
//     const element = user_details[0];
//     let finaldatashown=element;
//     let childdatashown=element;
    
//     let new_amount=parseInt(req.body.added_amount)
//     let previous_amount=finaldatashown.amount_earned
//     let amount_final=update_amount(previous_amount,new_amount);
    
//     await recu.findOneAndUpdate(
//         {user_id:user_id},
//         {amount_earned:amount_final,added_amount:new_amount}
//     );
//     let final_user_details_shown=await recu.find({user_id:user_id},{});
//     let parentmail=finaldatashown.parentmail;
    
//     while(parentmail && parentmail!==""){
//         // console.log(childdatashown)
//         // console.log(parentmail)
//         let parentDetails =await recu.find({ email: parentmail }, {});
//         parentDetails=parentDetails[0];
  
//         if (!parentDetails) {
//             // Handle case where parent is not found (e.g., log error)
//             console.error("Parent not found for email:", parentmail);
//             break;
//         }
//         // console.log(parentDetails)
//         let amount_final;
//         let amount_final_added=parseFloat(childdatashown.added_amount*0.75)
//         if(parentDetails.parentmail && parentDetails.parentmail!=="" ){
//             amount_final=parseFloat(parentDetails.amount_earned+(amount_final_added*0.25))
//             // Inserting transactions history
//             let re =new transactiondata(
//                 {
//                     from:childdatashown.user_id,
//                     to:parentmail,
//                     amount_transfered:(amount_final_added*0.25)
//                 }
//             )
//             console.log(amount_final_added*0.25)
//             await re.save();
//         }
//         else{
//             amount_final=parseFloat(parentDetails.amount_earned+(amount_final_added))
//             // Inserting transactions history
//             let re =new transactiondata(
//                 {
//                     from:childdatashown.user_id,
//                     to:parentmail,
//                     amount_transfered:amount_final_added
//                 }
//             )
//             console.log(amount_final_added)
//             await re.save();
//         }
//         // console.log(amount_final_added)
//         // console.log(amount_final)

//         await recu.findOneAndUpdate(
//             {email:parentmail},
//             {amount_earned:amount_final,added_amount:amount_final_added}
//         );
//         childdatashown=parentDetails;
//         parentmail=parentDetails.parentmail;

//     }
//     let rootdata1=await recu.findOne({email:rootmail},{})
//     console.log(rootdata1)
//     return ({final_user_details_shown:final_user_details_shown,data:rootdata1})
// }

// let global_product_id;
// exports.ser_buyproduct_form=async(req,rep)=>{
//     let product_id=req.body.buy
//     global_product_id=product_id;
//     let product_details=await product.findOne({_id:product_id},{})
//     return(product_details);
// }

//if we use product_id=req,body.product_id it will show undefined 
//but if we use read only in js instead of disabledthan it will show that value 
// exports.ser_buyproduct=async(req,rep)=>{
//     let buyer=await recu.findOne({email:rootmail},{})
    
//     let quantity=parseInt(req.body.quantity)

//     let product_id=global_product_id;
//     // console.log(product_id)
//     let product1=await product.findOne({_id:product_id},{})
//     // console.log(product1)

//     if(quantity>product1.quantityleft){
//         console.log("We have not enough stock available")
//     }
//     else{
//         if(product1.price > buyer.amount_earned){
//             console.log("You don't have enough money to buy");
//         }
//         else{
//             let amount_earned=buyer.amount_earned-(product1.price*quantity)

//             await recu.findOneAndUpdate(
//                 {email:rootmail},
//                 {amount_earned:amount_earned}
//             );

//             console.log("product will be delivered to you soon.")
//             console.log("your wallet amount is debited by Rs."+(product1.price*quantity))

//             let new_quantity_left=product1.quantityleft-quantity
//             // console.log(new_quantity_left)

//             await product.findOneAndUpdate(
//                 {_id:global_product_id},
//                 {quantityleft:new_quantity_left}
//             );

//             let amount_transfered=product1.price*quantity;
//             let seller=await recu.findOne(
//                 {email:"aman1406gupta@gmail.com"},
//                 {}
//             );
//             let new_amount=seller.amount_earned+amount_transfered;
//             // console.log(new_amount);

//             await recu.findOneAndUpdate(
//                 {email:"aman1406gupta@gmail.com"},
//                 {amount_earned:new_amount}
//             );

//             //inserting transaction history
//             let re =new transactiondata(
//                 {
//                     from:buyer.user_id,
//                     to:"aman1406gupta@gmail.com",
//                     amount_transfered:amount_transfered
//                 }
//             )
//             await re.save();
//         }
//     }
// }

// let current_balance;
// exports.ser_add_balance_form=async(req,rep)=>{
//     let user_info=await recu.findOne({email:rootmail},{})
//     current_balance=parseInt(user_info.amount_earned);
//     return(user_info);
// }

//if we use balance1=req.body.balance it will show undefined
//but if we use read only in js instead of disabledthan it will show that value 
// exports.ser_add_balance=async(req,rep)=>{
//     let balance1=current_balance;
//     let password=req.body.password;
//     let account_no=req.body.account_no;

//     let added_amount=parseInt(req.body.added_amount);

//     let user_info=await recu.findOne({email:rootmail},{})
//     let previous_password=user_info.pass
//     let new_amount=parseInt(balance1+added_amount);


//     let v=await bcrypt.compare(password,previous_password)
//     if(v){
//         await recu.findOneAndUpdate({email:rootmail},{amount_earned:new_amount})
//         console.log("Your wallet has been credited by Rs."+added_amount);
//     }
//     else{
//         console.log("password is incorrect");
//     }
// }

// exports.ser_update_product=async(req,rep)=>{
//     let product_name=req.body.productname;
//     let price=parseInt(req.body.price);
//     let quantity_left=parseInt(req.body.quantity_left);
//     let password=req.body.password;

//     let rootpass=await recu.findOne({email:rootmail},{});
//     rootpass=rootpass.pass;
//     let v=await bcrypt.compare(password,rootpass)

//     if(v){
//         await product.findOneAndUpdate(
//             {productid:another_productdata.productid},
//             {productname:product_name,price:price,quantityleft:quantity_left}
//         )
//         console.log("ProductDetails of product id "+another_productdata.productid+" has been updated by "+rootmail)
//     }
//     else{
//        console.log("Password is incorrect")
//     }
// }

// exports.ser_product_delete=async(req,rep)=>{
//     let productid=req.body.id;
//     await product.findOneAndDelete({productid:productid},{})
//     console.log("product of product id "+productid+" is deleted");
// }

// exports.ser_changepass=async(req,rep)=>{
//     let password=req.body.oldpass;
//     let new_password=req.body.pass;
//     let con_pass=req.body.conpass
//     let rootdata=await recu.findOne({email:rootmail},{})
//     let new_password_bcrypt=await bcrypt.hash(new_password,10)
//     // console.log(rootdata.pass)

//     let v=bcrypt.compare(password,rootdata.pass);
//     if(v  && new_password==con_pass){
//         await recu.findOneAndUpdate({email:rootmail},{pass:new_password_bcrypt})
//     }
//     else if(!v){
//         console.log("Password is incorrect")
//     }
//     else{
//         console.log("Password and Confirm Password are not same")
//     }
//     console.log("Your password is updated now ")
// }

// exports.ser_showt=async(req,rep)=>{
//     let root=await recu.findOne({email:rootmail},{})
//     let rootuser_id=root.user_id;
//     // console.log(rootuser_id)

//     let showt=await transactiondata.find({$or:[{from:rootuser_id },{to:rootmail}]},{})
//     // console.log(showt);
//     return({data:root.parentmail,tdata:showt})
// }

// exports.ser_block_user=async(req,rep)=>{
//     let block_user=req.body.id;
//     let user_status=req.body.access;

//     if(user_status=="unblock"){
//         await recu.findOneAndUpdate({user_id:block_user},{access:"block"})
//         // let accesstoken =jwt.sign({user_id:block_user},process.env.secret_key);
//         // console.log(accesstoken)
        
//         // if(!accesstoken){
//         //     throw new Error("Unable to generate token")
//         // }
//         // else{
//         //     rep.cookie("accesstoken",accesstoken)
//         //     let accesskeyinsertion=await recu.findOneAndUpdate({user_id:block_user},{access:"block",accesstoken:accesstoken})

//         //     if(!accesskeyinsertion){
//         //         throw new Error("Unable to insert accesskey")
//         //     }

//         //     else{
//         //         console.log("User is blocked")
//         //     }
//         // }
//         console.log("user id "+block_user+" has been blocked by "+rootmail)
//     }
//     else{
//         await recu.findOneAndUpdate({user_id:block_user},{access:"unblock"})
//         // let accesstoken =jwt.sign({user_id:block_user},process.env.secret_key);
//         // console.log(accesstoken)
        
//         // if(!accesstoken){
//         //     throw new Error("Unable to generate token")
//         // }
//         // else{
//         //     rep.cookie("accesstoken",accesstoken)
//         //     let accesskeyinsertion=await recu.findOneAndUpdate({user_id:block_user},{access:"unblock",accesstoken:accesstoken})

//         //     if(!accesskeyinsertion){
//         //         throw new Error("Unable to insert accesskey")
//         //     }

//         //     else{
//         //         console.log("User is Unblocked")
//         //     }
//         // }
//         console.log("user id "+block_user+" has been unblocked by "+rootmail)
//     }

// }