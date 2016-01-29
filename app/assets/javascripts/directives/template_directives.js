var Directives = angular.module('Directives', []);

Directives.directive('init', ['$http', function($http){
    return {
        link: function(scope, element, attrs) {
            console.log('scope.all_question');
            //$http.get("templates/all_questions").then(function Success (response) {
            //    scope.all_question = response.data;
            //
            //});
        }
        //template: '<select ng-model="selectedQuestion" ng-option="questions as questions.content for questions in all_question"></select>'
    };
}
]);
