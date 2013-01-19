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
    
    tour.start(true);
}

var ideaShowPageTour = function(){
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
    
    //tour.addStep({
    //  element: "#faq",
    //  placement: "left",
    //  title: "Having doubts?",
    //  content: "If you have some doubts and questions, navigate to FAQ page. We have already answered most of your common questions."
    //});
    
    tour.start();
}
