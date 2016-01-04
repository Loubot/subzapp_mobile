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

    get_teams_ids = ( teams ) ->
      teams_array = []
      for team in teams
        console.log 'team'
        console.log team
        teams_array.push team.id

      return teams_array
    
    user_token = window.localStorage.getItem 'user_token'
    
    
    user.get_user().then ( (res) ->
      # console.log "Get user"
      # console.log res
      
      team_ids = get_teams_ids($rootScope.USER.user_teams) 
      console.log "Team ids"
      console.log team_ids      
      USER = $rootScope.USER
      $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/get-user-teams"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        params: 
          teams: team_ids
      ).success( (teams) ->
        console.log "Fetched orgs teams "
        console.log teams
        $scope.teams = teams
      ).error (err) ->
        console.log "Get orgs error #{ JSON.stringify err }"
        $state.go 'login'
      
    ), ( errResponse ) ->
      console.log "User get error #{ JSON.stringify errResponse }"
      $rootScope.USER = null
      $state.go 'login'

    
     
    $scope.select_team = ( id ) ->
      window.localStorage.setItem 'team_id', id
      $state.go 'team'
])