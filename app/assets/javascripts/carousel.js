$(document).ready(function() {
  $("#proposals_carousel").carouFredSel({
    items: 3,
    scroll: 3,
    circular: false,
    auto: false,
    infinite: false,
    prev: {
        button: "#proposals_carousel_prev",
        key: "left"
      },
    next: {
      button: "#proposals_carousel_next",
      key: "right"
    }
  });
});
