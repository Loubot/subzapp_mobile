'use strict'

angular.module('subzapp_mobile').controller('AllOrgController', [
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
    console.log "All Org Controller"

    user.get_user().then ( (res) ->
      # console.log "Got user #{ JSON.stringify res }"
              
      $scope.org = window.USER.org
      
    )



    # console.log "params " + JSON.stringify $location.search().id

    
    $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/all-org"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
    ).then ( ( orgs ) ->
        console.log "All orgs " 
        console.log orgs
        $scope.orgs = orgs.data
    ), ( errResponse ) ->
        console.log "Get all org error #{ errResponse }"


])