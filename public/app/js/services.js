(function() {

  angular.module('MyApp.services', []).value('version', '0.1');

  angular.module('SessionService', ['ngResource']).factory('Session', function($resource) {
    return $resource('/users/session', {}, {
      login: {
        method: 'POST'
      },
      logout: {
        method: 'DELETE'
      }
    });
  });

  angular.module('UserService', ['ngResource']).factory('User', function($resource) {
    var User;
    return User = $resource('/users', {}, {
      register: {
        method: 'POST'
      },
      me: {
        method: 'GET'
      },
      update: {
        method: 'PUT'
      }
    });
  });

}).call(this);
