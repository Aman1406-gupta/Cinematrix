let {ser_view_award_details,ser_view_celeb_details,ser_view_tvshow_details, ser_view_movie_details,ser_deleteac,ser_tpseriesshow,ser_reseriesshow,ser_seriesshow,ser_tpshowmovie,ser_reshowmovie,ser_showmovie,ser_pcelebview,ser_btcelebview,ser_celebview,ser_awardview,ser_signout,ser_home,ser_insert,ser_validation,ser_registeruser,ser_adminprofile,ser_showproduct,ser_addproduct,ser_deleteuser,ser_viewusercomodity,ser_userupdate,ser_userprofileupdate,ser_update_points,ser_update_points_form, ser_showproduct_admin,ser_buyproduct,ser_buyproduct_form,ser_add_balance,ser_add_balance_form,ser_update_product,ser_update_product_page,ser_product_delete,ser_changepass,ser_showt}=require("../servers/service");


exports.cont_adduser=async(req,rep)=>{
    rep.render("registeruser")
}   


///////////////////////
exports.cont_signin=async(req,rep)=>{
    rep.render("adminlogin");
}

exports.cont_signup=async(req,rep)=>{
    rep.render("register");
}

exports.cont_home=async(req,rep)=>{
    let userdata=await ser_home(req,rep);
    rep.render("dashboard",{data:userdata.admindatarec});
}

exports.cont_insert=async(req,rep)=>{
    await ser_insert(req,rep);
}

exports.cont_validation=async(req,rep)=>{
    try {
        let data= await ser_validation(req,rep);
        if(data){
            rep.render("dashboard",{data:data.newdata});
        }
        else{
            rep.render("adminlogin");
        }
    }
    catch {
        rep.redirect('/signin');
    }
}

exports.cont_adminprofile=async(req,rep)=>{
    let admindata=await ser_adminprofile(req,rep);
    rep.render("adminprofile",{data:admindata.admindatarec});
}

exports.cont_userprofileupdate=async(req,rep)=>{
    let userupdateddatau=await ser_userprofileupdate(req,rep);
}

exports.cont_signout=async(req,rep)=>{
    await ser_signout(req,rep); 
    rep.redirect("/signin");
}

exports.cont_deleteac=async(req,rep)=>{
    await ser_deleteac(req,rep); 
    rep.redirect("/signin");
}

exports.cont_tpshowmovie=async(req,rep)=>{
    let moviedatashown= await ser_tpshowmovie(req,rep);
    rep.render("tpviewmovie",{moviedata:moviedatashown.moviedata,data:moviedatashown.newdata});
}

exports.cont_showmovie=async(req,rep)=>{
    let moviedatashown= await ser_showmovie(req,rep);
    rep.render("viewmovie",{moviedata:moviedatashown.moviedata,data:moviedatashown.newdata.User_Role});
}

exports.cont_reshowmovie=async(req,rep)=>{
    let moviedatashown= await ser_reshowmovie(req,rep);
    rep.render("reviewmovies",{moviedata:moviedatashown.moviedata,data:moviedatashown.newdata});
}

exports.cont_tpseriesshow=async(req,rep)=>{
    let seriesdatashown= await ser_tpseriesshow(req,rep);
    rep.render("tpviewseries",{seriesdata:seriesdatashown.seriesdata,data:seriesdatashown.newdata});
}

exports.cont_reseriesshow=async(req,rep)=>{
    let seriesdatashown= await ser_reseriesshow(req,rep);
    rep.render("reviewseries",{seriesdata:seriesdatashown.seriesdata,data:seriesdatashown.newdata});
}

exports.cont_seriesshow=async(req,rep)=>{
    let seriesdatashown= await ser_seriesshow(req,rep);
    rep.render("viewseries",{seriesdata:seriesdatashown.seriesdata,data:seriesdatashown.newdata.parentmail});
}

exports.cont_celebview=async(req,rep)=>{
    let celebdatashown= await ser_celebview(req,rep);
    rep.render("viewceleb",{celebdata:celebdatashown.celebdata,data:celebdatashown.newdata.parentmail});
}

exports.cont_pcelebview=async(req,rep)=>{
    let pcelebdatashown= await ser_pcelebview(req,rep);
    rep.render("pviewcelebs",{celebdata:pcelebdatashown.celebdata,data:pcelebdatashown.newdata});
}

exports.cont_btcelebview=async(req,rep)=>{
    let btcelebdatashown= await ser_btcelebview(req,rep);
    rep.render("btviewcelebs",{celebdata:btcelebdatashown.celebdata,data:btcelebdatashown.newdata});
}

exports.cont_awardview=async(req,rep)=>{
    let awarddatashown= await ser_awardview(req,rep);
    rep.render("viewaward",{awarddata:awarddatashown.awarddata,data:awarddatashown.newdata.parentmail});
}

