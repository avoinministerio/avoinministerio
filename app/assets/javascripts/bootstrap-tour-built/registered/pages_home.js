$(document).ready(function(){
	var tour = new Tour({
		name: "reg_pages_home_tour"
		,useLocalStorage: true
	});
	
	tour.addStep({ 
		path: "/",
		element: "#ab_section_proposal_0_link", 
		title: "Info title1 - logged in user", 
		content: "This is a proposal. Go there to look at it.",
		placement: "top" 
	});

	tour.addStep({ 
		path: "/",
		element: ".login_actions", 
		title: "Info title2 - logged in user", 
		content: "You can login either with Facebook or internally.",
		placement: "bottom" 
	});

	tour.addStep({ 
		path: "/",
		element: ".fb-like", 
		title: "Info title3 - logged in user", 
		content: "Watch more videos at Facebook. Join our group there.",
		placement: "left" 
	});

	tour.addStep({ 
		path: "/",
		element: "#mc-embedded-subscribe", 
		title: "Info title4 - logged in user", 
		content: "Subscribe to our news. Just enter your email and click the button",
		placement: "bottom" 
	});

	tour.start(true);
});