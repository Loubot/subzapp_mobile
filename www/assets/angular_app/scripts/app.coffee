# Ionic Starter App
# angular.module is a global place for creating, registering and retrieving Angular modules
# 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
# the 2nd parameter is an array of 'requires'
# 'starter.services' is found in services.js
# 'starter.controllers' is found in controllers.js
angular.module('subzapp_mobile', [
  'ionic'
  'starter.controllers'
  'starter.services'
  'ngAnimate'
  'ui.router'
  'ngRoute'
  'angular-stripe'
  'credit-cards'
]).run(($ionicPlatform) ->
  $ionicPlatform.ready ->
    # Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    # for form inputs)
    if window.cordova and window.cordova.plugins and window.cordova.plugins.Keyboard
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar true
      cordova.plugins.Keyboard.disableScroll true
    if window.StatusBar
      # org.apache.cordova.statusbar required
      StatusBar.styleDefault()
    return
  return
)

angular.module('subzapp_mobile').filter 'yesNo', ->
  (boolean) ->
    if boolean then 'Yes' else 'No'


angular.module('subzapp_mobile').config ($stateProvider, $urlRouterProvider) ->
  # Ionic uses AngularUI Router which uses the concept of states
  # Learn more here: https://github.com/angular-ui/ui-router
  # Set up the various states which the app can be in.
  # Each state's controller can be found in controllers.js
  $stateProvider.state "login",
    url : "/"
    templateUrl : 'assets/angular_app/views/login/login.html'
    # controller : "LoginController"

  # register state
  $stateProvider.state "register",
    url : "/register"
    templateUrl : 'assets/angular_app/views/register/register.html'
    # controller : "RegisterController"

  $stateProvider.state "user",
    url: "/user"
    templateUrl : 'assets/angular_app/views/user/user.html'
    # controller: "UserController"

  $stateProvider.state "edit-user",
    cache: false
    url: "/edit-user"
    templateUrl : 'assets/angular_app/views/user/edit_user.html'
    controller: "EditUserController"

  $stateProvider.state "my-teams",
    cache: false
    url: "/my-teams"
    templateUrl : 'assets/angular_app/views/user/my_teams.html'
    controller: "MyTeamsController"

  $stateProvider.state "stripe-form",
    url: "/stripe-form"
    templateUrl : 'assets/angular_app/views/user/stripe_form.html'
    controller: 'EditUserController'

  $stateProvider.state "org",
    url: "/org"
    templateUrl : 'assets/angular_app/views/org/org.html'
    # controller: "OrgController"
    
  $stateProvider.state "all_org",
    url: "/all-org"
    templateUrl : 'assets/angular_app/views/org/all-org.html'
    controller: "AllOrgController"

  $stateProvider.state "team",
    url: "/team"
    templateUrl : 'assets/angular_app/views/team/team.html'
    controller: "TeamController"

  $stateProvider.state "token",
    url: "/token"
    templateUrl : 'assets/angular_app/views/token/token.html'
    # controller: "TokenController"

  
  # $stateProvider.state('tab',
  #   url: '/tab'
  #   abstract: true
  #   templateUrl: 'templates/tabs.html').state('tab.dash',
  #   url: '/dash'
  #   views: 'tab-dash':
  #     templateUrl: 'templates/tab-dash.html'
  #     controller: 'DashCtrl').state('tab.chats',
  #   url: '/chats'
  #   views: 'tab-chats':
  #     templateUrl: 'templates/tab-chats.html'
  #     controller: 'ChatsCtrl').state('tab.chat-detail',
  #   url: '/chats/:chatId'
  #   views: 'tab-chats':
  #     templateUrl: 'templates/chat-detail.html'
  #     controller: 'ChatDetailCtrl').state 'tab.account',
  #   url: '/account'
  #   views: 'tab-account':
  #     templateUrl: 'templates/tab-account.html'
  #     controller: 'AccountCtrl'
  # if none of the above states are matched, use this as the fallback
  # $urlRouterProvider.otherwise '/tab/dash'
  $urlRouterProvider.otherwise "/"  
  return

angular.module('subzapp_mobile').constant 'RESOURCES', do ->
  # Define your variable
  # console.log "url " + window.location.origin 
  # url = window.location.origin 
  url = "http://localhost:1337"
  # url = "https://subzapp.herokuapp.com"
  # Use the variable in your constants
  {
    DOMAIN: url
    # USERS_API: resource + '/users'
    # BASIC_INFO: resource + '/api/info'
  }


angular.module('subzapp_mobile').factory 'message', ->
  error: (mes) ->
    $('.message').removeClass 'success_message'
    $('.message').addClass 'error_message'
    $('.message').text mes
    $('.message').show 'slide', { direction: 'right' }, 1000
    setTimeout ( ->
      $('.message').hide 'slide', { direction: 'left' }, 1000
    ), 10000
    
  success: ( mes ) ->
    console.log mes
    $('.message').removeClass 'error_message'
    $('.message').addClass 'success_message'
    $('.message').text mes
    $('.message').show 'slide', { direction: 'right' }, 1000
    setTimeout ( ->
      $('.message').hide 'slide', { direction: 'left' }, 1000
    ), 10000

    
 angular.module('subzapp_mobile').service 'user', ($http, $state, $rootScope, RESOURCES ) ->
  console.log "user service"
  {
    get_user: ->
      
      # console.log "yyyyyyyyyyyyyyyyyyy"
      user_token = window.localStorage.getItem 'user_token'
      id = window.localStorage.getItem 'user_id'

      # console.log " token #{ user_token }"
      # console.log "id #{ id }"
      $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/user/#{ id }"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
      ).success( (data) ->
        # console.log "Fetched user data #{ JSON.stringify data }"
        if !(data?)
          console.log "No user data"
          $state.go 'login'
          
          return false
        else
          # console.log 'here'
          # console.log data
          $rootScope.USER = data
          return data
        
      ).error (err) ->
        console.log "Fetching user data error #{ JSON.stringify err }"
        $state.go 'login'
  }


window.init = ->
  console.log "Hello"


$(document).on 'click', '#subzapp_nav', ->
  $('.subzapp_nav_collapse').collapse('hide')