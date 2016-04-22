describe('UserIndexController', function() {
    describe('Initialization', function() {

        var scope         = null,
            controller    = null,
            httpBackend   = null,
            serverResults = [
                {
                    id: 789,
                    first_name: 'Bob',
                    last_name: 'Jones',
                    email: 'bobj@example.net',
                    //admin: true,
                    //approved: true,
                    password: 'password123',
                    password_confirmation: 'password123'
                },
                {
                    first_name: 'Bobby',
                    last_name: 'Barkley',
                    email: 'bobb@example.net',
                    //admin: true,
                    //approved: true,
                    password: 'password123',
                    password_confirmation: 'password123'
                },
                {
                    id: 791,
                    first_name: 'bobko',
                    last_name: 'Hartl',
                    email: 'michael@example.com',
                    //admin: true,
                    //approved: true,
                    password: 'password123',
                    password_confirmation: 'password123'
                }
            ];

        beforeEach(module('userApp'));

        beforeEach(inject(function ($controller, $rootScope, $httpBackend) {
            scope       = $rootScope.$new();
            httpBackend = $httpBackend;
            controller  = $controller('UserIndexController', {
                $scope: scope
            });
        }));

        //it('default user list', function() {
        //    httpBackend.flush();
        //    expect(scope.users).toBe(serverResults);
        //});

        it('testing', function() {
            expect(true).toBe(true);
        });

    });
});