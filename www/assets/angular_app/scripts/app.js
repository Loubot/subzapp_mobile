// Generated by CoffeeScript 1.10.0
angular.module('subzapp_mobile', ['ionic', 'starter.controllers', 'starter.services', 'ngAnimate', 'ui.router', 'ngRoute', 'angular-stripe', 'credit-cards']).run(function($ionicPlatform) {
  $ionicPlatform.ready(function() {
    if (window.cordova && window.cordova.plugins && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
      cordova.plugins.Keyboard.disableScroll(true);
    }
    if (window.StatusBar) {
      StatusBar.styleDefault();
    }
  });
});

angular.module('subzapp_mobile').filter('yesNo', function() {
  return function(boolean) {
    if (boolean) {
      return 'Yes';
    } else {
      return 'No';
    }
  };
});

angular.module('subzapp_mobile').config(function($stateProvider, $urlRouterProvider) {
  $stateProvider.state("login", {
    url: "/",
    templateUrl: 'assets/angular_app/views/login/login.html'
  });
  $stateProvider.state("register", {
    url: "/register",
    templateUrl: 'assets/angular_app/views/register/register.html'
  });
  $stateProvider.state("user", {
    url: "/user",
    templateUrl: 'assets/angular_app/views/user/user.html'
  });
  $stateProvider.state("edit-user", {
    cache: false,
    url: "/edit-user",
    templateUrl: 'assets/angular_app/views/user/edit_user.html',
    controller: "EditUserController"
  });
  $stateProvider.state("my-teams", {
    cache: false,
    url: "/my-teams",
    templateUrl: 'assets/angular_app/views/user/my_teams.html',
    controller: "MyTeamsController"
  });
  $stateProvider.state("stripe-form", {
    url: "/stripe-form",
    templateUrl: 'assets/angular_app/views/user/stripe_form.html',
    controller: 'EditUserController'
  });
  $stateProvider.state("org", {
    url: "/org",
    templateUrl: 'assets/angular_app/views/org/org.html'
  });
  $stateProvider.state("all_org", {
    url: "/all-org",
    templateUrl: 'assets/angular_app/views/org/all-org.html',
    controller: "AllOrgController"
  });
  $stateProvider.state("team", {
    url: "/team",
    templateUrl: 'assets/angular_app/views/team/team.html',
    controller: "TeamController"
  });
  $stateProvider.state("token", {
    url: "/token",
    templateUrl: 'assets/angular_app/views/token/token.html'
  });
  $urlRouterProvider.otherwise("/");
});

angular.module('subzapp_mobile').constant('RESOURCES', (function() {
  var url;
  url = "http://localhost:1337";
  return {
    DOMAIN: url
  };
})());

angular.module('subzapp_mobile').factory('message', function() {
  return {
    error: function(mes) {
      $('.message').removeClass('success_message');
      $('.message').addClass('error_message');
      $('.message').text(mes);
      $('.message').show('slide', {
        direction: 'right'
      }, 1000);
      return setTimeout((function() {
        return $('.message').hide('slide', {
          direction: 'left'
        }, 1000);
      }), 10000);
    },
    success: function(mes) {
      console.log(mes);
      $('.message').removeClass('error_message');
      $('.message').addClass('success_message');
      $('.message').text(mes);
      $('.message').show('slide', {
        direction: 'right'
      }, 1000);
      return setTimeout((function() {
        return $('.message').hide('slide', {
          direction: 'left'
        }, 1000);
      }), 10000);
    }
  };
});

angular.module('subzapp_mobile').service('user', function($http, $state, $rootScope, RESOURCES) {
  console.log("user service");
  return {
    get_user: function() {
      var id, user_token;
      user_token = window.localStorage.getItem('user_token');
      id = window.localStorage.getItem('user_id');
      return $http({
        method: 'GET',
        url: RESOURCES.DOMAIN + "/user/" + id,
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        }
      }).success(function(data) {
        if (!(data != null)) {
          console.log("No user data");
          $state.go('login');
          return false;
        } else {
          $rootScope.USER = data;
          return data;
        }
      }).error(function(err) {
        console.log("Fetching user data error " + (JSON.stringify(err)));
        return $state.go('login');
      });
    }
  };
});

window.init = function() {
  return console.log("Hello");
};

$(document).on('click', '#subzapp_nav', function() {
  return $('.subzapp_nav_collapse').collapse('hide');
});
