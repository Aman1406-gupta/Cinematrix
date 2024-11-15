let bcrypt=require("bcrypt");
const nodemailer= require("nodemailer");
const { mysqlConnection } = require('../dbconnection');
let jwt=require("jsonwebtoken");
require("dotenv").config();
let rootmail;
let newdata;

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
                return reject({message: "This E-Mail is already in use!"});
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
                        async function mail(){
                            const transporter = nodemailer.createTransport({
                                service:"gmail",
                                auth:{
                                        user:"official.cinematrix.db@gmail.com",
                                        pass:process.env.nodemail_pass,
                                },
                            });       
                            
                            const mailOptions={
                                from:"official.cinematrix.db@gmail.com",
                                to:email,
                                subject:`Hello, ${name}! Welcome to Cinematrix!`,
                                text:"Your Cinematrix account has been created successfully!",
                            };
                            await transporter.sendMail(mailOptions);
                        };
                        mail();
                        resolve({message: "Your Account has been created successfully!"});
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
                console.log("User doesn't exist");
                return reject({message: "User doesn't exist!"});
            }

            newdata = results[0];   
            rootmail=newdata.User_Mail;

            bcrypt.compare(pass, newdata.User_Password_Encrypted, (err, isPasswordValid) => {
                if (err) {
                    console.error('Password comparison failed:', err);
                    return reject(new Error("Password comparison failed"));
                }

                if (!isPasswordValid) {
                    console.log('Password is incorrect');
                    return reject({message: "Password is Incorrect!"});
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

exports.ser_watchlistmovie=async(req,rep,movieid)=>{
        return new Promise((resolve, reject) => {
            mysqlConnection.query(`INSERT IGNORE INTO movieWatchlisted(User_ID, Movie_ID) VALUES (?, ?);`, [newdata.User_ID, movieid], (err, results) => {
                if (err) {
                    console.error('Error in logging out!', err);
                    return reject(new Error("Database query failed"));
                }
                resolve({newdata});
            });
        });
}

exports.ser_watchlistshow=async(req,rep,showid)=>{
        return new Promise((resolve, reject) => {
            mysqlConnection.query(`INSERT IGNORE INTO showWatchlisted(User_ID, Show_ID) VALUES (?, ?);`, [newdata.User_ID, showid], (err, results) => {
                if (err) {
                    console.error('Error in logging out!', err);
                    return reject(new Error("Database query failed"));
                }
                resolve({newdata});
            });
        });
}

exports.ser_deletewatchlistmovie=async(req,rep,movieid)=>{
        return new Promise((resolve, reject) => {
            mysqlConnection.query(`DELETE FROM movieWatchlisted WHERE User_ID = ? AND Movie_ID = ?;`, [newdata.User_ID, movieid], (err, results) => {
                if (err) {
                    console.error('Error in logging out!', err);
                    return reject(new Error("Database query failed"));
                }
                resolve({newdata});
            });
        });
}

exports.ser_deletewatchlistshow=async(req,rep,showid)=>{
        return new Promise((resolve, reject) => {
            mysqlConnection.query(`DELETE FROM showWatchlisted WHERE User_ID = ? AND Show_ID = ?;`, [newdata.User_ID, showid], (err, results) => {
                if (err) {
                    console.error('Error in logging out!', err);
                    return reject(new Error("Database query failed"));
                }
                resolve({newdata});
            });
        });
}

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
            async function mail(){
                const transporter = nodemailer.createTransport({
                    service:"gmail",
                    auth:{
                            user:"official.cinematrix.db@gmail.com",
                            pass:process.env.nodemail_pass,
                    },
                });       
                
                const mailOptions={
                    from:"official.cinematrix.db@gmail.com",
                    to:rootmail,
                    subject:`Updation of Cinematrix Details`,
                    text:"Your Cinematrix account details have been updated successfully!",
                };
                await transporter.sendMail(mailOptions);
            };
            mail();
            rep.redirect('/adminprofile');
        });
    });
}

