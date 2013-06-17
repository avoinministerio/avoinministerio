$(document).ready(function(){
	$("tr:odd").addClass("odd");
	$("tr:even").addClass("even");
  
  $("input#conversation_recipients").tokenInput('/get_participants.json', 
    { theme: "facebook", 
      prePopulate: $('input#conversation_recipients').data('load'),
      onAdd: function (item) {
        $("input#token-input-conversation_recipients").hide();
      },
      onDelete: function (item) { 
        $("input#token-input-conversation_recipients").show();
      } 
    }); 
  
  //if added recipient -> block input field
  if ($("li.token-input-token-facebook").size() >= 1) {
    $("input#token-input-conversation_recipients").hide();
  }
});
