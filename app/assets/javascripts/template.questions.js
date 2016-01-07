(function() {
    var TemplateQuestions;
    var TopicQuestions;
    var TemplateID;
    var TemplateName;
    var AllTemplates;

    function add_tr(q) {
        var table = $('#question_list');
        var tr = $('<tr></tr>');
        tr.attr('id', "question-row-" + q.id);
        var td_question = $('<td></td>').text(q.content);
        var remove_button_id = "remove-question-button-" + q.id;
        var td_remove = $('<td></td>').append("<button id=\"" + remove_button_id + "\"class=\"btn btn-info remove-question-button\" type=\"button\" name=\"button\">Remove</button>");
        $("#question_id option[value=" + q.id + "]").remove();
        var row = tr.append(td_question, td_remove);
        table.append(row);
        var found_question = $.grep(TemplateQuestions, function (e) {
            return e.id == q.id
        });
        if (found_question.length == 0) {
            TemplateQuestions.push(q);
        }
    }

    var callExecuter = function () {
        templates_errors();
        var templ_name = $("#template_name").val();
        if (templ_name.length == 0) {
            templ_name = TemplateName;
        }
        $.ajax({
            type: 'POST',
            url: '/templates/' + TemplateID,
            data: {
                id: TemplateID,
                name: templ_name,
                questions: TemplateQuestions
            }
        });
        delete TemplateQuestions;
        delete TopicQuestions;
        delete TemplateID;
        delete TemplateName;
    };

    function templates_errors() {
        if ($("#template_name").val().length == 0) {
            alert("Name can't be blank!");
            return false;
        };
        $.get('/all_templates/', function (data, status) {
            AllTemplates = data;
        var t_name = $("#template_name").val();
        var found_template = $.grep(AllTemplates, function (e) { return e.name == t_name; });
            if (found_template.length == 1) {
                if (found_template[0].id != $("#template_id").val()){
                    alert("This name already exist! " +
                        "Please, enter another name. ");
                    return false;
                };
            };
            if (found_template.length > 1) {
                alert("This name already exist! " +
                    "Please, enter another name. ");
                return false;
            };
        });
    };

    var initTemplates = function () {
        if ($('#template_id').length == 0) {
            return;
        }
        TemplateID = $("#template_id").val();
        TemplateName = $("#template_name").val();
        $.get("/templates/" + TemplateID + "/questions/", function (data, status) {
            TemplateQuestions = data;
            for (i = 0; i < data.length; i++) {
                add_tr(data[i]);
            }
            getQuestionsByTopic();
        });
    };

    function randomQuestion() {
        var random_q = Math.floor((Math.random() * TopicQuestions.length));
        $('select[id=question_id]').val = TopicQuestions[random_q].id;
        addQuestion();
    }

    function addQuestion() {
        var q = $('select[id=question_id]').val();
        var found_question = $.grep(TopicQuestions, function (e) {
            return e.id == q;
        });
        add_tr(found_question[0]);
    };

    var removeQuestion = function () {
        var btn_id = ($(this).attr('id'));
        var q = btn_id.replace("remove-question-button-", "");
        $("#question-row-" + q).remove();
        var selected_question = $.grep(TemplateQuestions, function (e) {
            return e.id == q
        });
        var elementPos = TemplateQuestions.indexOf(selected_question[0]);
        if (elementPos > -1) {
            TemplateQuestions.splice(elementPos, 1);
        }
        if (selected_question.length == 0) {
            return;
        }
        $('#question_id').append($('<option>', {value: q, text: selected_question[0].content}));
    };

    function getQuestionsByTopic() {
        var topicID = $('select[id=topic_id]').val();
        $.get("/templates/" + topicID + "/topic/", function (data, status) {
            $('#question_id')
                .find('option')
                .remove()
                .end();
            for (i = 0; i < data.length; i++) {
                var found_question = $.grep(TemplateQuestions, function (e) {
                    return e.id == data[i].id;
                });
                if (found_question.length > 0) {
                    continue;
                }
                $('#question_id').append($('<option>', {value: data[i].id, text: data[i].content}));
            }
            TopicQuestions = data;
        });
    }

    $(document).on('page:change', initTemplates);
    $(document).on('click', "#add-question-button", addQuestion);
    $(document).on('click', ".remove-question-button", removeQuestion);
    $(document).on('click', "#btn-submit", callExecuter);
    $(document).on('click', "#randomQuestion", randomQuestion);
    $(document).on('change', "#topic_id", getQuestionsByTopic);
})();