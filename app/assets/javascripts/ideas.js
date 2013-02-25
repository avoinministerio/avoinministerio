$(document).ready(function($){
    $('input#idea_suggested_politicians_for').tokenInput("/citizens/list_of_politicians.json", {
        theme: "facebook"
    });

    $('input#idea_suggested_politicians_against').tokenInput("/citizens/list_of_politicians.json", {
        theme: "facebook"
    });

    $("#change-state").change(function(){
        var ideaId, newStateId;
        if (confirm('Do you really want to change state of this idea?')) {
            $(this).css({cursor: 'wait'});
            var ideaId = $("#idea-id").val();
            var newStateId = $(this).val();

            $.ajax({
                url: "/ideas/change_state",
                data: "id=" + ideaId + "&new_state_id=" + newStateId,
                success: function(data){
                    if (data.error === 1) {
                        $("#response-msg").attr('style', 'color: red;');
                        $('#change-state').val(data.old_value);
                    }
                    else {
                        $("#response-msg").attr('style', 'color: green;');
                    }
                    $("#response-msg").html(data.message);
                    $('#change-state').attr('style', 'cursor: pointer');
                }
            });
        }
    });
});
