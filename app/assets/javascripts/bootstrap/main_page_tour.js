
jQuery(function($) {
  var tour = new Tour();
  
  tour.addStep({
    element: "#facebook_login",
    placement: "bottom",
    title: "Welcome to Avoin Ministerio!",
    content: "By clicking on this link you will  "
    + "logged in to the site using your Facebook account "
    + "without passing through site registration process"
    
  });
  tour.addStep({
    element: "#site_login",
    placement: "bottom",
    title: "Site SignIn Link",
    content: "By clicking on this link you will  "
    + "logged in to the site using your Avoin Ministerio account credentials"
  });
  tour.addStep({
    element: "#site_registration",
    placement: "bottom",
    title: "Site SignUp Link",
    content: "By clicking on this link you will  "
    + "sign up or beacome a member of Avoin Ministerio"
  });
  
  tour.start();

  if ( tour.ended() ) {
    $('<div class="alert">\
      <button class="close" data-dismiss="alert">×</button>\
      You ended the demo tour. <a href="" class="restart">Restart the demo tour.</a>\
      </div>').prependTo(".content").alert();
  }

  $(".restart").click(function (e) {
    e.preventDefault();
    tour.restart();
    $(this).parents(".alert").alert("close");
  });
});
