$(document).ready(function(){
	var tour = new Tour({
		name: "ideas_show_tour",
		storageType: "database",
		sourceController: "ideas",
		sourceAction: "show"
	});
	tour.addStep({ 
		element: ".share", 
		title: "Info title1 - logged in user", 
		content: "Share it!", 
		placement: "left", 
		reflex: true
	});

	tour.addStep({ 
		element: ".signature-statistics", 
		title: "Info title2 - logged in user", 
		content: "Here is the statistics for the idea.",
		placement: "left", 
		reflex: true
	});

	tour.addStep({ 
		element: "#comment_body", 
		title: "Info title3 - logged in user", 
		content: "You can leave a comment right here.",
		placement: "top", 
		reflex: true
	});

	tour.start(true);
});
