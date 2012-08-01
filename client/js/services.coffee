# Demonstrate how to register services
# In this case it is a simple value service
angular.module('MyApp.services', []).
  value('version', '0.1')


angular.module('SessionService',['ngResource']).
  factory('Session', ($resource) ->
    $resource(
      '/users/session', 
      {},
      login:{method: 'POST'},
      logout:{method: 'DELETE'}
    )
  )


angular.module('UserService', ['ngResource']).
  factory('User', ($resource) ->
    User = $resource('/users', {},
      {
        register:{method: 'POST'},
        me:{method: 'GET'},
        update:{method: 'PUT'}
      })
  )


