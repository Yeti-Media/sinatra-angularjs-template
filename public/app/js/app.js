(function() {

  angular.module('MyApp', ['SessionService', 'UserService', 'ngCookies']).config([
    '$routeProvider', function($route) {
      $route.when('/register', {
        templateUrl: '/app/partials/users/registration.html',
        controller: UserRegistrationCtrl
      });
      $route.when('/login', {
        templateUrl: '/app/partials/users/login.html',
        controller: UserLoginCtrl
      });
      $route.when('/me', {
        templateUrl: '/app/partials/users/me.html',
        controller: UserMeCtrl
      });
      $route.when('/password_reset', {
        templateUrl: '/app/partials/users/password_reset.html',
        controller: UserPasswordResetCtrl
      });
      return $route.otherwise({
        redirectTo: '/login'
      });
    }
  ]).config(function($httpProvider) {
    var interceptor;
    interceptor = [
      '$rootScope', '$q', function(scope, $q) {
        var error, success;
        success = function(response) {
          return response;
        };
        error = function(response) {
          var deferred, req, status;
          status = response.status;
          if (status === 401) {
            deferred = $q.defer();
            req = {
              config: response.config,
              deferred: deferred
            };
            scope.requests401 = req;
            scope.$broadcast('event:loginRequired');
            return deferred.promise;
          }
          return $q.reject(response);
        };
        return function(promise) {
          return promise.then(success, error);
        };
      }
    ];
    return $httpProvider.responseInterceptors.push(interceptor);
  }).run([
    '$rootScope', '$location', '$cookieStore', 'User', 'Session', function(scope, $location, $cookieStore, User, Session) {
      var ping;
      scope.requests401 = '/me';
      scope.$on('event:loginRequired', function(event) {
        $cookieStore.put('signed_in', false);
        return $location.path('/login');
      });
      scope.$on("event:loginConfirmed", function(event) {
        $cookieStore.put('signed_in', true);
        if ($location.path() === "/login") {
          return $location.path(scope.requests401);
        }
      });
      scope.$on('event:logoutRequest', function(event) {
        var result;
        return result = Session.logout(function() {
          console.log('logout request');
          if (result.status === 'ok') {
            return scope.$broadcast('event:logoutConfirmed');
          }
        });
      });
      scope.$on('event:logoutConfirmed', function(event) {
        $cookieStore.put('signed_in', false);
        return $location.path('/login');
      });
      ping = function() {
        var response;
        return response = User.me(function() {
          if (response.status === 'ok') {
            return scope.$broadcast('event:loginConfirmed');
          }
        });
      };
      return ping();
    }
  ]);

}).call(this);
