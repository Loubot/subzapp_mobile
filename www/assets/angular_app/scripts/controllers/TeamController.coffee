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
  '$rootScope'

  ($scope, $state, $http, $window, $location, message, user, RESOURCES, $rootScope ) ->
    console.log "Team Controller"
    user_token = window.localStorage.getItem 'user_token'    

    user.get_user().then ( (res) ->
      user = $rootScope.USER
      console.log user
      # console.log "Got user #{ JSON.stringify res }"
      # console.log USER.tokens[0].amount
      $scope.is_member = check_if_member(user, $location.search().id)
      $scope.user = user
    ), ( err ) ->
      window.USER = null
      $state.go 'login'



    $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/get-team"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        params:
          team_id: $location.search().id
      ).then ( (res) ->
        # console.log res.data
        $scope.team = res.data
        $scope.events = res.data.events
      ), ( errResponse ) ->
        console.log "Get team error #{ JSON.stringify errResponse }"

  
    $scope.join_team = (id) ->
      console.log "User #{ USER.id }"
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/join-team"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        data:
          user_id: USER.id
          team_id: $location.search().id
      ).then ( (res) ->
        console.log "Join team response #{ JSON.stringify res }"
        $scope.is_member = check_if_member_after_create(res.data.team_members, USER.id)
        
        # console.log "teams #{ JSON.stringify team }"
        # $scope.is_member = team.length
      ), ( errResponse ) ->
        console.log "Join team error #{ JSON.stringify errResponse }"

    $scope.edit_user = ->
      $state.go 'edit-user'

    $scope.pay_up = (id, price) ->
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
        console.log res
      ), ( errResponse ) ->
        console.log "Pay up error"
        console.log errResponse

        
])
#return truthy if user is already a member of the team. This drives ng-hide="is_member" in the team.html view
check_if_member = (user, team_id) ->
  team = (team for team in user.user_teams when team.id is parseInt(team_id) )
  console.log "Team result #{ typeof team }"
  return team.length

check_if_member_after_create = ( team_mems, user_id )->
  # console.log "team_mems #{ JSON.stringify team_mems } team id #{ user_id }"

  users = ( mem for mem in team_mems when mem.id is user_id )
  console.log "team #{ JSON.stringify users }"
  return users.length
