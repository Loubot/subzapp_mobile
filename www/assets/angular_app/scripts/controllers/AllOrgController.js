// Generated by CoffeeScript 1.10.0
'use strict';
angular.module('subzapp_mobile').controller('AllOrgController', [
  '$scope', '$state', '$http', '$window', '$location', 'message', 'user', 'RESOURCES', '$rootScope', function($scope, $state, $http, $window, $location, message, user, RESOURCES, $rootScope) {
    var user_token;
    user_token = window.localStorage.getItem('user_token');
    console.log("All Org Controller");
    user.get_user().then((function(res) {
      return $scope.name = $rootScope.USER.name;
    }));
    $http({
      method: 'GET',
      url: RESOURCES.DOMAIN + "/all-org",
      headers: {
        'Authorization': "JWT " + user_token,
        "Content-Type": "application/json"
      }
    }).then((function(orgs) {
      console.log(orgs);
      return $scope.orgs = orgs.data;
    }), function(errResponse) {
      console.log("Get all org error ");
      return console.log(errResponse);
    });
    return $scope.select_org = function(id) {
      window.localStorage.setItem('org_id', id);
      return $state.go('org');
    };
  }
]);
