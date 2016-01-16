templateApp = angular.module('templateApp',[
  'controllers',
  'ui.bootstrap',
  'angularUtils.directives.dirPagination'
])

controllers = angular.module('controllers',[])

controllers.controller("TemplateIndexController", [
  '$scope'
  '$http'
  'TemplateService'
  ($scope, $http, TemplateService) ->
    $scope.templatesOnPage = 8
    $scope.order = true

    $http.get('templates.json').then (res) ->
      $scope.templates = res.data

    $scope.orderByMe = (param, order) ->
      $scope.myOrderBy = param
      $scope.order = order
    return
])

controllers.controller('TemplateNewController', ($scope, TemplateService) ->

  $scope.AddTemplate = ->
    TemplateService.AddTemplateToDB $scope.template
  $scope.template

).factory 'TemplateService', [
  '$http'
  '$window'
  ($http, $window) ->
    obj = {}
    obj.AddTemplateToDB = (template) ->
      $http.post('/templates', template)
      .success (response) ->
        $window.location.href = 'index.html';
      .error (response) ->
        alert "Template already exist!"
    obj
]
