let {ser_delwtshow,ser_delwtmovie,ser_watchlist,ser_deletewatchlistshow,ser_deletewatchlistmovie,ser_watchlistmovie,ser_watchlistshow,ser_episodereview,ser_tvshowreview,ser_moviereview,ser_deletereview,ser_review,ser_review_user,ser_delete_review_episode,ser_delete_review_show,ser_delete_review_movie,ser_deletetvshow,ser_deletemovie,ser_view_episode_details,ser_view_celeb_details,ser_view_tvshow_details, ser_view_movie_details,ser_deleteac,ser_tpseriesshow,ser_reseriesshow,ser_seriesshow,ser_tpshowmovie,ser_reshowmovie,ser_showmovie,ser_pcelebview,ser_btcelebview,ser_celebview,ser_awardac,ser_awardem,ser_signout,ser_home,ser_insert,ser_validation,ser_adminprofile,ser_userprofileupdate}=require("../servers/service");

exports.cont_signin=async(req,rep)=>{
    rep.render("adminlogin", {message: "",message2: ""});
}

exports.cont_signup=async(req,rep)=>{
    rep.render("register", {message: ""});
}

exports.cont_home=async(req,rep)=>{
    let userdata=await ser_home(req,rep);
    rep.render("dashboard",{data:userdata.admindatarec});
}

exports.cont_insert=async(req,rep)=>{
    try {
    let dataobj = await ser_insert(req,rep);
    rep.render('adminlogin', {message: "",message2: dataobj.message})
    }
    catch(err) {
        rep.render('register', {message:err.message})
    }
}

exports.cont_validation=async(req,rep)=>{
    try {
        let data= await ser_validation(req,rep);
        if(data){
            rep.render("dashboard",{data:data.newdata});
        }
        else{
            rep.render("adminlogin", {message: "",message2: ""});
        }
    }
    catch(err) {
        rep.render('adminlogin', {message:err.message,message2: ""});
    }
}

exports.cont_watchlistmovie=async(req,rep)=>{
    let movieid = req.params.movieid;
    let watchlistdetails = await ser_watchlistmovie(req,rep,movieid); 
    rep.redirect(`/view_movie_details/${movieid}`);
}

exports.cont_watchlistshow=async(req,rep)=>{
    let showid = req.params.showid;
    let watchlistdetails = await ser_watchlistshow(req,rep,showid); 
    rep.redirect(`/view_tvshow_details/${showid}`);
}

exports.cont_deletewatchlistmovie=async(req,rep)=>{
    let movieid = req.params.movieid;
    let watchlistdetails = await ser_deletewatchlistmovie(req,rep,movieid); 
    rep.redirect(`/view_movie_details/${movieid}`);
}

exports.cont_deletewatchlistshow=async(req,rep)=>{
    let showid = req.params.showid;
    let watchlistdetails = await ser_deletewatchlistshow(req,rep,showid); 
    rep.redirect(`/view_tvshow_details/${showid}`);
}

exports.cont_watchlist=async(req,rep)=>{
    let watchlistdetails = await ser_watchlist(req,rep); 
    rep.render("watchlist",{mwatchlistdetails:watchlistdetails.mwatchlistdetails,rwatchlistdetails:watchlistdetails.twatchlistdetails,data:watchlistdetails.newdata});
}

exports.cont_delwtmovie=async(req,rep)=>{
    let movieid = req.params.movieid;
    let watchlistdetails = await ser_delwtmovie(req,rep,movieid); 
    rep.redirect("/watchlist");
}

