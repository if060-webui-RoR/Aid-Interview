userApp = angular.module("userApp", [
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
            templateUrl: 'users/index.html'
            controller: 'UserIndexController')
]

userApp.factory "User", ["$resource", ($resource) ->
  $resource("/admin/users/:id.json")

]

userApp.factory "UserApprove", ["$resource", ($resource) ->
  $resource("/admin/users/:id/approve.json", {id: '@id'}, 
    approve:
      method: "PUT"
      action: "approve"
      isArray: false)
]

userApp.controller('UserIndexController', [
  '$scope' 
  '$http' 
  '$routeParams'
  'User'
  'UserApprove'
  ($scope, $http, $routeParams, User, UserApprove) ->
    $scope.users = User.query()
    $scope.usersOnPage = 10
    $scope.sortType = 'first_name'
    $scope.sortReverse = false
    $scope.searchUser = ''

    $scope.deleteUser = (user) ->
      if confirm("Delete user?")
        User.delete(user)
      $scope.users = User.query()
                
    $scope.approveUser = (user) ->
      if confirm("Approve user?")
        user.approved = true
        UserApprove.approve({id: user.id}, user)
])



