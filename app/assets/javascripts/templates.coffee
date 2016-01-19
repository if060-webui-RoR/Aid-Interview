templateApp = angular.module("Template", ["ngResource"])

templateApp.factory "Template", ["$resource", ($resource) ->
  $resource("/templates/:id.json", {id: "@id"})
]

templateApp.controller 'TemplateCtrl', ['$scope', '$window', 'Template', ($scope, $window, Template) ->
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
    template = Template.save($scope.newTemplate)
    $scope.templates.push(template)
    $scope.newTemplate = {}
    $window.location.href = '/templates'

  $scope.removeTemplate = (int) ->
    int.$remove()
    $scope.templates.splice($scope.templates.indexOf(int), 1)
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

templateApp.controller 'TemplateEditCtrl', ['$scope', '$window', 'Template', ($scope, $window, Template) ->
  $scope.template = Template.get({id: angular.element(document.querySelector('#template_id')).val() })
  $scope.templates = Template.query()
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
        template = Template.save($scope.template)
        $scope.templates.push(template)
        $window.location.href = '/templates'
]
