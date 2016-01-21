topicApp = angular.module("topicApp", [
  'ui.bootstrap'
  'angularUtils.directives.dirPagination'
  'ngResource'
])

topicApp.factory "topicService", [
  "$resource"
  ($resource) ->
    $resource("/admin/topics/:id.json", {id: "@id"})
]

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
      topicService.save($scope.topic)
      setTimeout (->
        $window.location.href = '/admin/topics'
      ), 500
   
]

topicApp.controller 'topicShowCtrl', [
  '$scope'
  'topicService'
  '$window'
  '$http'
  ($scope, topicService, $window, $http) ->
    $scope.topic = topicService.get({id:angular.element(document.querySelector('#topic_id')).val() })
    $scope.removeTopic = (int) ->
      if confirm("Are you shure?")
        int.$remove()
        setTimeout (->
          $window.location.href = '/admin/topics'
        ), 500
    return 
]  

topicApp.controller 'topicEditCtrl', [
  '$scope'
  '$window'
  'topicService'
  '$http' 
  ($scope, $window, topicService, $http) ->
    $scope.topic = topicService.get({id:angular.element(document.querySelector('#topic_id')).val() })
    $scope.topics = topicService.query()
    $scope.editTopic = (topic) ->
      $http.patch('/admin/topics/' + topic.id, topic, {
        headers: {'Content-Type': 'application/json' }})
      $window.location.href = '/admin/topics'

]
