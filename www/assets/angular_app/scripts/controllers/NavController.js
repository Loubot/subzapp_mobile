// Generated by CoffeeScript 1.10.0
'use strict';
angular.module('subzapp_mobile').controller('NavController', [
  '$scope', '$state', '$stateParams', function($scope, $state, $stateParams) {
    console.log('Nav controller');
    return $scope.goto = function(state) {
      console.log("going to " + state + ", so there...");
      return $state.go(state);
    };
  }
]);
