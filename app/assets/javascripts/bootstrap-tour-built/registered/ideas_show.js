$(document).ready(function(){
	var tour = new Tour({name: "ideas_show_tour"});
	tour.addStep({ 
		element: ".btn.jaa-btn-disabled", 
		title: "Info title1 - loggen in user", 
		content: "You should login to leave a notification support.", 
		placement: "left", 
		reflex: true
	});

	tour.addStep({ 
		element: ".signature-statistics", 
		title: "Info title2 - loggen in user", 
		content: "Here is the statistics for the idea.",
		placement: "left", 
		reflex: true
	});

	tour.addStep({ 
		element: "#comment_body", 
		title: "Info title3 - loggen in user", 
		content: "You can leave a comment right here.",
		placement: "top", 
		reflex: true
	});

	tour.start(true);
});