exports.cont_delwtshow=async(req,rep)=>{
    let showid = req.params.showid;
    let watchlistdetails = await ser_delwtshow(req,rep,showid); 
    rep.redirect("/watchlist");
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

exports.cont_review=async(req,rep)=>{
    let reviewdetails = await ser_review(req,rep); 
    rep.render("userreview",{mreviewdetails:reviewdetails.mreviewdetails,treviewdetails:reviewdetails.treviewdetails,ereviewdetails:reviewdetails.ereviewdetails,data:reviewdetails.newdata});
}

exports.cont_moviereview=async(req,rep)=>{
    let movieid = req.params.movieid;
    let reviewdetails = await ser_moviereview(req,rep,movieid); 
    rep.redirect(`/view_movie_details/${movieid}`);
}

exports.cont_tvshowreview=async(req,rep)=>{
    let showid = req.params.showid;
    let reviewdetails = await ser_tvshowreview(req,rep,showid); 
    rep.redirect(`/view_tvshow_details/${showid}`);
}

exports.cont_episodereview=async(req,rep)=>{
    let showid = req.params.showid;
    let sno = req.params.sno;
    let eno = req.params.eno;
    let reviewdetails = await ser_episodereview(req,rep,showid,sno,eno); 
    rep.redirect(`/view_episode_details/${showid}/${sno}/${eno}`);
}

exports.cont_deletereview=async(req,rep)=>{
    let reviewid = req.params.reviewid;
    let reviewdetails = await ser_deletereview(req,rep,reviewid); 
    rep.redirect("/review");
}

exports.cont_deleteac=async(req,rep)=>{
    let dataobj = await ser_deleteac(req,rep); 
    rep.render("adminlogin", {message: dataobj.message,message2: ""});
}

exports.cont_tpshowmovie=async(req,rep)=>{
    let moviedatashown= await ser_tpshowmovie(req,rep);
    rep.render("tpviewmovie",{moviedata:moviedatashown.moviedata,data:moviedatashown.newdata});
}

exports.cont_showmovie=async(req,rep)=>{
    let flag = req.params.flag;
    let moviedatashown= await ser_showmovie(req,rep,flag);
    rep.render("viewmovie",{moviedata:moviedatashown.moviedata,data:moviedatashown.newdata,message:moviedatashown.message});
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
    let flag = req.params.flag;
    let seriesdatashown= await ser_seriesshow(req,rep,flag);
    rep.render("viewseries",{seriesdata:seriesdatashown.seriesdata,data:seriesdatashown.newdata, message:seriesdatashown.message});
}

exports.cont_celebview=async(req,rep)=>{
    let flag = req.params.flag;
    let celebdatashown= await ser_celebview(req,rep,flag);
    rep.render("viewceleb",{celebdata:celebdatashown.celebdata,data:celebdatashown.newdata,message:celebdatashown.message,nationalitydata:celebdatashown.nationalitydata});
}

exports.cont_pcelebview=async(req,rep)=>{
    let pcelebdatashown= await ser_pcelebview(req,rep);
    rep.render("pviewcelebs",{celebdata:pcelebdatashown.celebdata,data:pcelebdatashown.newdata});
}

exports.cont_btcelebview=async(req,rep)=>{
    let btcelebdatashown= await ser_btcelebview(req,rep);
    rep.render("btviewcelebs",{celebdata:btcelebdatashown.celebdata,message:btcelebdatashown.message,data:btcelebdatashown.newdata});
}

exports.cont_view_movie_details=async(req,rep)=>{
    let movieid=req.params.movieid; 
    let moviedetailsshown= await ser_view_movie_details(movieid,rep);
    rep.render("viewmoviedetails",{watchlistdetails:moviedetailsshown.watchlistdetails,movieid:moviedetailsshown.movieid,moviedetails:moviedetailsshown.moviedetails,genredetails:moviedetailsshown.genredetails,actordetails:moviedetailsshown.actordetails,directordetails:moviedetailsshown.directordetails,producerdetails:moviedetailsshown.producerdetails,streamdetails:moviedetailsshown.streamdetails,prequeldetails:moviedetailsshown.prequeldetails,sequeldetails:moviedetailsshown.sequeldetails,languagedetails:moviedetailsshown.languagedetails,awarddetails:moviedetailsshown.awarddetails,reviewdetails:moviedetailsshown.reviewdetails,data:moviedetailsshown.newdata});
}

exports.cont_view_tvshow_details=async(req,rep)=>{
    let tvshowid=req.params.tvshowid;
    let tvshowdetailsshown= await ser_view_tvshow_details(tvshowid,rep);
    rep.render("viewtvshowdetails",{watchlistdetails:tvshowdetailsshown.watchlistdetails,tvshowid:tvshowdetailsshown.tvshowid,tvshowdetails:tvshowdetailsshown.tvshowdetails,seaandepdata:tvshowdetailsshown.seaandepdata,episodedetails:tvshowdetailsshown.episodedetails,genredetails:tvshowdetailsshown.genredetails,actordetails:tvshowdetailsshown.actordetails,directordetails:tvshowdetailsshown.directordetails,producerdetails:tvshowdetailsshown.producerdetails,streamdetails:tvshowdetailsshown.streamdetails,languagedetails:tvshowdetailsshown.languagedetails,awarddetails:tvshowdetailsshown.awarddetails,reviewdetails:tvshowdetailsshown.reviewdetails,data:tvshowdetailsshown.newdata});
}

exports.cont_view_episode_details=async(req,rep)=>{
    let tvshowid=req.params.tvshowid;
    let sno=req.params.sno;
    let eno=req.params.eno;
    let epdetailsshown= await ser_view_episode_details(tvshowid,sno,eno,rep);
    rep.render("viewepisodedetails",{tvshowid:epdetailsshown.tvshowid,sno:epdetailsshown.sno,eno:epdetailsshown.eno,epdetails:epdetailsshown.epdetails,actordetails:epdetailsshown.actordetails,directordetails:epdetailsshown.directordetails,producerdetails:epdetailsshown.producerdetails,reviewdetails:epdetailsshown.reviewdetails,data:epdetailsshown.newdata});
}

exports.cont_view_celeb_details=async(req,rep)=>{
    let celebid=req.params.celebid;
    let celebdetailsshown= await ser_view_celeb_details(celebid,rep);
    rep.render("viewcelebdetails",{celebdetails:celebdetailsshown.celebdata,ds:celebdetailsshown.ds,rr:celebdetailsshown.rr,pm:celebdetailsshown.pm,awarddetails:celebdetailsshown.awarddetails,dnum:celebdetailsshown.dnum,anum:celebdetailsshown.anum,pnum:celebdetailsshown.pnum,afam:celebdetailsshown.afam,pfam:celebdetailsshown.pfam,dfam:celebdetailsshown.dfam,moviedetailsact:celebdetailsshown.mda,moviedetailsdir:celebdetailsshown.mdd,moviedetailspro:celebdetailsshown.mdp,showdetailsact:celebdetailsshown.sda,showdetailsdir:celebdetailsshown.sdd,showdetailspro:celebdetailsshown.sdp,data:celebdetailsshown.newdata});
}

exports.cont_awardac=async(req,rep)=>{
    let flag = req.params.flag;
    let awarddatashown= await ser_awardac(req,rep,flag);
    rep.render("viewawardac",{awarddata:awarddatashown.awarddata,data:awarddatashown.newdata,message:awarddatashown.message, actionpath:awarddatashown.actionpath});
}

exports.cont_awardem=async(req,rep)=>{
    let flag = req.params.flag;
    let awarddatashown= await ser_awardem(req,rep,flag);
    rep.render("viewawardem",{awarddata:awarddatashown.awarddata,data:awarddatashown.newdata,message:awarddatashown.message, actionpath:awarddatashown.actionpath});
}

exports.cont_deletemovie=async(req,rep)=>{
    let movieid=req.params.movieid;
    let deletedmovie=await ser_deletemovie(req,rep,movieid);
    rep.redirect("/movieview/0");
}

exports.cont_deletetvshow=async(req,rep)=>{
    let tvshowid=req.params.tvshowid;
    let deletedtvshow=await ser_deletetvshow(req,rep,tvshowid);
    rep.redirect("/seriesshow/0");
}

exports.cont_delete_review_movie=async(req,rep)=>{
    let reviewid=req.params.reviewid;
    let deletedmoviereview=await ser_delete_review_movie(req,rep,reviewid);
    rep.redirect(`/view_movie_details/${deletedmoviereview.movieid}`);
}

exports.cont_delete_review_show=async(req,rep)=>{
    let reviewid=req.params.reviewid;
    let deletedshowreview=await ser_delete_review_show(req,rep,reviewid);
    rep.redirect(`/view_tvshow_details/${deletedshowreview.showid}`);
}

exports.cont_delete_review_episode=async(req,rep)=>{
    let reviewid=req.params.reviewid;
    let deletedmoviereview=await ser_delete_review_episode(req,rep,reviewid);
    rep.redirect(`/view_episode_details/${deletedmoviereview.showid}/${deletedmoviereview.sno}/${deletedmoviereview.eno}`);
}

exports.cont_review_user=async(req,rep)=>{
    let userid=req.params.userid;
    let reviewuserdetails=await ser_review_user(req,rep,userid);
    rep.render("userprofile",{data:reviewuserdetails.newdata,userdata:reviewuserdetails.userdatarec});
}
