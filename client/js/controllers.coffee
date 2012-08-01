@NavCtrl = ($scope, $rootScope, $location, $cookieStore, Session) ->
   $scope.authenticated = () ->
     $cookieStore.get('signed_in')
   $scope.logout = () ->
     $rootScope.$broadcast('event:logoutRequest')



@UserRegistrationCtrl = ($scope, $rootScope, $location, $cookieStore, User)->
  $scope.register =  () ->
    $scope.response = User.register {user: $scope.User}, () ->
      if $scope.response.status is 'ok'
        $rootScope.$broadcast('event:loginConfirmed')
      else
        alert($scope.response.error)


@UserMeCtrl = ($scope, $http, User) ->
   response = User.me({}, () ->
     $scope.User = response.user
   )
   $scope.reset_access_token = () ->
     $http.put("/users/access_token").
       success((data) ->
         $scope.User.access_token = data.access_token
       )

@UserLoginCtrl = ($scope, $rootScope, $location, $cookieStore, Session) ->
  $scope.login = () ->
    $scope.response = Session.login $scope.Session, () ->
      if $scope.response.status is 'ok'
        $rootScope.$broadcast('event:loginConfirmed')
      else
        alert($scope.response.error)
    
@UserPasswordResetCtrl = ($scope, $location, $http, User) ->
  $scope.reset = () ->
    $http.put('/users/password', $scope.User).
      success((data) ->
        if data.status is 'ok'
          $location.path('/me')
          alert('Password Reset done')
        else
          alert(data.error)
        )
        
    