exports.ser_watchlist=async(req,rep)=>{
        return new Promise((resolve, reject) => {
            mysqlConnection.query(`
                                    SELECT MW.User_ID, M.Movie_ID, M.Title Movie_Title, YEAR(M.Release_Date) Year_Of_Release, M.Movie_Rating, M.Num_Ratings_Movies FROM Movies M JOIN movieWatchlisted MW ON M.Movie_ID = MW.Movie_ID WHERE MW.User_ID = ?;
                                    SELECT SW.User_ID, S.Show_ID, S.Title, N.Number_Of_Seasons, YEAR(S.Start_Date) Release_Year, S.TVShow_Rating, S.Num_Ratings_TV FROM TV_Shows S JOIN (SELECT  Show_ID, COUNT(DISTINCT(Season_Number)) Number_Of_Seasons FROM Episodes GROUP BY Show_ID) N ON N.Show_ID = S.Show_ID JOIN showWatchlisted SW ON SW.Show_ID = S.Show_ID WHERE SW.User_ID = ?;
                                    `, [newdata.User_ID,newdata.User_ID], (err, results) => {
                if (err) {
                    console.error('Error in logging out!', err);
                    return reject(new Error("Database query failed"));
                }

                mwatchlistdetails=results[0];
                twatchlistdetails=results[1];
                resolve({mwatchlistdetails,twatchlistdetails,newdata});
            });
        });
}

exports.ser_delwtmovie=async(req,rep,movieid)=>{
        return new Promise((resolve, reject) => {
            mysqlConnection.query(`DELETE FROM movieWatchlisted WHERE User_ID = ? AND Movie_ID = ?;`, [newdata.User_ID, movieid], (err, results) => {
                if (err) {
                    console.error('Error in logging out!', err);
                    return reject(new Error("Database query failed"));
                }
                resolve({newdata});
            });
        });
}

exports.ser_delwtshow=async(req,rep,showid)=>{
        return new Promise((resolve, reject) => {
            mysqlConnection.query(`DELETE FROM showWatchlisted WHERE User_ID = ? AND Show_ID = ?;`, [newdata.User_ID, showid], (err, results) => {
                if (err) {
                    console.error('Error in logging out!', err);
                    return reject(new Error("Database query failed"));
                }
                resolve({newdata});
            });
        });
}

exports.ser_review=async(req,rep)=>{
        return new Promise((resolve, reject) => {
            mysqlConnection.query(`
                                    SELECT R.User_ID, MR.Movie_ID, M.Title, MR.Review_ID, Review_Comment, Media_Rating, Like_Count, Dislike_Count, CONCAT(TIMESTAMPDIFF(DAY, R.Review_Date, NOW()), ' days ago') AS Days_Since_Review FROM movieReviewed MR JOIN Reviews R ON MR.Review_ID = R.Review_ID JOIN Movies M ON M.Movie_ID = MR.Movie_ID WHERE User_ID = ?;
                                    SELECT R.User_ID, SR.Show_ID, T.Title, SR.Review_ID, Review_Comment, Media_Rating, Like_Count, Dislike_Count, CONCAT(TIMESTAMPDIFF(DAY, R.Review_Date, NOW()), ' days ago') AS Days_Since_Review FROM showReviewed SR JOIN Reviews R ON SR.Review_ID = R.Review_ID JOIN TV_Shows T ON T.Show_ID = SR.Show_ID WHERE User_ID = ?;
                                    SELECT R.User_ID, ER.Show_ID, T.Title AS Show_Title, ER.Season_Number, ER.Episode_Number, E.Title, ER.Review_ID, Review_Comment, Media_Rating, Like_Count, Dislike_Count, CONCAT(TIMESTAMPDIFF(DAY, R.Review_Date, NOW()), ' days ago') AS Days_Since_Review FROM episodeReviewed ER JOIN Reviews R ON ER.Review_ID = R.Review_ID JOIN Episodes E ON (E.Show_ID = ER.Show_ID AND E.Episode_Number = ER.Episode_Number AND E.Season_Number = ER.Season_Number) JOIN TV_Shows T ON T.Show_ID = ER.Show_ID WHERE User_ID = ?;
                                    `, [newdata.User_ID,newdata.User_ID,newdata.User_ID], (err, results) => {
                if (err) {
                    console.error('Error in logging out!', err);
                    return reject(new Error("Database query failed"));
                }

                mreviewdetails=results[0];
                treviewdetails=results[1];
                ereviewdetails=results[2];
                resolve({mreviewdetails,treviewdetails,ereviewdetails,newdata});
            });
        });
}

