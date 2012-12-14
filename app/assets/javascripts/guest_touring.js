$(document).ready(function() {
  if(document.getElementById('idea_state') != undefined) {
    var guest_idea_tour = new Tour({
      name: "guest_idea_tour"});
    guest_idea_tour.addStep({
      element: "#logo",
      placement: "bottom",
      title: "Welcome to Avoin ministerio",
      content: "Some text"
    });
    guest_idea_tour.addStep({
      element: "#sign_in_via_facebook",
      placement: "bottom",
      title: "Sign in via facebook",
      content: "Some text"
    });
    guest_idea_tour.addStep({
      element: "#sign_up",
      placement: "bottom",
      title: "Or sign up",
      content: "Some text"
    });
    guest_idea_tour.addStep({
      element: "#idea_state",
      placement: "top",
      title: "Current state of the idea",
      content: "Some text"
    });
    guest_idea_tour.addStep({
      element: "#voting",
      placement: "left",
      title: "Voting",
      content: "Some text"
    });
    guest_idea_tour.addStep({
      element: "#add_comment",
      placement: "top",
      title: "Leave a comment",
      content: "Some text"
    });
    guest_idea_tour.start();

    if (guest_idea_tour.ended()) {
      $('<div class="alert fade in" ><button class="close" data-dismiss="alert">×</button>You ended the tour. <a href="" class="restart">Restart the tour here.</a></div>').prependTo("#idea_state");
    }

    $("a.restart").click(function (e) {
      e.preventDefault();
      guest_idea_tour.restart();
      $(this).parents(".alert").alert("close");
    });
  }
  else {
    var guest_home_tour = new Tour({
      name: "guest_home_tour"});
    guest_home_tour.addStep({
      element: "#logo",
      placement: "bottom",
      title: "Welcome to Avoin ministerio",
      content: "Some text"
    });
    guest_home_tour.addStep({
      path:'/',
      element: "#sign_in_via_facebook",
      placement: "bottom",
      title: "Sign in via facebook",
      content: "Some text"
    });
    guest_home_tour.addStep({
      path:'/',
      element: "#sign_up",
      placement: "bottom",
      title: "Or sign up",
      content: "Some text"
    });
    guest_home_tour.addStep({
      element: "#show_ideas",
      placement: "left",
      title: "Show ideas",
      content: "Some"
    });
    guest_home_tour.addStep({
      element: "#add_idea",
      placement: "left",
      title: "Or add your own",
      content: "Some text"
    });
    guest_home_tour.addStep({
      element: "#newsletter",
      placement: "left",
      title: "Subscribe",
      content: "Some text"
    });
    guest_home_tour.addStep({
      element: "#ideas",
      placement: "top",
      title: "List of the last ideas",
      content: "Some text"
    });
    guest_home_tour.start();

    if (guest_home_tour.ended()) {
      $('<div class="alert fade in" ><button class="close" data-dismiss="alert">×</button>You ended the tour. <a href="" class="restart">Restart the tour here.</a></div>').prependTo("#logo");
    }

    $("a.restart").click(function (e) {
      e.preventDefault();
      guest_home_tour.restart();
      $(this).parents(".alert").alert("close");
    });
  };
});