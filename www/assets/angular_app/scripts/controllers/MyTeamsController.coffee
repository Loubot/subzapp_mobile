'use strict'

angular.module('subzapp_mobile').controller('MyTeamsController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'message'
  'user'
  'RESOURCES'
  'stripe'
  '$rootScope'
  '$ionicLoading'
  ( $scope, $state, $http, $window, message, user, RESOURCES, stripe, $rootScope, $ionicLoading ) ->
    console.log 'MyTeams Controller'

    $scope.card = {}
    
    user_token = window.localStorage.getItem 'user_token'
    
    
    user.get_user().then ( (res) ->
      console.log res
                
      USER = $rootScope.USER
      $http(
            method: 'GET'
            url: "#{ RESOURCES.DOMAIN }/get-user-teams"
            headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
            data:
              user_id: $rootScope.USER.id
          ).then ( ( res ) ->
            console.log "Get user teams"
            console.log res
          ), ( errResponse ) ->
            console.log "Get user teams error"
            console.log errResponse
    ), ( errResponse ) ->
      console.log "User get error #{ JSON.stringify errResponse }"
      $rootScope.USER = null
      $state.go 'login'


    
    

    
    
         

])