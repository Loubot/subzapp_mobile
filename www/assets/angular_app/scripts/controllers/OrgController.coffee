'use strict'

angular.module('subzapp_mobile').controller('OrgController', [
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
    org_id = window.localStorage.getItem 'org_id'
    console.log "Org Controller"

    user.get_user().then ( (res) ->
      # console.log "Got user #{ JSON.stringify res }"
              
      # $scope.org = window.USER.org
      
    ), ( err ) ->
      window.USER = null
      $state.go 'login'



    # console.log "params " + JSON.stringify $location.search().id
    
    $http(
      method: 'GET'
      url: "#{ RESOURCES.DOMAIN }/get-single-org"
      headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
      params: 
        org_id: org_id
    ).success( (org) ->
      console.log "Fetched org data "
      console.log org
      $scope.teams = org.teams
      $scope.org = org
      # 
    ).error (err) ->
      console.log "single org error #{ JSON.stringify err }"
      $state.go 'login'


    $scope.select_team = ( id ) ->
      window.localStorage.setItem 'team_id', id
      $state.go 'team'
])