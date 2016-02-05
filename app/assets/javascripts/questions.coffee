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

questionApp.service 'pagService', [
    '$http'
    ($http) ->

      questions = (page) ->
        $http.get 'questions.json', params: {page: page}

      { questions: questions }
  ]

questionApp.directive 'myPagination', ->
  {
    restrict: 'E'
    scope:
      from: '='
      to: '='
      total: '='
      currentPage: '='
      action: '&'
    controller: [
      '$scope'
      ($scope) ->

        $scope.previousPage = ->
          $scope.currentPage -= 1
          $scope.action page: $scope.currentPage
          return

        $scope.nextPage = ->
          $scope.currentPage += 1
          $scope.action page: $scope.currentPage
          return

        return
    ]
    templateUrl: 'paginationElements.html'
  }

questionApp.controller 'QuestionCtrl', [
  '$scope'
  'Question'
  '$window'
  '$http'
  ($scope, Question, $window, $http) ->
    $scope.sortType = 'content'
    $scope.sortReverse = false
    $scope.searchQuestion = ''

    $http.get('topics.json').then (res) ->
      $scope.topics = res.data
    
    $scope.addQuestion = ->
      Question.save($scope.question, -> 
        $window.location.href = '/admin/questions')

    $scope.removeQuestion = (question) ->
      if confirm("Are you sure?")
        question.$remove($window.location.href = '/admin/questions')
]

questionApp.controller 'PaginCtrl', [
  '$scope'
  'pagService'
  ($scope, pagService) ->
    $scope.getQuestions = (page) ->
          pagService.questions(page).then (response) ->
            $scope.questions = response.data.questions
            $scope.from_index = response.data.from_index
            $scope.to_index = response.data.to_index
            $scope.total_entries = response.data.total_entries
            $scope.current_page = parseInt(response.data.current_page)
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