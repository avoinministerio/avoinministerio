var homePageTour = function(){
    var tour = new Tour();
    
    tour.addStep({
        element: "#register",
        placement: "bottom",
        title: "Register with us",
        content: "Register with us and get chance to participate in laws making and give your children a better country to live in."
    });
    
    tour.addStep({
        element: "#login",
        placement: "bottom",
        title: "Login here",
        content: "If you already have signed up, login from here"
    });
    
    tour.addStep({
        element: "#login-fb",
        placement: "bottom",
        title: "Login using facebook account",
        content: "There are more options for login, use your facebook account to log into the website."
    });
    
    tour.addStep({
        element: "#all-ideas",
        placement: "left",
        title: "See all existing ideas",
        content: "Have a look to all the existing ideas."
    });
    
    tour.addStep({
        element: "#new-idea",
        placement: "bottom",
        title: "Enter new idea",
        content: "Got an idea which can make system better? This is the place where your idea can take a step to become a law."
    });
    
    tour.addStep({
        element: ".proposal-section",
        placement: "top",
        title: "Proposal's Showcase",
        content: "Showing you existing proposals."
    });
    
    tour.addStep({
        element: ".draft-section",
        placement: "top",
        title: "Draft's Showcase",
        content: "Showing you existing drafts."
    });
    
    tour.addStep({
        element: "#idea-examples",
        placement: "top",
        title: "Examples for ideas",
        content: "Want to add some idea? Have a look to these examples before adding new idea."
    });
    tour.start();
}

var ideaShowPageTour = function(){
    var tour = new Tour();
    
    tour.addStep({
        element: ".body",
        placement: "top",
        title: "Breif",
        content: "Breif description on the idea."
    });
    
    tour.addStep({
        element: ".summary",
        placement: "bottom",
        title: "Summary of the idea",
        content: "This is the summary where the gist of an idea is written."
    });
    
    tour.addStep({
        element: ".jaa-btn",
        placement: "left",
        title: "Yes, I favor.",
        content: "Click here to vote if you favor the idea."
    });
    
    tour.addStep({
        element: ".ei-btn",
        placement: "left",
        title: "No, I don't favor.",
        content: "Click here to vote againt the idea."
    });
    
    tour.addStep({
        element: ".comments",
        placement: "top",
        title: "Enter the comments.",
        content: "Enter the comments about the idea here."
    });
    
    tour.addStep({
        element: ".addthis_toolbox",
        placement: "left",
        title: "Share on social media.",
        content: "Share on your social network account from here."
    });
    
    tour.addStep({
        element: ".date",
        placement: "bottom",
        title: "Created on.",
        content: "This is the Idea creation date, i.e. when the idea was staged on the open ministry."
    });
    tour.start();
}