exports.ser_moviereview=async(req,rep,movieid)=>{
    let review=req.body.review;
    let rating=req.body.rating;
    
        return new Promise((resolve, reject) => {
            mysqlConnection.query(`
                                    INSERT INTO Reviews(User_ID, Review_Comment, Media_Rating, Review_Date, Like_Count, Dislike_Count) values(?, ?, ?, CURDATE(), 0, 0);
                                    INSERT INTO moviereviewed(review_id, movie_id) values ((SELECT Review_ID FROM Reviews ORDER BY Review_ID DESC LIMIT 1), ?);
                                    `, [newdata.User_ID, review, rating, movieid], (err, results) => {
                if (err) {
                    console.error('Error in logging out!', err);
                    return reject(new Error("Database query failed"));
                }
                resolve({newdata});
            });
        });
}

exports.ser_tvshowreview=async(req,rep,showid)=>{
    let review=req.body.review;
    let rating=req.body.rating;
    
        return new Promise((resolve, reject) => {
            mysqlConnection.query(`
                                    INSERT INTO Reviews(User_ID, Review_Comment, Media_Rating, Review_Date, Like_Count, Dislike_Count) values(?, ?, ?, CURDATE(), 0, 0);
                                    INSERT INTO showreviewed(review_id, show_id) values ((SELECT Review_ID FROM Reviews ORDER BY Review_ID DESC LIMIT 1), ?);
                                    `, [newdata.User_ID, review, rating, showid], (err, results) => {
                if (err) {
                    console.error('Error in logging out!', err);
                    return reject(new Error("Database query failed"));
                }
                resolve({newdata});
            });
        });
}

exports.ser_episodereview=async(req,rep,showid,sno,eno)=>{
    let review=req.body.review;
    let rating=req.body.rating;
    
        return new Promise((resolve, reject) => {
            mysqlConnection.query(`
                                    INSERT INTO Reviews(User_ID, Review_Comment, Media_Rating, Review_Date, Like_Count, Dislike_Count) values(?, ?, ?, CURDATE(), 0, 0);
                                    INSERT INTO episodereviewed(review_id, show_id, season_number, episode_number) values ((SELECT Review_ID FROM Reviews ORDER BY Review_ID DESC LIMIT 1), ?, ?, ?);
                                    `, [newdata.User_ID, review, rating, showid,sno,eno], (err, results) => {
                if (err) {
                    console.error('Error in logging out!', err);
                    return reject(new Error("Database query failed"));
                }
                resolve({newdata});
            });
        });
}

