function add_tr(q){
    var selected_question = $.grep(gon.questions_all, function(e){ return e.id == q; });
    if (selected_question.length == 0) {
        return;
    }
    var found_question = $.grep(gon.questions, function(e){ return e.id == q;});
    if (found_question.length == 0) {
        gon.questions.push(selected_question[0]);
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

function index_of_element(array, id){
    for (i = 0; i < array.length; i++){
        if (array[i].id == id) {
            return i;
        }
    }
    return -1;
}

var callExecuter=function(){
    var templ_name = document.getElementById("template_name").value;
    if (templ_name.length > 0) {
        gon.template_edit.name = templ_name;
    }
    $.ajax({
        type:'POST',
        url:'/admin/templates/' + gon.template_edit.id,
        data: { id: gon.template_edit.id,
            template: gon.template_edit,
            questions: gon.questions
        }
    });
    delete gon;
};

var initTemplates=function(){
    if (typeof gon === 'undefined'){ return; }
    for (i = 0; i < gon.questions.length; i++){
        var q = gon.questions[i].id;
        add_tr(q);
    }
};


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
    var elementPos = index_of_element(gon.questions, q);
    if (elementPos > -1) {
        gon.questions.splice(elementPos, 1);
    }
};

$(document).on('page:change',initTemplates);
$(document).on('click',"#add-question-button",addQuestion);
$(document).on('click',".remove-question-button",removeQuestion);
$(document).on('click',"#btn-submit",callExecuter);