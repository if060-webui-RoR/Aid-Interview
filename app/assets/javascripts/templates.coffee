templateApp = angular.module("Template", ["ngResource"])

templateApp.factory "Template", ["$resource", ($resource) ->
  $resource("/templates/:id.json", {id: "@id"})
]

templateApp.filter 'getById', ->
  (input, id) ->
    i = 0
    len = input.length
    while i < len
      if +input[i].id == +id
        return input[i]
      i++
    null

templateApp.controller 'TemplateCtrl', ['$scope', '$window', 'Template', '$filter', ($scope, $window, Template, $filter) ->
  $scope.templates = Template.query()

  $scope.addTemplate = ->
    t_name = angular.element(document.querySelector('#name')).val()
    reg_exp = ///^\s*$///
    strT_name = String t_name
    if strT_name.match(reg_exp)
      alert "Name can't be blank"
      return
    found_template = $.grep($scope.templates, (e) ->
      e.name == t_name
    )
    if found_template.length == 1
      alert "This name already exist! " +
          "Please, enter another name."
      return
    q_ids = []
    i = undefined
    i = 0
    while i < $scope.TemplateQuestions.length
      q_ids.push($scope.TemplateQuestions[i].id)
      i++
    $scope.newTemplate.question_ids = q_ids
    template = Template.save($scope.newTemplate)
    $scope.templates.push(template)
    $scope.newTemplate = {}
    $window.location.href = '/templates'


  $scope.addQuest =  ->
    q = angular.element('#question_ids option:selected').val()
    if angular.element('#question_ids option:selected').text().length == 0
      alert 'Please, choose a question.'
      return
    f_question = $filter('getById')($scope.TopicQuestions, q)
    $scope.add_tr f_question

  $scope.add_tr = (q) ->
    table = angular.element(document.querySelector('#question_list'))
    tr = angular.element('<tr></tr>')
    tr.attr('id', "question-row-" + q.id)
    td_question = $('<td></td>').text(q.content)
    remove_button_id = "remove-question-button-" + q.id
    td_remove = angular.element('<td></td>').append("<button id=\"" + remove_button_id + "\"class=\"btn btn-info remove-question-button\" type=\"button\" name=\"button\">Remove</button>")
    angular.element("#question_ids option[value=" + q.id + "]").remove()
    row = tr.append(td_question, td_remove)
    table.append(row)
    found_question = $.grep($scope.TemplateQuestions, (e) ->
      e.id == q.id
    )
    if found_question.length == 0
      $scope.TemplateQuestions.push (q)
    return

  $scope.deleteQuest =  ->
    btn_id = (angular.element(this)).attr('id')
    q = btn_id.replace("remove-question-button-", "")
    angular.element(document.querySelector("#question-row-" + q)).remove()
    selected_question = $filter('getById')($scope.TemplateQuestions, q)
    elementPos = $scope.TemplateQuestions.indexOf(selected_question)
    if elementPos > -1
      $scope.TemplateQuestions.splice elementPos, 1
    if selected_question.length == 0
      return
    angular.element(document.querySelector('#question_ids')).append angular.element('<option>',
      value: q
      text: selected_question.content)
    return

  angular.element(document).on('click', ".remove-question-button", $scope.deleteQuest)

  $scope.removeTemplate = (int) ->
    int.$remove()
    $scope.templates.splice($scope.templates.indexOf(int), 1)

  $scope.changeTopic = () ->
    topicID = angular.element(document.querySelector('#topic_id')).val()
    $.get '/templates/' + topicID + '/topic/', (data, status) ->
      angular.element(document.querySelector('#question_ids')).find('option').remove().end
      i = 0
      while i < data.length
        found_question = $.grep($scope.TemplateQuestions, (e) ->
          e.id == data[i].id
        )
        if found_question.length > 0
          continue
        angular.element(document.querySelector('#question_ids')).append $('<option>',
          value: data[i].id
          text: data[i].content)
        i++
      $scope.TopicQuestions = data
    return
  return
]

templateApp.directive 'ngConfirmClick', [ ->
  { link: (scope, element, attr) ->
    msg = attr.ngConfirmClick or 'Are you sure?'
    clickAction = attr.confirmedClick
    element.bind 'click', (event) ->
      if window.confirm(msg)
        scope.$eval clickAction
      return
    return
  }
]

