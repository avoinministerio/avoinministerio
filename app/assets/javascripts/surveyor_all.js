//= require surveyor/jquery.tools.min
//= require surveyor/jquery-ui
//= require surveyor/jquery-ui-timepicker-addon
//= require surveyor/jquery.surveyor
//= require surveyor/jquery.selectToUISlider
//

$(document).ready(function(){

  var answered_mendatory = function(){
    for (var i = 1; i <= 13; i++){
      if ($("input[name='r[" + i + "][answer_id]']") != null){
        if ($("input[name='r[" + i + "][answer_id]']").val() != ""){
          return false;
        }
      }
    }
    return true;
  };

  var toggleButton = function() {
    if(  answered_mendatory() ) {
      $("input[type='submit']").attr({"disabled": false, "class": "accept-btn"});
    } else {
      $("input[type='submit']").attr({"disabled": true, "class": "accept-btn-disabled"});
    }
  };

  for (var i = 1; i <= 13; i++){
    if ($("input[name='r[" + i + "][answer_id]']") != null){
      $("input[name='r[" + i + "][answer_id]']").change(toggleButton);
    }
  }
});