exports.ser_deletereview=async(req,rep,reviewid)=>{
        return new Promise((resolve, reject) => {
            mysqlConnection.query(`DELETE FROM Reviews WHERE Review_ID = ?`, [reviewid], (err, results) => {
                if (err) {
                    console.error('Error in logging out!', err);
                    return reject(new Error("Database query failed"));
                }
                resolve({newdata});
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
                async function mail(){
                    const transporter = nodemailer.createTransport({
                        service:"gmail",
                        auth:{
                                user:"official.cinematrix.db@gmail.com",
                                pass:process.env.nodemail_pass,
                        },
                    });       
                    
                    const mailOptions={
                        from:"official.cinematrix.db@gmail.com",
                        to:rootmail,
                        subject:`Sad to see you go ${newdata.Username}!`,
                        text:"Your Cinematrix account has been deleted successfully!", 
                    };
                    await transporter.sendMail(mailOptions);
                };
                mail();
                resolve({message: "Your account has been deleted successfully!"});
            })
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
            SELECT * FROM movieWatchlisted WHERE User_ID = ? AND Movie_ID = ?;
                `, [movieid, movieid, movieid, movieid, movieid, movieid, movieid, movieid, movieid, movieid, movieid, newdata.User_ID, movieid], (err, results) => {
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
            const watchlistdetails = results[11];
            resolve( { moviedetails,genredetails,languagedetails,awarddetails,actordetails,directordetails,producerdetails,streamdetails,prequeldetails,sequeldetails,reviewdetails,newdata,movieid,watchlistdetails } );
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
                               SELECT * FROM showWatchlisted WHERE User_ID = ? AND Show_ID = ?;
                              `,[tvshowid,tvshowid,tvshowid,tvshowid,tvshowid,tvshowid,tvshowid,tvshowid,tvshowid,tvshowid,tvshowid,newdata.User_ID, tvshowid], (err, results) => {
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
            const watchlistdetails = results[11];
            resolve( { tvshowdetails,seaandepdata,episodedetails,genredetails,actordetails,directordetails,producerdetails,awarddetails,languagedetails,streamdetails,reviewdetails,newdata,tvshowid,watchlistdetails } );
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
            resolve( { epdetails,actordetails,directordetails,producerdetails,reviewdetails,newdata,tvshowid,sno,eno } );
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
                                SELECT COUNT(*) Num_Count FROM (SELECT DISTINCT * FROM (SELECT Movie_ID FROM movieDirectedBy WHERE Director_ID = ? UNION ALL SELECT Show_ID FROM showDirectedBy WHERE Director_ID = ?) TEMP ) INTERMEDIATE;
                                SELECT COUNT(*) Num_Count FROM (SELECT DISTINCT * FROM (SELECT Movie_ID FROM movieActedBy WHERE Actor_ID = ? UNION ALL SELECT Show_ID FROM showActedBy WHERE Actor_ID = ?) TEMP ) INTERMEDIATE;
                                SELECT COUNT(*) Num_Count FROM (SELECT DISTINCT * FROM (SELECT Movie_ID FROM movieProducedBy WHERE Producer_ID = ? UNION ALL SELECT Show_ID FROM showProducedBy WHERE Producer_ID = ?) TEMP ) INTERMEDIATE;
                                SELECT m.Title AS Movie_Title, m.Num_Ratings_Movies AS Number_of_Ratings FROM Movies m JOIN movieActedBy ma ON m.Movie_ID = ma.Movie_ID WHERE ma.Actor_ID = ? ORDER BY m.Num_Ratings_Movies DESC LIMIT 1;
                                SELECT m.Title AS Movie_Title, m.Num_Ratings_Movies AS Number_of_Ratings FROM Movies m JOIN movieProducedBy mp ON m.Movie_ID = mp.Movie_ID WHERE mp.Producer_ID = ? ORDER BY m.Num_Ratings_Movies DESC LIMIT 1;
                                SELECT m.Title AS Movie_Title, m.Num_Ratings_Movies AS Number_of_Ratings FROM Movies m JOIN movieDirectedBy md ON m.Movie_ID = md.Movie_ID WHERE md.Director_ID = ? ORDER BY m.Num_Ratings_Movies DESC LIMIT 1;
                                SELECT DISTINCT * FROM (SELECT MA.Movie_ID, MA.Actor_ID, M.Title Movie_Title, YEAR(M.Release_Date) Year_Of_Release, M.Movie_Rating, M.Num_Ratings_Movies FROM Movies M JOIN movieactedby MA ON M.Movie_ID = MA.Movie_ID WHERE Actor_ID = ?) INTERMEDIATE;
                                SELECT DISTINCT * FROM (SELECT MD.Movie_ID, MD.Director_ID, M.Title Movie_Title, YEAR(M.Release_Date) Year_Of_Release, M.Movie_Rating, M.Num_Ratings_Movies FROM Movies M JOIN movieDirectedBy MD ON M.Movie_ID = MD.Movie_ID WHERE Director_ID = ?) INTERMEDIATE;
                                SELECT DISTINCT * FROM (SELECT MP.Movie_ID, MP.Producer_ID, M.Title Movie_Title, YEAR(M.Release_Date) Year_Of_Release, M.Movie_Rating, M.Num_Ratings_Movies FROM Movies M JOIN movieProducedBy MP ON M.Movie_ID = MP.Movie_ID WHERE Producer_ID = ?) INTERMEDIATE;
                                SELECT DISTINCT * FROM (SELECT SA.Show_ID, SA.Actor_ID, S.Title, N.Number_Of_Seasons, YEAR(S.Start_Date) Release_Year, S.TVShow_Rating, S.Num_Ratings_TV FROM TV_Shows S JOIN (SELECT  Show_ID, COUNT(DISTINCT(Season_Number)) Number_Of_Seasons FROM Episodes GROUP BY Show_ID) N ON N.Show_ID = S.Show_ID JOIN showActedBy SA ON SA.Show_ID = S.Show_ID WHERE SA.Actor_ID = ?) INTERMEDIATE;
                                SELECT DISTINCT * FROM (SELECT SD.Show_ID, SD.Director_ID, S.Title, N.Number_Of_Seasons, YEAR(S.Start_Date) Release_Year, S.TVShow_Rating, S.Num_Ratings_TV FROM TV_Shows S JOIN (SELECT  Show_ID, COUNT(DISTINCT(Season_Number)) Number_Of_Seasons FROM Episodes GROUP BY Show_ID) N ON N.Show_ID = S.Show_ID JOIN showDirectedBy SD ON SD.Show_ID = S.Show_ID WHERE SD.Director_ID = ?) INTERMEDIATE; 
                                SELECT DISTINCT * FROM (SELECT SP.Show_ID, SP.Producer_ID, S.Title, N.Number_Of_Seasons, YEAR(S.Start_Date) Release_Year, S.TVShow_Rating, S.Num_Ratings_TV FROM TV_Shows S JOIN (SELECT  Show_ID, COUNT(DISTINCT(Season_Number)) Number_Of_Seasons FROM Episodes GROUP BY Show_ID) N ON N.Show_ID = S.Show_ID JOIN showProducedBy SP ON SP.Show_ID = S.Show_ID WHERE SP.Producer_ID = ?) INTERMEDIATE;
                              `,[celebid,celebid,celebid,celebid,celebid,celebid,celebid,celebid,celebid,celebid,celebid,celebid,celebid,celebid,celebid,celebid,celebid,celebid,celebid,celebid], (err, results) => {
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
            const mda = results[11];
            const mdd = results[12];
            const mdp = results[13];
            const sda = results[14];
            const sdd = results[15];
            const sdp = results[16];
            resolve( { celebdata,ds,rr,pm,awarddetails,dnum,anum,pnum,afam,pfam,dfam,mda,mdd,mdp,sda,sdd,sdp,newdata } );
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
        mysqlConnection.query(`SELECT U.User_Mail, R.Review_ID, R.Review_Date, R.Review_Comment, M.Title FROM Reviews R JOIN Users U ON U.User_ID = R.User_ID JOIN movieReviewed MR ON R.Review_ID = MR.Review_ID JOIN Movies M ON M.Movie_ID = MR.Movie_ID WHERE R.Review_ID = ?;
                               DELETE FROM Reviews WHERE Review_ID =?;`,[reviewid, reviewid], (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }
            console.log(`The Review with ${reviewid} has been deleted`);
            async function mail(){
                const transporter = nodemailer.createTransport({
                    service:"gmail",
                    auth:{
                            user:"official.cinematrix.db@gmail.com",
                            pass:process.env.nodemail_pass,
                    },
                });       
                
                const mailOptions={
                    from:"official.cinematrix.db@gmail.com",
                    to:results[0][0].User_Mail,
                    subject:`Review on Cinematrix Deleted`,
                    text:`Your Review posted on ${results[0][0].Review_Date} with the comment "${results[0][0].Review_Comment}" for the Movie "${results[0][0].Title}" was deleted by an Admin due to violation of the Cinematrix's content policy.`, 
                };
                await transporter.sendMail(mailOptions);
            };
            mail();
            resolve( {movieid, newdata } );
        });
    });
}

