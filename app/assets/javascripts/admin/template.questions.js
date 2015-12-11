function add_tr(q){
    var selected_question = $.grep(gon.questions_all, function(e){ return e.id == q; });
    if (selected_question.length == 0) {
        return;
    }
    var found_question = $.grep(gon.questions, function(e){ return e.id == q;});
    if (found_question.length == 0) {
        gon.questions.push(selected_question);
    }
    var tr = document.getElementById("question_list").insertRow(-1);
    tr.id = "question-row-" + q;
    var tdc = tr.insertCell(0);
    var tdd = tr.insertCell(1);
    tdc.className = "name";
    tdd.className = "del";
    tdc.innerHTML = selected_question[0].content;
    var remove_button_id = "remove-question-button-" + q;
    tdd.innerHTML = "<button id=\"" + remove_button_id + "\"class=\"btn btn-info remove-question-button\" type=\"button\" name=\"button\">Remove</button>";
    $("#question_id option[value="+q+"]").remove();
}

$(document).ready(function(){
    for (i = 0; i < gon.questions.length; i++){
        var q = gon.questions[i].id;
        add_tr(q);
    }
});


var addQuestion=function(){
    var select = document.getElementById("question_id");
    var q = select.value;
    add_tr(q);
};

var removeQuestion=function(){
    var btn_id = ($(this).attr('id'));
    var q = btn_id.replace("remove-question-button-", "");
    var row = document.getElementById("question-row-" + q);
    row.parentNode.removeChild(row);
    var select = document.getElementById("question_id");
    var option = document.createElement("option");
    option.value = q;
    var selected_question = $.grep(gon.questions_all, function(e){ return e.id == q; });
    if (selected_question.length == 0) {
        return;
    }
    option.text = selected_question[0].content;
    select.add(option);
};

$(document).on('click',"#add-question-button",addQuestion);
$(document).on('click',".remove-question-button",removeQuestion);