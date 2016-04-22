var templateApp;

templateApp = angular.module('templateApp',
   ['templates',
    'Controllers',
    'Directives',
    'ngRoute',
    'ui.bootstrap',
    'angularUtils.directives.dirPagination',
    'ngResource']);


templateApp.factory('Template', ['$resource',
   function($resource){
       return $resource('templates/:id/:action.json', {id:'@id'}, {
           'index': {method: 'GET', isArray:true, responseType: 'json'},
           'query': {method:'GET', params:{id:'templates'}, isArray:true},
           'update': {method: 'PATCH'}
       });
   }]);

templateApp.factory('AllQuestions', ['$resource',
   function($resource){
       return $resource("templates/all_questions.json", {}, {
           allquestions: {method:'GET', isArray:true}
       });
   }]);

templateApp.config(['$routeProvider',
  function($routeProvider) {
      $routeProvider.
          when('/', {
              templateUrl: "templites/index.html",
              controller: 'templateCtrl'
          }).
          when('/new', {
              templateUrl: "templites/new.html",
              controller: 'templateCtrl'
          }).
          when('/:id', {
              templateUrl: "templites/show.html",
              controller: 'templateShowCtrl'
          }).
          when('/:id/edit', {
              templateUrl: "templites/edit.html",
              controller: 'templateEditCtrl'
          });
  }]);

templateApp.filter('getByContent', function() {
    return function(input, id) {
        var i= 0, len=input.length;
        for (; i<len; i++) {
            if (input[i].content == id) {
                return input[i];
            }
        }
        return null;
    }
});

templateApp.filter('pagination', function()
{
    return function(input, start)
    {
        start = +start;
        return input.slice(start);
    };
});

