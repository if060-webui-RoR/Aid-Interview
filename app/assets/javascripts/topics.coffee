topicApp = angular.module("topicApp", [
  'ui.bootstrap'
  'templates'
  'ngRoute'
  'angularUtils.directives.dirPagination'
  'ngResource'
])

topicApp.factory "topicService", [
  "$resource"
  ($resource) ->
    $resource("/admin/topics/:id.json", id: "@id", { 'update': {method: 'PATCH'} })
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
        controller: 'topicCtrl'
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

topicApp.controller 'topicCtrl', [
  '$scope'
  'topicService'
  '$window'
  ($scope, topicService, $window) ->
    $scope.topics = topicService.query()

    $scope.topicsOnPage = 8
    $scope.order = true 

    $scope.orderByMe = (param, order) ->
      $scope.myOrderBy = param
      $scope.order = order   

    $scope.addTopic = ->
      topicService.save($scope.topic, -> 
        $window.location.href = '/admin/topics')
 
    
]

topicApp.controller 'topicShowCtrl', [
  '$scope'
  'topicService'
  '$window'
  '$http'
  '$routeParams'
  ($scope, topicService, $window, $http, $routeParams) ->
    $scope.topic = topicService.get({id: $routeParams.id})
    $scope.removeTopic = (topic) ->
      if confirm("Are you shure?")
        topic.$remove( $window.location.href = '/admin/topics' )
]  

topicApp.controller 'topicEditCtrl', [
  '$scope'
  '$window'
  'topicService'
  '$http'
  '$routeParams' 
  ($scope, $window, topicService, $http, $routeParams) ->
    $scope.topic = topicService.get({id: $routeParams.id})
    $scope.editTopic = (updatedTopic) ->
      topicService.update({id: $scope.topic.id}, updatedTopic)
      .$promise.then($window.location.href = '/admin/topics')

]
