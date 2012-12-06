$(document).ready(function () {
    var fb_icon = '<img src="http://www.icopartners.com//images/facebook_icon.gif" />';

    if ($('body#pages-home, body#ideas-index').exists()) {
        window.homeTour = new Tour({
            name:"homeTour",

            afterGetState:function (key, value) {
            },
            afterSetState:function (key, value) {
                if (key == "end" && value == "yes") {
                    restartTour();
                    $.post('/citizens/tour', {tour_name:'homeTour', authenticity_token:AUTH_TOKEN});
                }
            },
            onShow:function (tour) {
            },
            onHide:function (tour) {
            }
        });
        homeTour.addStep({
            path:'/',
            element:"#logo",
            title:"Welcome to Avoin Ministerio ",
            content:"This is tour that will help you find one's feet",
            placement:'bottom'
        });

        homeTour.addStep({
            path:'/',
            element:"a[href$='facebook']",
            title:"Facebook <small>info</small>",
            content:fb_icon + "You can login through your Facebook account. This is fast and secure.",
            placement:'bottom',
            options:{
                labels:{prev:"Prev", next:"Next page Idas", end:"Stop"}
            }
        });
        homeTour.addStep({
            path:'/ideat',
            element:".info:first h2",
            title:"The ideas <small>info</small>",
            content:"You can login through your Facebook account. This is fast and secure.",
            placement:'bottom'
        });
        homeTour.addStep({
            path:'/ideat',
            element:".comment-count:first",
            title:"The ideas <small>info</small>",
            content:"How many comments we have for this idea.",
            placement:'bottom'
        });

        homeTour.addStep({
            path:'/',
            element:".top_drafts .alpha:first",
            title:"The ideas",
            content:"Help us to create new ideas",
            placement:'bottom'
        });
        homeTour.start();

        if (homeTour.ended()) {
            $('<div class="alert fade in" >\
            <button class="close" data-dismiss="alert">×</button>\
            You ended the tour. <a href="" class="restart">Restart the tour here.</a>\
            </div>').prependTo(".top_drafts:first");
        }

        $("a.restart").click(function (e) {
            e.preventDefault();
            window.homeTour.restart();
            $(this).parents(".alert").alert("close");
        });

    } // end homeTour

    if ($('body#ideas-show').exists()) {

        window.ideaTour = new Tour({
            name:"ideaTour",
            afterGetState:function (key, value) {
            },
            afterSetState:function (key, value) {
                if (key == "end" && value == "yes") {
                    $.post('/citizens/tour', {tour_name:'ideaTour', authenticity_token:AUTH_TOKEN});
                }
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