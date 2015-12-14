'use strict'

angular.module('subzapp_mobile').controller('TokenController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  '$location'
  'message'
  'user'
  'RESOURCES'

  ($scope, $state, $http, $window, $location, message, user, RESOURCES ) ->
    user_token = window.localStorage.getItem 'user_token'
    if !(window.USER?)
      user.get_user().then ( (res) ->
        console.log "User set to #{ JSON.stringify res }"
        # console.log "user controller #{JSON.stringify window.USER }"
        # $scope.orgs = window.USER.orgs
        # return res
      ), ( errResponse ) ->
        console.log "User get error #{ JSON.stringify errResponse }"
        window.USER = null
        $state.go 'login'
        return false
    else
      console.log "User already defined"



    $scope.up_token = ->
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/up-token"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        data: 
          user_id: USER.id
      ).then ( (res) ->
        console.log "Up token response #{ JSON.stringify res }"
      ), ( errResponse ) ->
        console.log "up-token error #{ JSON.stringify errResponse}"

])