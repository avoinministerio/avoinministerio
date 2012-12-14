$(document).ready(function() {
  if(document.getElementById('idea_state') != undefined) {
    var citizen_idea_tour = new Tour({
      name: "citizen_idea_tour",
      afterSetState: function (key, value) {
        if (key == "end") {
          $.post('/citizens/touring', {name_of_tour: 'citizen_idea_tour', authenticity_token: authenticity_token});
        }
      }
    });
    citizen_idea_tour.addStep({
      element: "#logo",
      placement: "bottom",
      title: "Welcome to Avoin ministerio",
      content: "Some text"
    });
    citizen_idea_tour.addStep({
      element: "#account_actions",
      placement: "bottom",
      title: "Manage your account",
      content: "Some text"
    });
    citizen_idea_tour.addStep({
      element: "#idea_state",
      placement: "top",
      title: "Current state of the idea",
      content: "Some text"
    });
    citizen_idea_tour.addStep({
      element: "#voting",
      placement: "left",
      title: "Voting",
      content: "Some text"
    });
    citizen_idea_tour.addStep({
      element: "#add_comment",
      placement: "top",
      title: "Leave a comment",
      content: "Some text"
    });
    citizen_idea_tour.start();
  }
  else {
    var citizen_home_tour = new Tour({
      name: "citizen_home_tour",
      afterSetState: function (key, value) {
        if (key == "end") {
          $.post('/citizens/touring', {name_of_tour: 'citizen_home_tour', authenticity_token: authenticity_token});
        }
      }
    });
    citizen_home_tour.addStep({
      element: "#logo",
      placement: "bottom",
      title: "Welcome to Avoin ministerio",
      content: "Some text"
    });
    citizen_home_tour.addStep({
      element: "#account_actions",
      placement: "bottom",
      title: "Manage your account",
      content: "Some text"
      });
    citizen_home_tour.addStep({
      element: "#show_ideas",
      placement: "left",
      title: "Show ideas",
      content: "Some"
    });
    citizen_home_tour.addStep({
      element: "#add_idea",
      placement: "left",
      title: "Or add your own",
      content: "Some text"
    });
    citizen_home_tour.addStep({
      element: "#newsletter",
      placement: "left",
      title: "Subscribe",
      content: "Some text"
    });
    citizen_home_tour.addStep({
      element: "#ideas",
      placement: "top",
      title: "List of the last ideas",
      content: "Some text"
    });
    citizen_home_tour.start();
  };
});