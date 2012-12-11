$(function(){
  var idea_guide = new Tour({
    name: 'idea_tour'
  });
    idea_guide.addStep({
      element: "#idea_body",
      placement: "top",
      title: "share your opinion",
      content: "Read the idea description below and share your opinion. Did you like this idea ?",
      options: {
        labels: {prev: "Next >>", next: "how to share my opinion?", end: "End Tour"}
      }
    });
    idea_guide.addStep({
      element: "#voting_part",
      placement: "top",
      title: "Share you opinion",
      content: "Vote for or against this idea"
    });
    idea_guide.start();
});
