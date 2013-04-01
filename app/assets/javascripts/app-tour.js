var homePageTour = function(){
    var tour = new Tour();
    
    tour.addStep({
        element: "#register",
        placement: "bottom",
        title: "Rekisteröidy",
        content: "Rekisteröitymällä voit ottaa kantaa, jättää kommentteja ja ottaa osaa aloitteiden valmisteluun."
    });
    
    tour.addStep({
        element: "#login",
        placement: "bottom",
        title: "Kirjaudu sisään",
        content: "Jos olet jo rekisteröitynyt, voit kirjautua sisään."
    });
    
    tour.addStep({
        element: "#login-fb",
        placement: "bottom",
        title: "Tai kirjaudu Facebook-tunnuksilla",
        content: "Voit myös kirjautua Facebook-tunnuksillasi, jolloin ei tarvitse rekisteröityä."
    });
    
    tour.addStep({
        element: "#all-ideas",
        placement: "left",
        title: "Selaile ideoita",
        content: "Hyviä ideoita on jo jätetty paljon. Tutustu niihin ja anna kantasi!"
    });
    
    tour.addStep({
        element: "#new-idea",
        placement: "bottom",
        title: "Lisää uusi idea",
        content: "Onko sinulla hyvä idea miten kehittää Suomea? Tästä voit ottaa ensimmäisen askeleen ideasi kehittämiseen."
    });
    
    tour.addStep({
        element: ".top_proposals",
        placement: "top",
        title: "Meneillään olevia aloitteita",
        content: "Tässä osiossa näytetään nykyisiä meneillään olevia aloitteita. Aloitteilla on 6kk aikaa kerätä laissa vaadittu 50 000 kannattajien joukko."
    });
    
    tour.addStep({
        element: ".top_drafts",
        placement: "top",
        title: "Luonnosteltuja aloitteita",
        content: "Luonnokset ovat ideoita pidemmällä. Niille on jo kehitetty lakitekstin luonnos. Niiden keruukampanjat eivät ole vielä käynnistyneet."
    });
    
    tour.addStep({
        element: "#idea-examples",
        placement: "top",
        title: "Esimerkkejä ideoista",
        content: "Poimintoja jätetyistä ideoista. Klikkaa kiinnostavaa ideaa ja kerro kannatatko vai oletko vastaan. Tervetuloa!"
    });
    tour.start();
}

var ideaShowPageTour = function(){
    var tour = new Tour();
    
    tour.addStep({
        element: ".grid_16.alpha.mainbody",
        placement: "top",
        title: "Idea",
        content: "Näet kuka on jättänyt idean ja mistä se kertoo."
    });
    
    tour.addStep({
        element: ".summary",
        placement: "bottom",
        title: "Tiivistelmä",
        content: "This is the summary where the gist of an idea is written."
    });
    
    tour.addStep({
        element: ".jaa-btn",
        placement: "left",
        title: "Kannata ideaa",
        content: "Voit kertoa olevasi idean kannalla kun olet kirjautunut sisään."
    });
    
    tour.addStep({
        element: ".ei-btn",
        placement: "left",
        title: "Ei, en kannata",
        content: "Jos idea ei ole sinusta hyvä, kannattaa kertoa siitäkin!"
    });
    
    tour.addStep({
        element: ".idea_comments#comments",
        placement: "top",
        title: "Kommentoi, keskustele",
        content: "Kerro harkittu mielipiteesi. Voit myös lähettää yksityisviestejä, jos kommenttisi ei ole tarkoitettu kaikkien nähtäväksi."
    });
    
    tour.addStep({
        element: ".addthis_toolbox",
        placement: "left",
        title: "Jaa sosiaaliseen mediaan!",
        content: "On hyvin tärkeää, että jaat tietoa aloitteesta, niin että kaikki kiinnostuneet löytävät sen."
    });
    
    tour.start();
}
