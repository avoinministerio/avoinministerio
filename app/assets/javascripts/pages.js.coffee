jQuery ->
  $(window).scroll ->
    if $("#loading-more-ideas").is(":visible") and $(window).scrollTop() > ($(document).height() - $(window).height() - 80)
      if $(".pagination").length
        url = $(".pagination .next_page").attr("href")
        if url
          $(".pagination").text ""
          $.getScript url
      else
        $("#loading-more-ideas").remove()

  $(window).scroll()
