templateApp = angular.module("Template", ["ngResource"])

templateApp.factory "Template", ["$resource", ($resource) ->
  $resource("/templates/:id.json", {id: "@id"})
]

templateApp.controller 'TemplateCtrl', ['$scope', 'Template', ($scope, Template) ->
  $scope.templates = Template.query()

  $scope.addTemplate = ->
    template = Template.save($scope.newTemplate)
    $scope.templates.push(template)
    $scope.newTemplate = {}

  $scope.removeTemplate = (int) ->
    int.$remove()
    $scope.templates.splice($scope.templates.indexOf(int), 1)
]

templateApp.controller 'TemplateEditCtrl', ['$scope', '$window', 'Template', ($scope, $window, Template) ->
  $scope.template = Template.get({id: $(template_id)[0].value })
  $scope.templates = Template.query()
  $scope.editTemplate = (template) ->
    template = Template.save($scope.template)
    $scope.templates.push(template)
]