exports.ser_delete_review_show=async(req,rep,reviewid)=>{
    let showid=req.body.showid;
    return new Promise((resolve, reject) => {
        mysqlConnection.query(`SELECT U.User_Mail, R.Review_ID, R.Review_Date, R.Review_Comment, T.Title FROM Reviews R JOIN Users U ON U.User_ID = R.User_ID JOIN showReviewed TR ON R.Review_ID = TR.Review_ID JOIN TV_Shows T ON T.Show_ID = TR.Show_ID WHERE R.Review_ID = ?;
                               DELETE FROM Reviews WHERE Review_ID =?;`,[reviewid, reviewid], (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }
            console.log(`The Review with ${reviewid} has been deleted`);
            async function mail(){
                const transporter = nodemailer.createTransport({
                    service:"gmail",
                    auth:{
                            user:"official.cinematrix.db@gmail.com",
                            pass:process.env.nodemail_pass,
                    },
                });       
                
                const mailOptions={
                    from:"official.cinematrix.db@gmail.com",
                    to:results[0][0].User_Mail,
                    subject:`Review on Cinematrix Deleted`,
                    text:`Your Review posted on ${results[0][0].Review_Date} with the comment "${results[0][0].Review_Comment}" for the TV Show "${results[0][0].Title}" was deleted by an Admin due to violation of the Cinematrix's content policy.`, 
                };
                await transporter.sendMail(mailOptions);
            };
            mail();
            resolve( {showid, newdata } );
        });
    });
}

