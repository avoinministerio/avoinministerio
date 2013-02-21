$(document).ready(function($) {
  $('input#idea_suggested_politicians_for').tokenInput("/citizens/list_of_politicians.json", { theme: "facebook" });
  $('input#idea_suggested_politicians_against').tokenInput("/citizens/list_of_politicians.json", { theme: "facebook" });

});