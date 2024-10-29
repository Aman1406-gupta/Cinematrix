let bcrypt=require("bcrypt");
// const nodemailer= require("nodemailer");
let recu=require("../model/user");
const { mysqlConnection, mongo } = require('../dbconnection');
let product=require("../model/product")
let transactiondata=require("../model/transactiondata")
let jwt=require("jsonwebtoken");
require("dotenv").config();
let rootmail;

function update_amount(previous_amount,new_amount){
    let amount=previous_amount+(new_amount*0.25);
    return (amount);
}


exports.ser_home=async(req,rep)=>{
    let user=await recu.findOne({email:rootmail},{});
    return(user);
}


////////////////////////////////
exports.ser_insert=async (req,rep)=>{
    let name=req.body.name;
    let email=req.body.email;
    let dob=req.body.dob;
    let Nationality=req.body.nationality;
    let pass=req.body.pass;
    let hashpass=await bcrypt.hash(pass,10);
    let terms=req.body.terms;

    console.log(req.body);

    return new Promise((resolve, reject) => {
        mysqlConnection.query('SELECT * FROM user WHERE email = ?', [email], (err, results) => {
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
                    'INSERT INTO user (name, email, pass, parentmail, dob, Nationality) values (?, ?, ?, ?, ?, ?)', [name, email, hashpass, '', dob, Nationality],
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
        
        mysqlConnection.query('SELECT * FROM user WHERE email = ?', [email], (err, results) => {
            if (err) {
                console.error('Database query failed:', err);
                return reject(new Error("Database query failed"));
            }

            if (results.length === 0) {
                console.log("Admin doesn't exist");
                return reject(new Error("Admin doesn't exist"));
            }

            const newdata = results[0];
            rootmail=newdata.email;

            bcrypt.compare(pass, newdata.pass, (err, isPasswordValid) => {
                if (err) {
                    console.error('Password comparison failed:', err);
                    return reject(new Error("Password comparison failed"));
                }

                if (!isPasswordValid) {
                    console.log('Password is incorrect');
                    return reject(new Error("Incorrect password"));
                }

                const token = jwt.sign({ id: newdata.id }, process.env.secret_key);
                if (!token) {
                    console.error('Unable to generate token');
                    return reject(new Error("Token generation failed"));
                }

                mysqlConnection.query(
                    'UPDATE user SET auth_key = ? WHERE id = ?',
                    [token, newdata.id],
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
        mysqlConnection.query('SELECT * FROM user WHERE email = ?', [rootmail], (err, results) => {
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
//////////////////////////////

exports.ser_registeruser=async (req,rep)=>{
    let name=req.body.name;
    let email=req.body.email;
    let mobile=req.body.mobile;
    let pass=req.body.pass;
    let hashpass=await bcrypt.hash(pass,10);
    let terms=req.body.terms;
    let parentmail=rootmail;

    let previousdata=await recu.find({email:email},{email:1})
    if(previousdata.email){
        console.log("unable to create account, email already exist as user");
    }
    else{
        let re= new recu({
            name:name,email:email,mobile:mobile,parentmail:parentmail,pass:hashpass,terms:terms
        })
        await re.save();

        //to add user_id=_id generated default by mongodb
        let userd=await recu.find({email:email},{});
        let new_id;
        for (const i of userd) {
            new_id=i._id;
        }
        let user_id= await recu.findOneAndUpdate({email:email},{user_id:new_id})
        console.log("user account has been created with user id"+" "+ new_id);

        //for money distribution
        let parent_wallet=recu.findOne({email:parentmail},{amount_earned:1})
        console.log(parent_wallet)
        if(userd.parentmail){
            let new_parent_wallet=parent_wallet.amount_earned+250
            let parent=recu.findOneAndUpdate({email:parentmail},{amount_earned:new_parent_wallet})
        }
        else{
            let amount_earned=recu.findOneAndUpdate({email:userd.email},{amount_earned:1000})
        }
    }
}

exports.ser_tpshowmovie=async(req,rep)=>{
    const [rows]=await db.promise().query('SELECT * FROM Movie');
    let userdata=rows;
    console.log(userdata);
    // let userdata=await db.query('SELECT * FROM Movie');
    // let userdata=await recu.find({parentmail:rootmail},{});
    let admindata=await recu.findOne({email:rootmail},{})
    // console.log(admindata)
    let adminparentmail=admindata.parentmail
    // console.log(adminparentmail)
    // return ({userdata:userdata,admindata:admindata,adminparentmail:adminparentmail});
    rep.json ({userdata,admindata:admindata,adminparentmail:admin});
}
exports.ser_reshowmovie=async(req,rep)=>{
    let userdata=await recu.find({parentmail:rootmail},{});
    let admindata=await recu.findOne({email:rootmail},{})
    // console.log(admindata)
    let adminparentmail=admindata.parentmail
    // console.log(adminparentmail)
    return ({userdata:userdata,admindata:admindata,adminparentmail:adminparentmail});
}
exports.ser_showmovie=async(req,rep)=>{
    let userdata=await recu.find({parentmail:rootmail},{});
    let admindata=await recu.findOne({email:rootmail},{})
    // console.log(admindata)
    let adminparentmail=admindata.parentmail
    // console.log(adminparentmail)
    return ({userdata:userdata,admindata:admindata,adminparentmail:adminparentmail});
}

exports.ser_tpseriesshow=async(req,rep)=>{
    let userdata=await recu.find({parentmail:rootmail},{});
    let admindata=await recu.findOne({email:rootmail},{})
    // console.log(admindata)
    let adminparentmail=admindata.parentmail
    // console.log(adminparentmail)
    return ({userdata:userdata,admindata:admindata,adminparentmail:adminparentmail});
}
exports.ser_reseriesshow=async(req,rep)=>{
    let userdata=await recu.find({parentmail:rootmail},{});
    let admindata=await recu.findOne({email:rootmail},{})
    // console.log(admindata)
    let adminparentmail=admindata.parentmail
    // console.log(adminparentmail)
    return ({userdata:userdata,admindata:admindata,adminparentmail:adminparentmail});
}
exports.ser_seriesshow=async(req,rep)=>{
    let userdata=await recu.find({parentmail:rootmail},{});
    let admindata=await recu.findOne({email:rootmail},{})
    // console.log(admindata)
    let adminparentmail=admindata.parentmail
    // console.log(adminparentmail)
    return ({userdata:userdata,admindata:admindata,adminparentmail:adminparentmail});
}

exports.ser_pcelebview=async(req,rep)=>{
    let userdata=await recu.find({parentmail:rootmail},{});
    let admindata=await recu.findOne({email:rootmail},{})
    // console.log(admindata)
    let adminparentmail=admindata.parentmail
    // console.log(adminparentmail)
    return ({userdata:userdata,admindata:admindata,adminparentmail:adminparentmail});
}
exports.ser_btcelebview=async(req,rep)=>{
    let userdata=await recu.find({parentmail:rootmail},{});
    let admindata=await recu.findOne({email:rootmail},{})
    // console.log(admindata)
    let adminparentmail=admindata.parentmail
    // console.log(adminparentmail)
    return ({userdata:userdata,admindata:admindata,adminparentmail:adminparentmail});
}
exports.ser_celebview=async(req,rep)=>{
    let userdata=await recu.find({parentmail:rootmail},{});
    let admindata=await recu.findOne({email:rootmail},{})
    // console.log(admindata)
    let adminparentmail=admindata.parentmail
    // console.log(adminparentmail)
    return ({userdata:userdata,admindata:admindata,adminparentmail:adminparentmail});
}

exports.ser_awardview=async(req,rep)=>{
    let userdata=await recu.find({parentmail:rootmail},{});
    let admindata=await recu.findOne({email:rootmail},{})
    // console.log(admindata)
    let adminparentmail=admindata.parentmail
    // console.log(adminparentmail)
    return ({userdata:userdata,admindata:admindata,adminparentmail:adminparentmail});
}

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

exports.ser_showproduct_admin=async(req,rep)=>{
    let productdata=await product.find({},{})
    let user_data=await recu.find({email:rootmail},{})
    user_data=user_data[0];
    console.log(user_data)
    let parentdatashown=await recu.find({email:user_data.parentmail},{})
    parentdatashown=parentdatashown[0];
    return({productdata:productdata,parentdatashown:parentdatashown});
}

exports.ser_deleteuser=async(req,rep)=>{
    let user_id=req.body.id;
    let tobedeleted=await recu.findOneAndDelete({user_id:user_id},{})
    return(tobedeleted);
}

exports.ser_viewusercomodity=async(req,rep)=>{
    let user_id=req.body.id;
    let userdatatobeshownrec=await recu.find({user_id:user_id},{});
    let datatobeshown;
    console.log(userdatatobeshownrec);
    for (const i in userdatatobeshownrec) {
        if (Object.hasOwnProperty.call(userdatatobeshownrec, i)) {
            const e = userdatatobeshownrec[i];
            datatobeshown=e;
        }
    }
    return(datatobeshown);
}

let user_id_for_update;
let rootdata;
exports.ser_userupdate=async(req,rep)=>{
    let user_id=req.body.id;
    let datashown=await recu.findOne({user_id:user_id},{})
    user_id_for_update=datashown
    console.log(user_id_for_update)

    rootdata=await recu.findOne({email:rootmail},{})
    // console.log(rootdata)
    return({datashown:datashown,rootdata:rootdata});
}

exports.ser_userprofileupdate=async(req,rep)=>{
    let user_password=req.body.password;
    let v =await bcrypt.compare(user_password,user_id_for_update.pass)
    let user_name=req.body.name;
    let user_email=req.body.email;
    let user_mobile=req.body.mobile;
    let user_password_confirm=req.body.confirm_password;

    if(user_password===user_password_confirm && v){
        await recu.findOneAndUpdate({user_id:user_id_for_update.user_id},{name:user_name,email:user_email,mobile:user_mobile,password:user_password})
        console.log("profile of user id "+user_id_for_update.user_id+" has been updated by "+rootmail)
    }
    else{
       console.log("Confirm Password is not matching password")
    }

    let parentdata=await recu.findOne({email:rootmail},{})
    // console.log(rootdata)
    return({parentdata:parentdata,rootdata:rootdata});
}

exports.ser_update_points_form=async(req,rep)=>{
    let user_id=req.body.id;
    let datashown=await recu.find({user_id:user_id},{})
    let finaldatashown;
    for (const i in datashown) {
        if (Object.hasOwnProperty.call(datashown, i)) {
            const element = datashown[i];
            finaldatashown=element;
        }
    }
    return(finaldatashown)
}

exports.ser_update_points=async(req,rep)=>{
    let user_id=req.body.id;
    let user_details=await recu.find({user_id:user_id},{_id:0});
    const element = user_details[0];
    let finaldatashown=element;
    let childdatashown=element;
    
    let new_amount=parseInt(req.body.added_amount)
    let previous_amount=finaldatashown.amount_earned
    let amount_final=update_amount(previous_amount,new_amount);
    
    await recu.findOneAndUpdate(
        {user_id:user_id},
        {amount_earned:amount_final,added_amount:new_amount}
    );
    let final_user_details_shown=await recu.find({user_id:user_id},{});
    let parentmail=finaldatashown.parentmail;
    
    while(parentmail && parentmail!==""){
        // console.log(childdatashown)
        // console.log(parentmail)
        let parentDetails =await recu.find({ email: parentmail }, {});
        parentDetails=parentDetails[0];
  
        if (!parentDetails) {
            // Handle case where parent is not found (e.g., log error)
            console.error("Parent not found for email:", parentmail);
            break;
        }
        // console.log(parentDetails)
        let amount_final;
        let amount_final_added=parseFloat(childdatashown.added_amount*0.75)
        if(parentDetails.parentmail && parentDetails.parentmail!=="" ){
            amount_final=parseFloat(parentDetails.amount_earned+(amount_final_added*0.25))
            // Inserting transactions history
            let re =new transactiondata(
                {
                    from:childdatashown.user_id,
                    to:parentmail,
                    amount_transfered:(amount_final_added*0.25)
                }
            )
            console.log(amount_final_added*0.25)
            await re.save();
        }
        else{
            amount_final=parseFloat(parentDetails.amount_earned+(amount_final_added))
            // Inserting transactions history
            let re =new transactiondata(
                {
                    from:childdatashown.user_id,
                    to:parentmail,
                    amount_transfered:amount_final_added
                }
            )
            console.log(amount_final_added)
            await re.save();
        }
        // console.log(amount_final_added)
        // console.log(amount_final)

        await recu.findOneAndUpdate(
            {email:parentmail},
            {amount_earned:amount_final,added_amount:amount_final_added}
        );
        childdatashown=parentDetails;
        parentmail=parentDetails.parentmail;

    }
    let rootdata1=await recu.findOne({email:rootmail},{})
    console.log(rootdata1)
    return ({final_user_details_shown:final_user_details_shown,data:rootdata1})
}

let global_product_id;
exports.ser_buyproduct_form=async(req,rep)=>{
    let product_id=req.body.buy
    global_product_id=product_id;
    let product_details=await product.findOne({_id:product_id},{})
    return(product_details);
}

//if we use product_id=req,body.product_id it will show undefined 
//but if we use read only in js instead of disabledthan it will show that value 
exports.ser_buyproduct=async(req,rep)=>{
    let buyer=await recu.findOne({email:rootmail},{})
    
    let quantity=parseInt(req.body.quantity)

    let product_id=global_product_id;
    // console.log(product_id)
    let product1=await product.findOne({_id:product_id},{})
    // console.log(product1)

    if(quantity>product1.quantityleft){
        console.log("We have not enough stock available")
    }
    else{
        if(product1.price > buyer.amount_earned){
            console.log("You don't have enough money to buy");
        }
        else{
            let amount_earned=buyer.amount_earned-(product1.price*quantity)

            await recu.findOneAndUpdate(
                {email:rootmail},
                {amount_earned:amount_earned}
            );

            console.log("product will be delivered to you soon.")
            console.log("your wallet amount is debited by Rs."+(product1.price*quantity))

            let new_quantity_left=product1.quantityleft-quantity
            // console.log(new_quantity_left)

            await product.findOneAndUpdate(
                {_id:global_product_id},
                {quantityleft:new_quantity_left}
            );

            let amount_transfered=product1.price*quantity;
            let seller=await recu.findOne(
                {email:"aman1406gupta@gmail.com"},
                {}
            );
            let new_amount=seller.amount_earned+amount_transfered;
            // console.log(new_amount);

            await recu.findOneAndUpdate(
                {email:"aman1406gupta@gmail.com"},
                {amount_earned:new_amount}
            );

            //inserting transaction history
            let re =new transactiondata(
                {
                    from:buyer.user_id,
                    to:"aman1406gupta@gmail.com",
                    amount_transfered:amount_transfered
                }
            )
            await re.save();
        }
    }
}

let current_balance;
exports.ser_add_balance_form=async(req,rep)=>{
    let user_info=await recu.findOne({email:rootmail},{})
    current_balance=parseInt(user_info.amount_earned);
    return(user_info);
}

//if we use balance1=req.body.balance it will show undefined
//but if we use read only in js instead of disabledthan it will show that value 
exports.ser_add_balance=async(req,rep)=>{
    let balance1=current_balance;
    let password=req.body.password;
    let account_no=req.body.account_no;

    let added_amount=parseInt(req.body.added_amount);

    let user_info=await recu.findOne({email:rootmail},{})
    let previous_password=user_info.pass
    let new_amount=parseInt(balance1+added_amount);


    let v=await bcrypt.compare(password,previous_password)
    if(v){
        await recu.findOneAndUpdate({email:rootmail},{amount_earned:new_amount})
        console.log("Your wallet has been credited by Rs."+added_amount);
    }
    else{
        console.log("password is incorrect");
    }
}

let another_rootdata;
let another_productdata;
exports.ser_update_product_page=async(req,rep)=>{
    let productid=req.body.id;
    let productdata=await product.findOne({productid:productid},{})
    // console.log(productdata)

    another_productdata=productdata;

    another_rootdata=await recu.findOne({email:rootmail},{})
    // console.log(another_rootdata)
    return({productdata:productdata,rootdata:another_rootdata});
}

exports.ser_update_product=async(req,rep)=>{
    let product_name=req.body.productname;
    let price=parseInt(req.body.price);
    let quantity_left=parseInt(req.body.quantity_left);
    let password=req.body.password;

    let rootpass=await recu.findOne({email:rootmail},{});
    rootpass=rootpass.pass;
    let v=await bcrypt.compare(password,rootpass)

    if(v){
        await product.findOneAndUpdate(
            {productid:another_productdata.productid},
            {productname:product_name,price:price,quantityleft:quantity_left}
        )
        console.log("ProductDetails of product id "+another_productdata.productid+" has been updated by "+rootmail)
    }
    else{
       console.log("Password is incorrect")
    }
}

exports.ser_product_delete=async(req,rep)=>{
    let productid=req.body.id;
    await product.findOneAndDelete({productid:productid},{})
    console.log("product of product id "+productid+" is deleted");
}

exports.ser_changepass=async(req,rep)=>{
    let password=req.body.oldpass;
    let new_password=req.body.pass;
    let con_pass=req.body.conpass
    let rootdata=await recu.findOne({email:rootmail},{})
    let new_password_bcrypt=await bcrypt.hash(new_password,10)
    // console.log(rootdata.pass)

    let v=bcrypt.compare(password,rootdata.pass);
    if(v  && new_password==con_pass){
        await recu.findOneAndUpdate({email:rootmail},{pass:new_password_bcrypt})
    }
    else if(!v){
        console.log("Password is incorrect")
    }
    else{
        console.log("Password and Confirm Password are not same")
    }
    console.log("Your password is updated now ")
}

exports.ser_showt=async(req,rep)=>{
    let root=await recu.findOne({email:rootmail},{})
    let rootuser_id=root.user_id;
    // console.log(rootuser_id)

    let showt=await transactiondata.find({$or:[{from:rootuser_id },{to:rootmail}]},{})
    // console.log(showt);
    return({data:root.parentmail,tdata:showt})
}

exports.ser_signout=async(req,rep)=>{
    try{
        rep.clearCookie("token");
        let logout=await recu.findOneAndUpdate(
            {email:rootmail},
            {auth_key:null}
        );
        if(logout)
        console.log("currently you are Log Out")
        else
        console.log("Error in Logout")
    }
    catch{
        console.log("error in setting cookie null")
    }
}

exports.ser_block_user=async(req,rep)=>{
    let block_user=req.body.id;
    let user_status=req.body.access;

    if(user_status=="unblock"){
        await recu.findOneAndUpdate({user_id:block_user},{access:"block"})
        // let accesstoken =jwt.sign({user_id:block_user},process.env.secret_key);
        // console.log(accesstoken)
        
        // if(!accesstoken){
        //     throw new Error("Unable to generate token")
        // }
        // else{
        //     rep.cookie("accesstoken",accesstoken)
        //     let accesskeyinsertion=await recu.findOneAndUpdate({user_id:block_user},{access:"block",accesstoken:accesstoken})

        //     if(!accesskeyinsertion){
        //         throw new Error("Unable to insert accesskey")
        //     }

        //     else{
        //         console.log("User is blocked")
        //     }
        // }
        console.log("user id "+block_user+" has been blocked by "+rootmail)
    }
    else{
        await recu.findOneAndUpdate({user_id:block_user},{access:"unblock"})
        // let accesstoken =jwt.sign({user_id:block_user},process.env.secret_key);
        // console.log(accesstoken)
        
        // if(!accesstoken){
        //     throw new Error("Unable to generate token")
        // }
        // else{
        //     rep.cookie("accesstoken",accesstoken)
        //     let accesskeyinsertion=await recu.findOneAndUpdate({user_id:block_user},{access:"unblock",accesstoken:accesstoken})

        //     if(!accesskeyinsertion){
        //         throw new Error("Unable to insert accesskey")
        //     }

        //     else{
        //         console.log("User is Unblocked")
        //     }
        // }
        console.log("user id "+block_user+" has been unblocked by "+rootmail)
    }

}