
$(function(){
  var tour = new Tour();
  tour.addStep({
    element: "#header_image_id",
    placement: "bottom",
    title: "Welcome to AVOIN MINISTERIO",
    content: "Introduction"
  });
   tour.addStep({
    element: "#content_id",
    placement: "left",
    title: "Setup in four easy steps",
    content: "Easy is better, right?",
    options: {
      labels: {prev: "Go back", next: "Next", end: "Stop"}
    }
  });
  tour.addStep({
    element: "#yt_id",
    placement: "left",
    title: "Setup in four easy steps",
    content: "Easy is better, right?",
    options: {
      labels: {prev: "Go back", next: "Next", end: "Stop"}
    }
  });
 
  tour.addStep({
    element: "#votepie",
    placement: "left",
    title: "Setup in four easy steps",
    content: "Easy is better, right?",
    options: {
      labels: {prev: "Go back", next: "Next", end: "Stop"}
    }
  });
  tour.addStep({
    element: ".signature",
    placement: "left",
    title: "Setup in four easy steps",
    content: "Easy is better, right?",
    options: {
      labels: {prev: "Go back", next: "Next", end: "Stop"}
    }
  });
  tour.start();
});


