
jQuery(function($) {
  var tour = new Tour();
  tour.addStep({
    element: "#overview",
    placement: "bottom",
    title: "Welcome to Bootstrap Tour!",
    content: "Introduce new users to your product by walking them "
    + "through it step by step. Built on the awesome "
    + "<a href='http://twitter.github.com/bootstrap' target='_blank'>"
    + "Bootstrap from Twitter.<\/a>"
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
