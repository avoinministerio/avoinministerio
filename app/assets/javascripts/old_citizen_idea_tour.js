$(document).ready(function() {
  if(document.getElementById('idea_state') != undefined) {
    var old_citizen_idea_tour = new Tour({
      name: "old_citizen_idea_tour",
      afterSetState: function (key, value) {
        if (key == "end") {
          $.post('/citizens/touring', {name_of_tour: 'old_citizen_idea_tour', authenticity_token: authenticity_token});
        }
      }
    });
    old_citizen_idea_tour.addStep({
      element: "#logo",
      placement: "bottom",
      title: "Welcome to Avoin ministerio",
      content: "Some text"
    });
    old_citizen_idea_tour.addStep({
      element: "#account_actions",
      placement: "bottom",
      title: "Manage your account",
      content: "Some text"
    });
    old_citizen_idea_tour.addStep({
      element: "#idea_state",
      placement: "top",
      title: "Current state of the idea",
      content: "Some text"
    });
    old_citizen_idea_tour.addStep({
      element: "#voting",
      placement: "left",
      title: "Voting",
      content: "Some text"
    });
    old_citizen_idea_tour.addStep({
      element: "#add_comment",
      placement: "top",
      title: "Leave a comment",
      content: "Some text"
    });
    old_citizen_idea_tour.start();
  }
});