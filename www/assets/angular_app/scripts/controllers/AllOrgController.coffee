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
  '$rootScope'

  ($scope, $state, $http, $window, $location, message, user, RESOURCES, $rootScope ) ->
    user_token = window.localStorage.getItem 'user_token'
    console.log "All Org Controller"

    user.get_user().then ( (res) ->
      $scope.name = $rootScope.USER.name
      # console.log "Got user #{ JSON.stringify res }"
      # $scope.name = user.name 
      # $scope.org = window.USER.org
      
    )

    # console.log "params " + JSON.stringify $location.search().id

    
    $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/all-org"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
    ).then ( ( orgs ) ->
        # console.log "All orgs " 
        # console.log orgs
        $scope.orgs = orgs.data
    ), ( errResponse ) ->
        console.log "Get all org error "
        console.log errResponse


])