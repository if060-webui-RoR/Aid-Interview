var templateApp;

templateApp = angular.module('templateApp', ['templates', 'ngRoute', 'ui.bootstrap', 'angularUtils.directives.dirPagination', 'ngResource']);

templateApp.factory("templateService", [
    "$resource", function($resource) {
        return $resource("/templates/:id.json", {
            id: "@id"
        }, {
            'update': {
                method: 'PATCH'
            }
        });
    }
]);

templateApp.config([
    '$routeProvider', function($routeProvider) {
        return $routeProvider.when('/', {
            templateUrl: "templites/index.html",
            controller: 'templateCtrl'
        }).when('/new', {
            templateUrl: "templites/new.html",
            controller: 'templateCtrl'
        }).when('/:id', {
            templateUrl: "templites/show.html",
            controller: 'templateShowCtrl'
        }).when('/:id/edit', {
            templateUrl: "templites/edit.html",
            controller: 'templateEditCtrl'
        });
    }
]);

templateApp.controller('templateCtrl', [
    '$scope', 'templateService', '$window', '$http', function($scope, templateService, $window, $http) {
        $scope.templates = templateService.query();

        $scope.rows = [];

        $scope.addRow = function() {
            var q = angular.element('#question_ids option:selected').val();
            var content = angular.element('#question_ids option:selected').text();
            var remove_button_id, row, table, td_question, td_remove, tr;
            if (content.length === 0) {
                alert('Select a question, please.');
                return;
            }
            table = angular.element(document.querySelector('#question_list'));
            var table_dom = document.getElementById("question_list");
            var canAdd = true;
            var i;
            for (i = 0; i < table_dom.rows.length; i++) {
                if (q == table_dom.rows[i].id.replace("question-row-", "")) {
                    canAdd = false;
                    break;
                }
            }
            if(!canAdd) {
                alert ("Question already exist in the current template. " +
                    "Please choose another question.");
                return;
            }
            tr = angular.element('<tr></tr>');
            tr.attr('id', "question-row-" + q);
            td_question = angular.element('<td></td>').text(content);
            td_question.attr('id', "td-question-" + q);
            remove_button_id = "remove-question-button-" + q;
            td_remove = angular.element('<td></td>').append("<button id=\"" + remove_button_id + "\"class=\"btn btn-info remove-question-button\" type=\"button\" name=\"button\">Remove</button>");
            row = tr.append(td_question, td_remove);
            table.append(row);
        };

        $scope.deleteQuest = function() {
            var btn_id = (angular.element(this)).attr('id');
            var q = btn_id.replace("remove-question-button-", "");
            var content = angular.element(document.querySelector("#td-question-" + q)).text();
            angular.element(document.querySelector("#question-row-" + q)).remove();
        };

        angular.element(document).on('click',".remove-question-button", $scope.deleteQuest);

        $scope.templatesOnPage = 8;
        $scope.order = true;
        $scope.orderByMe = function(param, order) {
            $scope.myOrderBy = param;
            return $scope.order = order;
        };
        $scope.addTemplate = function() {
            var table = document.getElementById("question_list");
            var question_ids = [];
            for (var i = 0, row; row = table.rows[i]; i++){
                question_ids.push(parseInt(row.id.replace("question-row-", "")));
            }
            $scope.template.question_ids = question_ids;
            var template = templateService.save($scope.template).$promise.then(function(success) {$scope.templates.push(template);
                $window.location.href = '/templates';}, function(unsuccess) {
                if (unsuccess.status = 409) { return alert(unsuccess.data.error);
                }
            });
        };
        return $scope.removeTemplate = function(template) {
            if (confirm("Are you sure?")) {
                return template.$remove($window.location.href = '/templates');
            }
        };
    }
]);

