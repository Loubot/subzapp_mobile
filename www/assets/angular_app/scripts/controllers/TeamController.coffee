'use strict'

angular.module('subzapp_mobile').controller('TeamController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  '$location'
  'message'
  'user'
  'RESOURCES'
  '$ionicLoading'
  '$rootScope'

  ($scope, $state, $http, $window, $location, message, user, RESOURCES, $ionicLoading, $rootScope ) ->
    team_id = window.localStorage.getItem 'team_id'
    get_user_events_array = ( events ) ->
      events_array = []
      return [] if !(events?)
      for ev in events
        do ( ev ) ->
          events_array.push ev.id
      # console.log 'events array'
      # console.log events_array
      return events_array

    console.log "Team Controller"

    user_token = window.localStorage.getItem 'user_token'    

    user.get_user().then ( (res) ->
      $scope.users_event_ids = null

      console.log $rootScope.USER
      user = $rootScope.USER
      # console.log user.user_events
      $scope.users_event_ids = get_user_events_array( $rootScope.USER.user_events )
      # console.log 'user events'
      # console.log $scope.users_event_ids
      
      $scope.is_member = check_if_member(user, team_id)
      $scope.user = user
    ), ( err ) ->
      # window.USER = null
      $state.go 'login'



    $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/get-team"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        params:
          team_id: team_id
      ).then ( (res) ->
        console.log 'team'
        console.log res.data
        $scope.team = res.data
        $scope.events = res.data.events
      ), ( errResponse ) ->
        console.log "Get team error #{ JSON.stringify errResponse }"

  
    $scope.join_team = (id) ->
      console.log "User #{ user.id }"
      $ionicLoading.show template: 'Joining team...'
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/join-team"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        data:
          user_id: user.id
          team_id: team_id
      ).then ( (res) ->
        # console.log "Join team response #{ JSON.stringify res }"
        $scope.is_member = check_if_member_after_create(res.data.team_members, user.id)
        $ionicLoading.hide()
        # console.log "teams #{ JSON.stringify team }"
        # $scope.is_member = team.length
      ), ( errResponse ) ->
        console.log "Join team error #{ JSON.stringify errResponse }"
        $ionicLoading.hide()

    $scope.edit_user = ->
      $state.go 'edit-user'

    $scope.pay_up = (id, price) ->
      console.log "Pay up"
      $ionicLoading.show template: 'Joining event'
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/join-event"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        data:
          event_id: id
          event_price: price
          user_id: user.id         
      ).then ( ( res ) ->
        console.log "Pay up response"
        console.log res.data.user.user_events
        $scope.users_event_ids = get_user_events_array( res.data.user.user_events )
        $rootScope.USER = res.data.user
        $ionicLoading.hide()
        message.success res.data.message
      ), ( errResponse ) ->
        $ionicLoading.hide()
        console.log "Pay up error"
        console.log errResponse
        message.error errResponse.data

        
])
#return truthy if user is already a member of the team. This drives ng-hide="is_member" in the team.html view
check_if_member = (user, team_id) ->
  # console.log 'user teams'
  # console.log user.user_teams
  team = (team for team in user.user_teams when team.id is parseInt(team_id) )
  # console.log "Team result"
  # console.log team
  return team.length

check_if_member_after_create = ( team_mems, user_id )->
  # console.log "team_mems #{ JSON.stringify team_mems } team id #{ user_id }"

  users = ( mem for mem in team_mems when mem.id is user_id )
  # console.log "team #{ JSON.stringify users }"
  # console.log users
  return users.length