exports.cont_view_movie_details=async(req,rep)=>{
    let movieid=req.params.movieid;
    let moviedetailsshown= await ser_view_movie_details(movieid,rep);
    rep.render("viewmoviedetails",{moviedetails:moviedetailsshown.moviedetails,data:moviedetailsshown.newdata.parentmail});
}

exports.cont_view_tvshow_details=async(req,rep)=>{
    let tvshowid=req.params.tvshowid;
    let tvshowdetailsshown= await ser_view_tvshow_details(tvshowid,rep);
    rep.render("viewtvshowdetails",{tvshowdetails:tvshowdetailsshown.tvshowdetails,data:tvshowdetailsshown.newdata.parentmail});
}

exports.cont_view_celeb_details=async(req,rep)=>{
    let celebid=req.params.celebid;
    let celebdetailsshown= await ser_view_celeb_details(celebid,rep);
    rep.render("viewcelebdetails",{celebdetails:celebdetailsshown.celebdetails,data:celebdetailsshown.newdata.parentmail});
}

exports.cont_view_award_details=async(req,rep)=>{
    let awardid=req.params.awardid;
    let awarddetailsshown= await ser_view_award_details(awardid,rep);
    rep.render("viewawarddetails",{awarddetails:awarddetailsshown.awarddetails,data:awarddetailsshown.newdata.parentmail});
}

////////////////////////

exports.cont_registeruser=async(req,rep)=>{
    await ser_registeruser(req,rep);
    rep.render("dashboard");
}

exports.cont_insertproduct=async(req,rep)=>{   
    await ser_addproduct(req,rep);
    rep.render("dashboard")
}

exports.cont_showproduct=async(req,rep)=>{
    let productdatashown= await ser_showproduct_admin(req,rep);
    let parent_data_shown=productdatashown.parentdatashown
    productdatashown=productdatashown.productdata;
    rep.render("viewproduct",{product:productdatashown,searchdata:parent_data_shown});
}

exports.cont_showproduct_admin=async(req,rep)=>{
    let productdatashown= await ser_showproduct_admin(req,rep);
    let parent_data_shown=productdatashown.parentdatashown
    productdatashown=productdatashown.productdata;
    rep.render("viewproduct_admin",{product:productdatashown,searchdata:parent_data_shown});
}

exports.cont_deleteuser=async(req,rep)=>{
    let userdata=await ser_deleteuser(req,rep);
    rep.redirect("/userview");
}

exports.cont_viewusercomodity=async(req,rep)=>{
    let userdata=await ser_viewusercomodity(req,rep);
    rep.render("viewusercomodity",{data:userdata});
}

exports.cont_userupdate=async(req,rep)=>{
    let userupdateddata=await ser_userupdate(req,rep);
    rep.render("updateservice",{data:userupdateddata.rootdata,searchdata:userupdateddata.datashown});
}

exports.cont_update_points_form=async(req,rep)=>{
    let userupdateddatauf=await ser_update_points_form(req,rep);
    rep.render("update_points_form",{data:userupdateddatauf})
}

exports.cont_update_points=async(req,rep)=>{
    let userupdateddatau=await ser_update_points(req,rep);
    let parentdata=userupdateddatau.final_user_details_shown.parentmail
    rep.render("viewuser",{user:userupdateddatau.final_user_details_shown,data:userupdateddatau.data.parentmail,searchdata:parentdata})
}

exports.cont_buyproduct_form=async(req,rep)=>{
    let product_info=await ser_buyproduct_form(req,rep);
    
    rep.render("buy_product_form",{productid:product_info});
}

exports.cont_buyproduct=async(req,rep)=>{
    await ser_buyproduct(req,rep);
    rep.redirect("/product");
}

exports.cont_add_balance_form=async (req,rep)=>{
    let user_info=await ser_add_balance_form(req,rep);
    rep.render("add_balance_form_new",{searchdata:user_info});
}

exports.cont_add_balance=async (req,rep)=>{ 
    let add_balance=await ser_add_balance(req,rep);
}

exports.cont_update_product_page=async(req,rep)=>{
    let product_info=await ser_update_product_page(req,rep);
    let productdata=product_info.productdata
    let rootdata=product_info.rootdata
    rep.render("update_product",{data:rootdata,productdata:productdata});
}

exports.cont_product_delete=async(req,rep)=>{
    let deleteproduct=await ser_product_delete(req,rep);
    rep.redirect("/product_admin");
}

exports.cont_change_pass=async(req,rep)=>{
    rep.render("changepass");
}

//not able to redirect at dashboard page (because dashboard needs data)
exports.cont_changepass=async(req,rep)=>{
    let changepass=await ser_changepass(req,rep);
    rep.redirect("/signup");
}

exports.cont_showt=async(req,rep)=>{
    let showt=await ser_showt(req,rep);
    rep.render("transaction",{data:showt.data,tdata:showt.tdata})
}

exports.cont_block_user=async(req,rep)=>{
    let block_user=await ser_block_user(req,rep);
    rep.redirect("userview");
}