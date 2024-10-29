require("dotenv").config();
const jwt=require("jsonwebtoken"); 
const {mysqlConnection,mongodb}  =require("../src/dbconnection");     
const recu=require("../src/model/user.js");

async function user_auth(req, rep, next) {
    try {
        if (req.cookies.token) { 
            const token = req.cookies.token;
            const jwtSecretKey = process.env.SECRET_KEY; 

            const decode = jwt.verify(token, jwtSecretKey);

            // let admin=await recu.findOne({_id:decode.id});
            // const admin = await mysqldb.query('SELECT * FROM user WHERE id = ?', [decode.id]);
            mysqlConnection.query(
                ('SELECT * FROM user WHERE id = ?'), [decode.id],
                (err, results) => {
                    if (err) {
                        console.error('Database query failed:', err);
                    }
            
                    if (results.length === 0) {
                        console.log("Please Login First");
                        return rep.redirect('/signup');
                    }
            
                    const admin = results[0];

                    if (!admin || admin.length === 0) {
                        return rep.status(404).json({ message: "Admin not found" });
                    }
                    req.user = admin;
                    next();
                }
            );            

        } else {
            rep.redirect("/signup");
            console.log("Please login first");
        }
    } catch (err) {
        console.error(err);
        rep.status(500).json({
            error: "Internal Server Error",
            message: err.message,
        });
    }
}

module.exports = user_auth; 