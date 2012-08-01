angular.module('MyApp', ['SessionService', 'UserService','ngCookies']).
  config(['$routeProvider', ($route) ->
    $route.when('/register',
                templateUrl: '/app/partials/users/registration.html',
                controller: UserRegistrationCtrl)
    $route.when('/login',
                templateUrl: '/app/partials/users/login.html',
                controller: UserLoginCtrl)
    $route.when('/me',
                templateUrl: '/app/partials/users/me.html',
                controller: UserMeCtrl)
    $route.when('/password_reset',
                templateUrl: '/app/partials/users/password_reset.html',
                controller: UserPasswordResetCtrl)
    $route.otherwise({redirectTo: '/login'})
  ]).
  config(($httpProvider) ->
    interceptor = ['$rootScope','$q', (scope, $q) ->
      success = (response) ->
        response
      error = (response) ->
        status = response.status
        if status is 401
          deferred = $q.defer()
          req =
            config: response.config
            deferred: deferred
          scope.requests401 = req
          scope.$broadcast('event:loginRequired')
          return deferred.promise
        $q.reject(response)
      (promise) ->
        promise.then(success, error)
      ]
    $httpProvider.responseInterceptors.push(interceptor)
  ).
  run(['$rootScope', '$location','$cookieStore', 'User', 'Session',
      (scope, $location, $cookieStore, User, Session) ->
        scope.requests401 = '/me'
        scope.$on('event:loginRequired',(event) ->
          $cookieStore.put('signed_in', false)
          $location.path('/login')
        ) 
        scope.$on("event:loginConfirmed", (event) ->
          $cookieStore.put('signed_in', true)
          $location.path(scope.requests401) if $location.path() is "/login"
        )
        scope.$on('event:logoutRequest', (event) ->
          result = Session.logout () ->
            console.log('logout request')
            if result.status is 'ok'
              scope.$broadcast('event:logoutConfirmed')
        )
        scope.$on('event:logoutConfirmed', (event) ->
          $cookieStore.put('signed_in', false)
          $location.path('/login')
        )

        ping = () ->
          response = User.me () ->
            if response.status is 'ok'
              scope.$broadcast('event:loginConfirmed')
        ping()
  ])
