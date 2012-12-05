$(document).ready(function () {
    var fb_icon = '<img src="http://www.icopartners.com//images/facebook_icon.gif" />';

    if ($('body#pages-home').exists()) {
        window.homeTour = new Tour({
            name:"homeTour",
            show_now: true,
            afterGetState:function (key, value) {
            },
            afterSetState:function (key, value) {
            },
            onShow:function (tour) {
            },
            onHide:function (tour) {
            }
        });
        homeTour.addStep({
            element:"#logo",
            title:"Welcome to Avoin Ministerio ",
            content:"This is tour that will help you find one's feet",
            placement:'bottom'
        });

        homeTour.addStep({
            element:"a[href$='facebook']",
            title:"Facebook <small>info</small>",
            content:fb_icon + "You can login through your Facebook account. This is fast and secure.",
            placement:'bottom'
        });

        homeTour.addStep({
            element:".top_drafts .alpha:first",
            title:"The ideas",
            content:"Help us to create new ideas",
            placement:'bottom'
        });

       //  homeTour._options.show_now ? homeTour.start() : '' ;
    } // end homeTour

    if ($('body#ideas-show').exists()) {

        window.ideaTour = new Tour({
            name:"ideaTour",
            afterGetState:function (key, value) {
            },
            afterSetState:function (key, value) {
            },
            onShow:function (tour) {
            },
            onHide:function (tour) {
            }
        });

        ideaTour.addStep({
            element:"a[href$='facebook']",
            title:"Facebook <small>info</small>",
            content:fb_icon + "You can login through your Facebook account. This is fast and secure.",
            placement:'bottom'
        });
        ideaTour.addStep({
            element:"a.jaa-btn",
            title:"The ideas <small>info</small>",
            content:"Share your opinion",
            placement:'bottom'
        });

        ideaTour.start();
    } // end ideaTour
})