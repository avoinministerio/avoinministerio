//= require surveyor/jquery.tools.min
//= require surveyor/jquery-ui
//= require surveyor/jquery-ui-timepicker-addon
//= require surveyor/jquery.surveyor
//= require surveyor/jquery.selectToUISlider
//

$(document).ready(function(){

  function unanswered_question(questions){
    for (var i in questions){
      if (($(questions[i]).is('input') && $(questions[i] + ":checked").val() == undefined ) ||
          $(questions[i]).attr('changed') == 'false'
         )
      {
        return questions[i];
      }
    }
    return null;
  }

  var toggleButton = function() {
    var unanswered_mandatory_question = unanswered_question(mandatory_questions);
    console.log(unanswered_mandatory_question);
    if( unanswered_mandatory_question == null ) {
      $("input[name='finish']").attr({"disabled": false, "class": "finish-btn"});
      $(".unanswered-link").remove();
    } else {
      $("input[name='finish']").attr({"disabled": true, "class": "finish-btn-disabled"});
      if($(".unanswered-link").length == 0){
        $("input[name='finish']").parent().parent().append('<button class="unanswered-link">Et ole vielä vastannut kaikkiin vaadittuihin kysymyksiin.</button>');
        //Du har fortfarande inte besvarat alla obligatoriska frågor.

      }
      var scrollToUnansweredQuestion = function(){
        $(unanswered_mandatory_question)[0].scrollIntoView();
        return false;
      };
      $(".unanswered-link").click(scrollToUnansweredQuestion);
    }
  };

  var question_numbers = [];
  var mandatory_questions = new Array(question_numbers.length);
  for (var i in question_numbers){
    mandatory_questions[i] = "[name='r[" + question_numbers[i] + "][answer_id]']";
    $(mandatory_questions[i]).change(toggleButton);
    if (i >= 9 && i <= 12){
      //Disabling Sliders
      $(mandatory_questions[i]).attr('changed','false');
      $("#handle_r_"+i+"_answer_id").focusin(function(){
        var id =$(this).attr('id');
        var v = id[9];
        var v2 = ""
        if (id[10] != '_'){
          v2 = id[10]
        }
        $(mandatory_questions[v+v2]).attr('changed','true');
        toggleButton();
      });
    }
  }
  toggleButton();

});