exports.ser_delete_review_episode=async(req,rep,reviewid)=>{
    let showid=req.body.showid;
    let sno=req.body.sno;
    let eno=req.body.eno;
    return new Promise((resolve, reject) => {
        mysqlConnection.query(`SELECT U.User_Mail, R.Review_ID, R.Review_Date, R.Review_Comment, E.Title, T.Title Show_Title FROM Reviews R JOIN Users U ON U.User_ID = R.User_ID JOIN episodeReviewed ER ON R.Review_ID = ER.Review_ID JOIN Episodes E ON (E.Show_ID = ER.Show_ID AND E.Season_Number = ER.Season_Number AND E.Episode_Number = ER.Episode_Number) JOIN TV_Shows T ON T.Show_ID = E.Show_ID WHERE R.Review_ID = ?;
                               DELETE FROM Reviews WHERE Review_ID =?;`,[reviewid, reviewid], (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }
            console.log(`The Review with ${reviewid} has been deleted`);
            async function mail(){
                const transporter = nodemailer.createTransport({
                    service:"gmail",
                    auth:{
                            user:"official.cinematrix.db@gmail.com",
                            pass:process.env.nodemail_pass,
                    },
                });       
                
                const mailOptions={
                    from:"official.cinematrix.db@gmail.com",
                    to:results[0][0].User_Mail,
                    subject:`Review on Cinematrix Deleted`,
                    text:`Your Review posted on ${results[0][0].Review_Date} with the comment "${results[0][0].Review_Comment}" for the Episode "${results[0][0].Title}" of the TV Show "${results[0][0].Show_Title}" was deleted by an Admin due to violation of the Cinematrix's content policy.`, 
                };
                await transporter.sendMail(mailOptions);
            };
            mail();
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