$(function(){
  var home_guide = new Tour();
    home_guide.addStep({
      element: "#facebook_join",
      placement: "bottom",
      title: "Join via facebook",
      content: "Register with you facebook profile and share you ideas for better law with our commmunity"
    });
    home_guide.addStep({
      element: "#new_idea",
      placement: "bottom",
      title: "Share you idea",
      content: "Click and create new idea for better law"
    });
    home_guide.start();
});
