$(document).ready(function() {
 $("#proposals_list").after('<ul id="proposals_listX" />').next().html($("#proposals_list").html());
 $("#proposals_list li:odd").remove();
 $("#proposals_listX li:even").remove();

 $("#proposals_list").carouFredSel({
 	synchronise: "#proposals_listX",
	circular: false,
	infinite: false,
	auto: false,
	prev: {	
		button: "#proposals_list_prev",
		key: "left"
	},
	next: { 
		button: "#proposals_list_next",
		key: "right"
	},
	pagination: "#proposals_list_pag" });

  $("#proposals_listX").carouFredSel({
	  auto: false });

  $("#drafts_list").carouFredSel({
  circular: false,
  infinite: false,
  auto  : false,
  prev  : { 
    button  : "#drafts_list_prev",
    key   : "left"
  },
  next  : { 
    button  : "#drafts_list_next",
    key   : "right"
  },
  pagination  : "#drafts_list_pag" });

  $("low_limit_proposals_list").carouFredSel();
});