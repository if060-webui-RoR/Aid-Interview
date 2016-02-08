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
            controller: 'QuestionNewCtrl')
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
      currentPage: '='
      totalPages: '='
      action: '&'
    controller: [
      '$scope'
      ($scope) ->
        $scope.rangeSize = 5
        $scope.range = (size, start, end) ->
          if size < $scope.rangeSize
            $scope.rangeSize = size
          ret = []
          if start <= ($scope.rangeSize)
            start = 1
          else
            end = size
            start = size - ($scope.rangeSize)
          i = start
          while i <= end
            ret.push i
            i++
          ret

        $scope.previousPage = ->
          if $scope.currentPage > 1
            $scope.currentPage -= 1
            $scope.action page: $scope.currentPage

        $scope.nextPage = ->
          if $scope.currentPage < $scope.totalPages
            $scope.currentPage += 1
            $scope.action page: $scope.currentPage

        $scope.setPage = ->
          $scope.currentPage = this.pageNumber
          $scope.action page: $scope.currentPage
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

    $scope.removeQuestion = (question) ->
      if confirm("Are you sure?")
        Question.remove(question).$promise.then($window.location.href = '/admin/questions')
]

questionApp.controller 'PaginCtrl', [
  '$scope'
  'pagService'
  ($scope, pagService) ->
    $scope.getQuestions = (page) ->
      pagService.questions(page).then (response) ->
        $scope.questions = response.data.questions
        $scope.current_page = parseInt(response.data.current_page)
        $scope.total_pages = response.data.total_pages
]

questionApp.controller 'QuestionNewCtrl', [
  '$scope'
  'Question'
  '$window'
  '$http'
  ($scope, Question, $window, $http) ->
    $http.get('topics.json').then (res) ->
      $scope.topics = res.data
    $scope.addQuestion = ->
      Question.save($scope.question, ->
        $window.location.href = '/admin/questions')
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