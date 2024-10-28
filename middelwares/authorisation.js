// require("dotenv").config();
// const jwt=require("jsonwebtoken");
// // let db=require("./src/dbconnection");   
// const db=require("./src/dbconnection");     
// // const recu=require("../src/model/user.js");

// async function user_auth (req,rep,next){
//     try{

//         if(req.cookies.token!=undefined && req.cookies.token !=""){
//             const token=req.cookies.token;
//             const jwtpassword=process.env.secret_key;
//             const decode=jwt.verify(token,jwtpassword);

//             let admin= await db.query('SELECT * FROM movies where _id =' +decode.id);
//             // let admin=await recu.findOne({_id:decode.id});
//             console.log(admin);

//             if(!admin) return({message:"admin not found"})
//             req.user=admin;
//             next();
//             }
            
//         else{
//                 rep.redirect("/signup");
//                 console.log("please login first");
//             }

//     } 
//     catch(err){
//         console.log(err);
//         rep.json({
//             error:"Internal Server Error",
//             message: err.message,
//         })
//     }
// }

// module.exports= user_auth;

// require("dotenv").config();
// const jwt = require("jsonwebtoken");
// const db = require("../src/dbconnection"); 
// const recu=require("../src/model/user.js");   
require("dotenv").config();
const jwt=require("jsonwebtoken"); 
const db=require("../src/dbconnection");     
const recu=require("../src/model/user.js");

async function user_auth(req, rep, next) {
    try {
        if (req.cookies.token) {  // Simplified check
            const token = req.cookies.token;
            const jwtSecretKey = process.env.SECRET_KEY; // Make sure it's exactly as in .env

            const decode = jwt.verify(token, jwtSecretKey);

            let admin=await recu.findOne({_id:decode.id});
            // const [admin] = await db.query('SELECT * FROM user WHERE _id = ?', [decode.id]);

            if (!admin || admin.length === 0) {
                return rep.status(404).json({ message: "Admin not found" });
            }

            req.user = admin;
            next();
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