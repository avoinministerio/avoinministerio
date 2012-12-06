
$(function(){
  var tour = new Tour();
  tour.addStep({
    element: "#id_fb",
    placement: "bottom",
    title: "Welcome to AVOIN MINISTERIO",
    content: "Introduction"
  });
  tour.addStep({
    element: "#id_login",
    placement: "bottom",
    title: "Setup in four easy steps",
    content: "Easy is better, right?",
    options: {
      labels: {prev: "Go back", next: "Next", end: "Stop"}
    }
  });
  tour.addStep({
    element: "#id_register",
    placement: "bottom",
    title: "Setup in four easy steps",
    content: "Easy is better, right?",
    options: {
      labels: {prev: "Go back", next: "Next", end: "Stop"}
    }
  });
  tour.addStep({
    element: "#id_list_all",
    placement: "bottom",
    title: "Setup in four easy steps",
    content: "Easy is better, right?",
    options: {
      labels: {prev: "Go back", next: "Next", end: "Stop"}
    }
  });
  tour.addStep({
    element: "#enter_idea_id",
    placement: "bottom",
    title: "Setup in four easy steps",
    content: "Easy is better, right?",
    options: {
      labels: {prev: "Go back", next: "Next", end: "Stop"}
    }
  });
  tour.addStep({
    element: "#header_id",
    placement: "left",
    title: "Setup in four easy steps",
    content: "Easy is better, right?",
    options: {
      labels: {prev: "Go back", next: "Next", end: "Stop"}
    }
  });
  
  tour.start();
});


