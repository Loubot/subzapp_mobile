'use strict'

angular.module('subzapp_mobile').controller('NavController', [
  '$scope'
  '$state'
  '$stateParams'
  ($scope, $state, $stateParams) ->
    console.log 'Nav controller'

    $scope.goto = (state) ->
      console.log "going to #{state}, so there..."
      $state.go state 
])