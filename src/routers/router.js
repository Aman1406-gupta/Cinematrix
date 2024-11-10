let express=require("express");
let router=express.Router();
const user_auth=require("../../middelwares/authorisation.js")

let {cont_review_user,cont_delete_review_episode,cont_delete_review_show,cont_delete_review_movie,cont_deletetvshow,cont_deletemovie,cont_view_episode_details,cont_view_celeb_details,cont_view_tvshow_details,cont_view_movie_details,cont_deleteac,cont_tpseriesshow,cont_reseriesshow,cont_seriesshow,cont_tpshowmovie,cont_reshowmovie,cont_showmovie,cont_pcelebview,cont_btcelebview,cont_celebview,cont_awardac,cont_awardem,cont_block_user,cont_signout,cont_home,cont_insert,cont_validation,cont_adduser,cont_registeruser,cont_signup,cont_signin,cont_adminprofile,cont_showproduct,cont_insertproduct,cont_deleteuser,cont_viewusercomodity,cont_userupdate,cont_userprofileupdate,cont_update_points,cont_update_points_form,cont_showproduct_admin,cont_buyproduct,cont_buyproduct_form,cont_add_balance,cont_add_balance_form,cont_update_product,cont_update_product_page,cont_product_delete,cont_changepass,cont_change_pass,cont_showt}=require("../controllers/controller");

router.get("/home",cont_home);
router.get("/signin",cont_signin);
router.post("/login-data-validation",cont_validation);
router.get("/signup",cont_signup);
router.post("/register_data_save",cont_insert);

router.get("/adminprofile",user_auth,cont_adminprofile);
router.post("/update_profile",user_auth,cont_userprofileupdate); 

router.get("/signout",user_auth,cont_signout); 
router.get("/deleteac",user_auth,cont_deleteac); 

router.get("/movieview/:flag",user_auth,cont_showmovie);  
router.post("/movieview/:flag",user_auth,cont_showmovie);
router.get("/tpmovieview",user_auth,cont_tpshowmovie); 
router.get("/removieview",user_auth,cont_reshowmovie); 

router.get("/seriesshow/:flag",user_auth,cont_seriesshow);
router.post("/seriesshow/:flag",user_auth,cont_seriesshow); 
router.get("/tpseriesshow",user_auth,cont_tpseriesshow);
router.get("/reseriesshow",user_auth,cont_reseriesshow);

router.get("/celebview/:flag",user_auth,cont_celebview); 
router.post("/celebview/:flag",user_auth,cont_celebview);
router.get("/pcelebview",user_auth,cont_pcelebview);  
router.get("/btcelebview",user_auth,cont_btcelebview);  

router.get("/view_movie_details/:movieid",user_auth,cont_view_movie_details); 
router.get("/view_tvshow_details/:tvshowid",user_auth,cont_view_tvshow_details); 
router.get("/view_celeb_details/:celebid",user_auth,cont_view_celeb_details); 
router.get("/view_episode_details/:tvshowid/:sno/:eno",user_auth,cont_view_episode_details);

router.get("/awardac/:flag",user_auth,cont_awardac); 
router.post("/awardac/:flag",user_auth,cont_awardac); 
router.get("/awardem/:flag",user_auth,cont_awardem); 
router.post("/awardem/:flag",user_auth,cont_awardem);

router.post("/delete_movie/:movieid",user_auth,cont_deletemovie); 
router.post("/delete_tvshow/:tvshowid",user_auth,cont_deletetvshow); 
router.post("/delete_reviewmovie/:reviewid",user_auth,cont_delete_review_movie); 
router.post("/delete_reviewshow/:reviewid",user_auth,cont_delete_review_show); 
router.post("/delete_reviewepisode/:reviewid",user_auth,cont_delete_review_episode); 

router.get("/delete_reviewuser/:userid",user_auth,cont_review_user); 

// // to view profile and add balance and change password
// router.get("/add_balance_form",user_auth,cont_add_balance_form);
// router.post("/add_balance",user_auth,cont_add_balance);
// router.get("/change_pass_page",user_auth,cont_change_pass)
// router.post("/change_pass",user_auth,cont_changepass)

// //to add user and block user
// router.get("/register_user",user_auth,cont_adduser);
// router.post("/register_user_save",user_auth,cont_registeruser);
// router.post("/user_block",user_auth,cont_block_user);

// //toshow,delete,update_user profile and view user profile 
// router.post("/user_update_page",user_auth,cont_userupdate); 

// //to add,show,buy product,update,delete product and update product details 
// router.post("/insertproduct",user_auth,cont_insertproduct); 
// router.get("/product",user_auth,cont_showproduct); 
// router.get("/product_admin",user_auth,cont_showproduct_admin); 
// router.post("/buy_product_form",user_auth,cont_buyproduct_form); 
// router.post("/buy_product",user_auth,cont_buyproduct);
// router.post("/user_update_page_product",user_auth,cont_update_product_page);
// router.post("/product_delete",user_auth,cont_product_delete);

// //to distibute amount earned (giving 25% to user_logined and 75% is distibuted among in parents in same way)
// router.post("/update_points_form",user_auth,cont_update_points_form); 
// router.post("/update_points",user_auth,cont_update_points); 

// //To show transactions
// router.get("/show_t",user_auth,cont_showt);

// // signout and send otp

module.exports=router;