topicApp = angular.module('topicApp',[
  'controllers',
  'ui.bootstrap',
  'angularUtils.directives.dirPagination'
])

controllers = angular.module('controllers',[])

controllers.controller("TopicIndexController", [ 
  '$scope'
  '$http'
  'TopicService'
  ($scope, $http, TopicService) ->
    $scope.topicsOnPage = 8
    $scope.order = true 

    $http.get('topics.json').then (res) ->
      $scope.topics = res.data
    
    $scope.orderByMe = (param, order) ->
      $scope.myOrderBy = param
      $scope.order = order   
    return  
])

controllers.controller('TopicNewController', ($scope, TopicService) ->

  $scope.AddTopic = ->
    TopicService.AddTopicToDB $scope.topic
  $scope.topic

  ).factory 'TopicService', [
    '$http'
    '$window'
    ($http, $window) ->
      obj = {}
      obj.AddTopicToDB = (topic) ->
        $http.post('http://aidinterview.herokuapp.com/admin/topics#/new', topic)
        .success (response) ->
          $window.location.href = 'index.html';
        .error (response) ->
          alert "Topic already exist!"
      obj    
  ]
