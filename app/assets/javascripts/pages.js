function mycarousel_initCallback(carousel) {
    jQuery('.control a').bind('click', function() {
        carousel.scroll(jQuery.jcarousel.intval(jQuery(this).text()));
        return false;
    });

    jQuery('.jcarousel-scroll select').bind('change', function() {
        carousel.options.scroll = jQuery.jcarousel.intval(this.options[this.selectedIndex].value);
        return false;
    });

    jQuery('.jcarousel-next').bind('click', function() {
        carousel.next();
        return false;
    });

    jQuery('.jcarousel-prev').bind('click', function() {
        carousel.prev();
        return false;
    });
};

// Ride the carousel...
jQuery(document).ready(function() {
    jQuery("#mycarousel").jcarousel({
        wrap: 'circular',
        scroll: 3,
        //start: 1,
        //auto: 1,
        initCallback: mycarousel_initCallback,
        // This tells jCarousel NOT to autobuild prev/next buttons
        //buttonNextHTML: null,
        //buttonPrevHTML: null
    });
});

jQuery(document).ready(function() {
    jQuery("#mycarousel_2").jcarousel({
        wrap: 'circular',
        scroll: 3,
        //auto: 1,
        //start: 1,
        initCallback: mycarousel_initCallback,
        // This tells jCarousel NOT to autobuild prev/next buttons
        buttonNextHTML: null,
        buttonPrevHTML: null
    });
});