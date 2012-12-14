$(document).ready(function() {
  var old_citizen_home_tour = new Tour({
    name: "old_citizen_home_tour",
    afterSetState: function (key, value) {
      if (key == "end") {
        $.post('/citizens/touring', {name_of_tour: 'old_citizen_home_tour', authenticity_token: authenticity_token});
      }
    }
  });
  old_citizen_home_tour.addStep({
    element: "#logo",
    placement: "bottom",
    title: "Welcome to Avoin ministerio",
    content: "Some text"
  });
  old_citizen_home_tour.addStep({
    element: "#account_actions",
    placement: "bottom",
    title: "Manage your account",
    content: "Some text"
  });
  old_citizen_home_tour.addStep({
    element: "#show_ideas",
    placement: "left",
    title: "Show ideas",
    content: "Some"
  });
  old_citizen_home_tour.addStep({
    element: "#add_idea",
    placement: "left",
    title: "Or add your own",
    content: "Some text"
  });
  old_citizen_home_tour.addStep({
    element: "#newsletter",
    placement: "left",
    title: "Subscribe",
    content: "Some text"
  });
  old_citizen_home_tour.addStep({
    element: "#ideas",
    placement: "top",
    title: "List of the last ideas",
    content: "Some text"
  });
  old_citizen_home_tour.start();
});