templateApp.directive 'ngCheckQuestions', [ ->
  { link: (scope, element, attrs) ->
    $.get '/templates/' + 0 + '/questions/', (data, status) ->
      scope.TemplateQuestions = data
  }
]

templateApp.directive 'ngGetQuestions', [ ->
  { link: (scope, element, attrs) ->
    templateID = angular.element(document.querySelector('#template_id')).val()
    $.get '/templates/' + templateID + '/questions/', (data, status) ->
      scope.TemplateQuestions = data
      i = 0
      while i < data.length
        scope.add_tr data[i]
        i++
      return
    return
  }
]

templateApp.controller 'TemplateEditCtrl', ['$scope', '$window', 'Template', '$filter', ($scope, $window, Template, $filter) ->
  $scope.template = Template.get({id: angular.element(document.querySelector('#template_id')).val() })
  $scope.templates = Template.query()

  $scope.addQuest =  ->
    q = angular.element('#question_ids option:selected').val()
    if angular.element('#question_ids option:selected').text().length == 0
      alert 'Please, choose a question.'
      return
    f_question = $filter('getById')($scope.TopicQuestions, q)
    $scope.add_tr f_question

  $scope.add_tr = (q) ->
    table = angular.element(document.querySelector('#question_list'))
    tr = angular.element('<tr></tr>')
    tr.attr('id', "question-row-" + q.id)
    td_question = angular.element('<td></td>').text(q.content)
    remove_button_id = "remove-question-button-" + q.id
    td_remove = angular.element('<td></td>').append("<button id=\"" + remove_button_id + "\"class=\"btn btn-info remove-question-button\" type=\"button\" name=\"button\">Remove</button>")
    angular.element("#question_ids option[value=" + q.id + "]").remove()
    row = tr.append(td_question, td_remove)
    table.append(row)
    found_question = $.grep($scope.TemplateQuestions, (e) ->
      e.id == q.id
    )
    if found_question.length == 0
      $scope.TemplateQuestions.push (q)
    return

  $scope.deleteQuest =  ->
    btn_id = (angular.element(this)).attr('id')
    q = btn_id.replace("remove-question-button-", "")
    angular.element(document.querySelector("#question-row-" + q)).remove()
    selected_question = $filter('getById')($scope.TemplateQuestions, q)
    elementPos = $scope.TemplateQuestions.indexOf(selected_question)
    if elementPos > -1
      $scope.TemplateQuestions.splice elementPos, 1
    if selected_question.length == 0
      return
    x = angular.element(document.querySelector('#question_ids')).append angular.element('<option>',
      value: q
      text: selected_question.content)
    return

  angular.element(document).on('click', ".remove-question-button", $scope.deleteQuest)

  $scope.editTemplate = (template) ->
    t_name = angular.element(document.querySelector('#name')).val()
    reg_exp = ///^\s*$///
    strT_name = String t_name
    if strT_name.match(reg_exp)
      alert "Name can't be blank"
      return
    found_template = $.grep($scope.templates, (e) ->
      e.name == t_name
    )
    if found_template.length == 0
      template = Template.save($scope.template)
      $scope.templates.push(template)
      $window.location.href = '/templates'
    if found_template.length == 1
      t_id = String angular.element(document.querySelector('#template_id')).val()
      found_t_id = String found_template[0].id
      if t_id isnt found_t_id or found_template.length > 1
        alert "This name already exist! " +
            "Please, enter another name."
        return
      else
        q_ids = []
        i = undefined
        i = 0
        while i < $scope.TemplateQuestions.length
          q_ids.push($scope.TemplateQuestions[i].id)
          i++
        $scope.template.question_ids = q_ids
        template = Template.save($scope.template)
        $scope.templates.push(template)
        $window.location.href = '/templates'

  $scope.changeTopic = () ->
    topicID = angular.element(document.querySelector('#topic_id')).val()
    $.get '/templates/' + topicID + '/topic/', (data, status) ->
      angular.element(document.querySelector('#question_ids')).find('option').remove().end
      i = 0
      while i < data.length
        angular.element(document.querySelector('#question_ids')).append $('<option>',
          value: data[i].id
          text: data[i].content)
        i++
      $scope.TopicQuestions = data
    return
  return
]
