var homePageTour = function(){
	
var language="";
var response=$.ajax({url: "/languages/selectlanguage",
	type: "get",
	async: false,
	  context: document.body
	}).done(function(data) {
	  language=data.language;
	});

    var tour = new Tour();
var title;
var content;
if(language=="en"){
	var registerTitle="Sign up";
	var registerContent="By registering you can take a stand, to leave comments and take part in the preparation of initiatives.";
	
	var loginTitle="Log in";
	var loginContent="If you are already registered, you can login.";
	
	var loginfbTitle="Or login with your Facebook credentials"
	var loginfbContent="You can also log in with Facebook username and password, so do not need to register.";
	
	var allideasTitle="Browse ideas";
	var allideasContent="Some good ideas have already been a lot. Check them out and let your fleet!";
	
	var newideaTitle="Add to a new idea";
	var newideaContent="Do you have a good idea of ​​how to develop the Finnish? Here you can take the first step in the development of your ideas.";
	
	var topproposalsTitle="On-going initiatives";
	var topproposalsContent="This section displays the current on-going initiatives. These initiatives have 6 months to collect the legally required number of 50 000 supporters.";
	
	var top_draftsTitle="initiatives outlined in the";
	var top_draftsContent = "Drafts are the ideas advanced. For those already developed a draft text of the law. Their collection campaigns have not yet started.";
	
	var ideaexamplesTitle = "examples of ideas";
	var ideaexamplesContent = "Highlights submitted ideas. Click on the interesting idea and tell me you believe in, or are you against. Welcome back!";
	
	var grid_16alphamainbodyTitle="Idea";
	var grid_16alphamainbody="You can see who has no idea and what it's about.";
	
	var summaryTitle="summary";
	var summaryContent="This is the summary where the gist of an idea is written.";
	
	var jaabtnTitle="Support the idea";
	var jaabtnContent="You can tell when you're idea of ​​position you are logged in to.";
	
	var eibtnTitle="No, I do not agree";
	var eibtnContent="If the idea is not about you good, you should tell That too!";
	
	var ideacommentsTitle="Comment, discuss";
	var ideacommentsContent="Tell considered opinion. You can also send private messages if your comment is not intended for all to see.";
	
	var addthistoolboxTitle="Share with social media!";
	var addthistoolboxContent="It is very important that you share information about the initiative, so that all interested parties will find it.";
	
	var dateTitle="created.";
	var dateContent="This is the idea of ​​the creation date, that is, when the idea was staged to open the ministry.";
}
else{
	var registerTitle="Rekisteröidy";
	var registerContent="Rekisteröitymällä voit ottaa kantaa, jättää kommentteja ja ottaa osaa aloitteiden valmisteluun.";
	
	var loginTitle="Kirjaudu sisään";
	var loginContent="Jos olet jo rekisteröitynyt, voit kirjautua sisään.";
	
	var loginfbTitle="Tai kirjaudu Facebook-tunnuksilla"
	var loginfbContent="Voit myös kirjautua Facebook-tunnuksillasi, jolloin ei tarvitse rekisteröityä.";
	
	var allideasTitle="Selaile ideoita";
	var allideasContent="Hyviä ideoita on jo jätetty paljon. Tutustu niihin ja anna kantasi!";
	
	var newideaTitle="Lisää uusi idea";
	var newideaContent="Onko sinulla hyvä idea miten kehittää Suomea? Tästä voit ottaa ensimmäisen askeleen ideasi kehittämiseen.";
	
	var topproposalsTitle="Meneillään olevia aloitteita";
	var topproposalsContent="Tässä osiossa näytetään nykyisiä meneillään olevia aloitteita. Aloitteilla on 6kk aikaa kerätä laissa vaadittu 50 000 kannattajien joukko.";
	
	var top_draftsTitle="Luonnosteltuja aloitteita";
	var top_draftsContent = "Luonnokset ovat ideoita pidemmällä. Niille on jo kehitetty lakitekstin luonnos. Niiden keruukampanjat eivät ole vielä käynnistyneet.";
	
	var ideaexamplesTitle = "Esimerkkejä ideoista";
	var ideaexamplesContent = "Poimintoja jätetyistä ideoista. Klikkaa kiinnostavaa ideaa ja kerro kannatatko vai oletko vastaan. Tervetuloa!";
	
	var grid_16alphamainbodyTitle="ajatus";
	var grid_16alphamainbody="Näet kuka on jättänyt idean ja mistä se kertoo.";
	
	var summaryTitle="Tiivistelmä";
	var summaryContent="Tämä on tiivistelmä, jossa ydin idea on kirjoitettu.";
	
	var jaabtnTitle="Kannata ideaa";
	var jaabtnContent="Voit kertoa olevasi idean kannalla kun olet kirjautunut sisään.";
	
	var eibtnTitle="Ei, en kannata";
	var eibtnContent="Jos idea ei ole sinusta hyvä, kannattaa kertoa siitäkin!";
	
	var ideacommentsTitle="Kommentoi, keskustele";
	var ideacommentsContent="Kerro harkittu mielipiteesi. Voit myös lähettää yksityisviestejä, jos kommenttisi ei ole tarkoitettu kaikkien nähtäväksi.";
	
	var addthistoolboxTitle="Jaa sosiaaliseen mediaan!";
	var addthistoolboxContent="On hyvin tärkeää, että jaat tietoa aloitteesta, niin että kaikki kiinnostuneet löytävät sen.";
	
	var dateTitle="luotu.";
	var dateContent="Tämä on idea luontipäivämäärää, eli kun ajatus oli lavastettu auki ministeriö.";
}

    tour.addStep({
        element: "#register",
        placement: "bottom",
        title: registerTitle,
        content: registerContent
    });
    
    tour.addStep({
        element: "#login",
        placement: "bottom",
        title: loginTitle,
        content: loginContent
    });
    
    tour.addStep({
        element: "#login-fb",
        placement: "bottom",
        title: loginfbTitle,
        content: loginfbContent
    });
    
    tour.addStep({
        element: "#all-ideas",
        placement: "left",
        title: allideasTitle,
        content: allideasContent
    });
    
    tour.addStep({
        element: "#new-idea",
        placement: "bottom",
        title: newideaTitle,
        content: newideaContent
    });
    
    tour.addStep({
        element: ".top_proposals",
        placement: "top",
        title: topproposalsTitle,
        content: topproposalsContent
    });
    
    tour.addStep({
        element: ".top_drafts",
        placement: "top",
        title: top_draftsTitle,
        content: top_draftsContent
    });
    
    tour.addStep({
        element: "#idea-examples",
        placement: "top",
        title: ideaexamplesTitle,
        content: ideaexamplesContent
    });
    tour.start();
}

var ideaShowPageTour = function(){
    var tour = new Tour();
    
    tour.addStep({
        element: ".grid_16.alpha.mainbody",
        placement: "top",
        title: grid_16alphamainbodyTitle,
        content: grid_16alphamainbody
    });
    
    tour.addStep({
        element: ".summary",
        placement: "bottom",
        title: summaryTitle,
        content: summaryContent
    });
    
    tour.addStep({
        element: ".jaa-btn",
        placement: "left",
        title: jaabtnTitle,
        content: jaabtnContent
    });
    
    tour.addStep({
        element: ".ei-btn",
        placement: "left",
        title: eibtnTitle,
        content: eibtnContent
    });
    
    tour.addStep({
        element: ".idea_comments#comments",
        placement: "top",
        title: ideacommentsTitle,
        content: ideacommentsContent
    });
    
    tour.addStep({
        element: ".addthis_toolbox",
        placement: "left",
        title: addthistoolboxTitle,
        content: addthistoolboxContent
    });
    
    tour.addStep({
        element: ".date",
        placement: "bottom",
        title: dateTitle,
        content: dateContent
    });

    tour.start();
}