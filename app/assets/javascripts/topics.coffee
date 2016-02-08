topicApp = angular.module("topicApp", [
  'ui.bootstrap'
  'templates'
  'ngRoute'
  'angularUtils.directives.dirPagination'
  'ngResource'
  'naif.base64'
  'QuestionApp'
])

topicApp.factory "topicService", [
  "$resource"
  ($resource) ->
    $resource("/admin/topics/:id/:action.json", id: "@id", { 'update': {method: 'PATCH'} })
]

topicApp.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when('/',
        templateUrl: "topics/index.html"
        controller: 'topicCtrl'
      )
      .when('/new',
        templateUrl: "topics/new.html"
        controller: 'topicNewCtrl'
      )
      .when('/:id',
        templateUrl: "topics/show.html"
        controller: 'topicShowCtrl'
      )
      .when('/:id/edit',
        templateUrl: "topics/edit.html"
        controller: 'topicEditCtrl'
      )
])

topicApp.factory "AlertService", [
  '$window'
  ($window) ->
    message = false;

    getAlert = ->
      message

    setAlert = (type, text) ->
      message = {}
      message.type = type
      message.text = text
      setTimeout (->
        message = false
      ), 1000
      message

    return {
        setAlert: setAlert
        getAlert: getAlert
      }

]

topicApp.controller 'topicCtrl', [
  '$scope'
  'topicService'
  '$window'
  'AlertService'
  ($scope, topicService, $window, AlertService) ->
    $scope.topics = topicService.query()
    $scope.alert = AlertService.getAlert()
    $scope.topicsOnPage = 8
    $scope.order = true
    $scope.sortType = 'Newest' 

    $scope.orderByMe = (param, order, sortType) ->
      $scope.myOrderBy = param
      $scope.order = order
      $scope.sortType = sortType
      
]

topicApp.controller 'topicNewCtrl', [
  '$scope'
  'topicService'
  '$window'
  '$http'
  '$routeParams'
  'AlertService'
  ($scope, topicService, $window, $http, $routeParams, AlertService) ->
    $scope.alert = AlertService.getAlert()
    $scope.addTopic = ->
      topicService.save($scope.topic).$promise
      .then(
        (success) ->
          AlertService.setAlert('success', success.response)
          $window.location.href = '/admin/topics#/'
        (unsuccess) ->
          AlertService.setAlert('danger', unsuccess.data.error)
          $scope.alert = AlertService.getAlert()
      )
       
]

topicApp.controller 'topicShowCtrl', [
  '$scope'
  'topicService'
  '$window'
  '$http'
  '$routeParams'
  'AlertService'
  'Question'
  ($scope, topicService, $window, $http, $routeParams, AlertService, Question) ->
    $scope.questionsOnPage = 10
    $scope.alert = AlertService.getAlert()
    $scope.sortType = 'content'
    $scope.sortReverse = false
    $scope.searchQuestion = ''
    
    $scope.getTopicsQuestions = -> 
      topicService.get({id: $routeParams.id}).$promise
      .then(
        (success) ->
          $scope.topic = success.topic
          $scope.questions = success.questions
        (unsuccess) ->
          AlertService.setAlert('danger', unsuccess.data.error)
          $window.location.href = '/admin/topics#/'
      )

    $scope.getTopicsQuestions()

    $scope.removeTopic = (topic) ->
      if confirm("Are you sure?")
        topicService.remove(topic).$promise
        .then(
          (success) ->
            AlertService.setAlert('success', success.response)
            $window.location.href = '/admin/topics#/'
          (unsuccess) ->
            AlertService.setAlert('danger', unsuccess.data.error)
        )

    $scope.deleteQuestion = (question) ->
      if confirm("Are you sure?")
        Question.remove(question).$promise
        .then(
          (success) ->
            AlertService.setAlert('success', success.response)
            $scope.alert = AlertService.getAlert()
          (unsuccess) ->
            AlertService.setAlert('danger', unsuccess.data.error)
            $scope.alert = AlertService.getAlert()
        )
        $scope.getTopicsQuestions()
]

topicApp.controller 'topicEditCtrl', [
  '$scope'
  '$window'
  'topicService'
  '$http'
  '$routeParams'
  'AlertService' 
  ($scope, $window, topicService, $http, $routeParams, AlertService) ->
    $scope.alert = AlertService.getAlert()
    $scope.topic = topicService.get({id: $routeParams.id, action: 'edit'})
    $scope.editTopic = (updatedTopic) ->
      topicService.update({id: $scope.topic.id}, updatedTopic).$promise
      .then(
        (success) ->
          AlertService.setAlert('success', success.response)
          $window.location.href = '/admin/topics#/' + $scope.topic.id
        (unsuccess) ->
          AlertService.setAlert('danger', unsuccess.data.error)
          $scope.alert = AlertService.getAlert()
      )
      
]
