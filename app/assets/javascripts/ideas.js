var tags = []
var suggested_tag = []

$(document).ready(function($) {
  
  var idea_title = $('input#idea_title');
  var idea_summary = $('textarea#idea_summary');
  var idea_body = $('textarea#idea_body');
  var idea_id = $('input#idea_id');

  $('input#idea_tag_list').tokenInput("/tags.json", 
    { theme: "facebook", 
      prePopulate: $('input#idea_tag_list').data('load'),
      onAdd: function (item) {
        tags.push(item.name);
        send_data(idea_title.val(), idea_summary.val(), idea_body.val(), idea_id.val());
      },
      onDelete: function (item) {
        tags.splice(tags.indexOf(item.name), 1 );
        send_data(idea_title.val(), idea_summary.val(), idea_body.val(), idea_id.val());
      } 
    });

  $('.response').hide();
 
  idea_title.focus();
  
  idea_title.keyup(function() {
    send_data(idea_title.val(), idea_summary.val(), idea_body.val(), idea_id.val());
  });

  idea_summary.keyup(function() {
    send_data(idea_title.val(), idea_summary.val(), idea_body.val(), idea_id.val());
  });

  idea_body.keyup(function() {
    send_data(idea_title.val(), idea_summary.val(), idea_body.val(), idea_id.val());
  });
})

function send_data(title_text, summary_text, body_text, idea_id) {
  $.ajax({
    type:'POST',
    beforeSend: function(xhr) {
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    },
    url: '../ideas/lda?title_text=' + title_text + '&summary_text=' + summary_text + '&body_text=' + body_text + '&tags=' + tags + '&idea_id=' + idea_id ,
    success:function(data){
      //
    }
  });
}