'use strict'

angular.module('subzapp_mobile').controller('RegisterController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'message'
  'RESOURCES'
  '$ionicLoading'
  '$rootScope'

  ($scope, $state, $http, $window, message, RESOURCES, $ionicLoading, $rootScope ) ->

    console.log "Register Controller"
    $rootScope.USER = null

    $scope.register_submit = ->
      $ionicLoading.show template: 'Registering...'
    
      console.log $scope.register_form_data
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/auth/signup"
        data: $scope.register_form_data
      ).then ( (response) ->
        console.log "Registration successfull #{ JSON.stringify response }"
        window.localStorage.setItem 'user_token', response.data.data.token
        # console.log "user_token " + window.localStorage.getItem 'user_token'
        window.localStorage.setItem 'user_id', response.data.data.user.id
        $ionicLoading.hide()
        $state.go 'all_org'
      ), ( errResponse ) ->
        console.log "Registration failed #{ JSON.stringify errResponse.data.invalidAttributes.email[0].message }"
        $ionicLoading.hide()
        window.USER = null
        message.error( errResponse.data.invalidAttributes.email[0].message)
        $state.go 'login'


])