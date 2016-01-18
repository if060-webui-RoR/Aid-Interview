# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

questionApp = angular.module("QuestionApp", [
      'ui.bootstrap'
      'angularUtils.directives.dirPagination'
      'ngResource'
      'ngRoute'
      'templates'
]).config [ 
      '$routeProvider'
      ($routeProvider) ->

        $routeProvider
          .when('/',
            templateUrl: 'questions/index.html'
            controller: 'QuestionCtrl')
          .when('/new',
            templateUrl: 'questions/new.html'
            controller: 'QuestionCtrl')
          .when('/:id',
            templateUrl: 'questions/show.html'
            controller: 'QuestionShowCtrl')
          .when('/:id/edit',
            templateUrl: 'questions/edit.html'
            controller: 'QuestionEditCtrl')
]

questionApp.factory 'Question', [
  '$resource'
  ($resource) ->
    $resource '/admin/questions/:id.json', id: "@id",
      query:
        method: 'GET'
        isArray: true
      update:
        method: 'PATCH'
]

questionApp.controller 'QuestionCtrl', [
  '$scope'
  'Question'
  '$routeParams'
  '$window'
  '$http'
  ($scope, Question, $routeParams, $window, $http) ->

    $scope.questions = Question.query()
    $scope.questionsOnPage = 10

    $http.get('topics.json').then (res) ->
      $scope.topics = res.data
    
    $scope.addQuestion = ->
      Question.save($scope.question, -> 
        $window.location.href = '/admin/questions')

    $scope.removeQuestion = (question) ->
      if confirm("Are you sure?")
        question.$remove($window.location.href = '/admin/questions')

    $scope.sortType = 'content'
    $scope.sortReverse = false
    $scope.searchQuestion = ''

]

questionApp.controller 'QuestionShowCtrl', [
  '$scope'
  'Question'
  '$routeParams'
  '$window'
  ($scope, Question, $routeParams, $window) ->
    $scope.question = Question.get({id: $routeParams.id})

    $scope.removeQuestion = (question) ->
      if confirm("Are you sure?")
        question.$remove($window.location.href = '/admin/questions')

]

questionApp.controller 'QuestionEditCtrl', [
  '$scope'
  'Question'
  '$routeParams'
  '$window'
  '$http'
  ($scope, Question, $routeParams, $window, $http) ->
    $scope.question = Question.get({id: $routeParams.id})
    $http.get('topics.json').then (res) ->
      $scope.topics = res.data

    $scope.editQuestion = (question) ->
      Question.update({id: $routeParams.id}, question)
      .$promise.then($window.location.href = '/admin/questions')
]