templateApp.controller('templateShowCtrl', [
    '$scope', 'templateService', '$window', '$http', '$routeParams', function($scope, templateService, $window, $http, $routeParams) {
        $scope.template = templateService.get({
            id: $routeParams.id
        });
        $scope.removeTemplate = function(template) {
            if (confirm("Are you sure?")) {
                return template.$remove($window.location.href = '/templates');
            }
        };
    }
]);

templateApp.controller('templateEditCtrl', [
    '$scope', '$window', 'templateService', '$http', '$routeParams', function($scope, $window, templateService, $http, $routeParams) {
        $scope.template = templateService.get({
            id: $routeParams.id
        });

        $scope.rows = [];

        $scope.addRow = function(q) {
            var remove_button_id, row, table, td_question, td_remove, tr, q_id, q_cont;
            if (q === undefined) { q_id = angular.element('#question_ids option:selected').val();
                                 q_cont = angular.element('#question_ids option:selected').text(); }
            else {q_id = q.id; q_cont = q.content;}
            if (q_cont.length === 0) {
                alert('Select a question, please.');
                return;
            }
            table = angular.element(document.querySelector('#question_list'));
            var table_dom = document.getElementById("question_list");
            var canAdd = true;
            var i;
            for (i = 0; i < table_dom.rows.length; i++) {
                if (q_id == table_dom.rows[i].id.replace("question-row-", "")) {
                    canAdd = false;
                    break;
                }
            }
            if(!canAdd) {
                alert ("Question already exist in the current template. " +
                    "Please choose another question.");
                return;
            }
            tr = angular.element('<tr></tr>');
            tr.attr('id', "question-row-" + q_id);
            td_question = angular.element('<td></td>').text(q_cont);
            td_question.attr('id', "td-question-" + q_id);
            remove_button_id = "remove-question-button-" + q_id;
            td_remove = angular.element('<td></td>').append("<button id=\"" + remove_button_id + "\"class=\"btn btn-info remove-question-button\" type=\"button\" name=\"button\">Remove</button>");
            row = tr.append(td_question, td_remove);
            table.append(row);
        };

        $scope.deleteQuest = function() {
            var btn_id = (angular.element(this)).attr('id');
            var q = btn_id.replace("remove-question-button-", "");
            angular.element(document.querySelector("#question-row-" + q)).remove();
        };

        angular.element(document).on('click',".remove-question-button", $scope.deleteQuest);

        $scope.editTemplate = function(updatedTemplate) {
            var table = document.getElementById("question_list");
            var question_ids = [];
            for (var i = 0, row; row = table.rows[i]; i++){
                question_ids.push(parseInt(row.id.replace("question-row-", "")));
            }
            $scope.template.question_ids = question_ids;
            templateService.update({
                id: $scope.template.id
            }, updatedTemplate).$promise.then(function(success) { ($window.location.href = '/templates'); },
            function(unsuccess) {
                if (unsuccess.status = 409) {
                    return alert(unsuccess.data.error);
                }
            });
        };
    }
]);

templateApp.directive('init', [ '$http',
    function($http) {
        return {
            controller: ['$scope', '$http', function($scope, $http) {
                $http.get('/templates/questions').then( function(data, status) {
                    $scope.topics = data;
                    $scope.topics = $scope.topics.data;
                    $scope.xservers = [$scope.topics[0]];
                    $scope.xversions = [{ id: 1 }];
                    if($scope.template == undefined) { return; }
                    for (var i = 0; i < $scope.template.questions.length; i++) {
                        var found_question = $.grep($scope.allquestions, function(e) { return e.content == $scope.template.questions[i]; });
                        $scope.addRow(found_question[0]);
                    }
                });
            }]
        };
    }
]);

templateApp.directive('getquest', [ '$http',
    function($http) {
        return {
            link: function(scope, element, attrs) {
                $http.get('/templates/all_questions').then(function(data, status) {
                    scope.allquestions = data;
                    scope.allquestions = scope.allquestions.data;
                });
            }
        };
    }
]);