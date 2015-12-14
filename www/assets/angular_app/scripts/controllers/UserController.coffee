'use strict'

angular.module('subzapp_mobile').controller('UserController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'message'
  'user'
  'RESOURCES'

  ($scope, $state, $http, $window, message, user, RESOURCES ) ->
    $scope.$on '$ionicView.beforeEnter', (event, viewData) ->
      viewData.enableBack = true
      return

    console.log "User Controller"

    if !(window.USER?)
      user.get_user().then ( (res) ->
        # console.log "User set to #{ JSON.stringify res }"
        # console.log "user controller #{JSON.stringify window.USER }"
        # $scope.orgs = window.USER.orgs
        return res
      ), ( errResponse ) ->
        console.log "User get error #{ JSON.stringify errResponse }"
        window.USER = null
        $state.go 'login'
        return false
    else
      console.log "User already defined"

    user_token = window.localStorage.getItem 'user_token'
    $http(
      method: 'GET'
      url: "#{ RESOURCES.DOMAIN }/get-org-list"
      headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
    ).success( (orgs) ->
      console.log "Fetched orgs data #{ JSON.stringify orgs }"
      $scope.orgs = orgs
      
    ).error (err) ->
      console.log "Fetching user data error #{ JSON.stringify err }"
      $state.go 'login'

    $scope.myGoBack = ->
      console.log 'hit it'
      $ionicHistory.goBack()


])