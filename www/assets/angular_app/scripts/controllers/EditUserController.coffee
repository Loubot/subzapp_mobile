'use strict'

angular.module('subzapp_mobile').controller('EditUserController', [
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
  '$ionicModal'
  ( $scope, $state, $http, $window, message, user, RESOURCES, stripe, $rootScope, $ionicLoading, $ionicModal ) ->
    console.log 'EditUser Controller'

    $scope.card = {}
    
    user_token = window.localStorage.getItem 'user_token'
    
    
    user.get_user().then ( (res) ->
        # console.log res
                
      USER = $rootScope.USER
      console.log USER.tokens[0].amount
      $scope.tokens = USER.tokens[0].amount
      $scope.user_data = USER
    ), ( errResponse ) ->
      console.log "User get error #{ JSON.stringify errResponse }"
      $rootScope.USER = null
      $state.go 'login'
    

    
    $scope.edit_user = ->
      # console.log $scope.user_data
      $ionicLoading.show template: 'Updating...'
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/edit-user"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        data: 
          id: $scope.user_data.id
          firstName: $scope.user_data.firstName
          lastName: $scope.user_data.lastName
      ).then ( (response) ->
        console.log "Edit user response "
        console.log response
        $ionicLoading.hide()
        message.success('User updated ok')
      ), ( errResponse ) ->
        console.log "Edit user error"
        console.log errResponse
        $ionicLoading.hide()
        message.error JSON.stringify errResponse

    $scope.stripe_submit = ->
      console.log 'stripe'
      # console.log $scope.card
      $ionicLoading.show template: 'Loading...'
      amount = $scope.card.amount

      delete $scope.card.amount
      # console.log "amount #{ amount } "
      

      stripe_response = (status, token) ->
        
        $http(
          method: 'POST'
          url: "#{ RESOURCES.DOMAIN }/create-payment"
          headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
          data:
            stripe_token: token.id
            amount: amount
            user_id: $rootScope.USER.id
        ).then ( ( res ) ->
          console.log "res #{ JSON.stringify res.data.message }"
          # console.log res
          message.success res.data.message
          $scope.tokens = res.data.token.amount
          setTimeout ( ->
            $ionicLoading.hide()
            $state.go "edit-user"
          ), 5000
          
        ), ( errResponse ) ->
          console.log "Create payment error #{ JSON.stringify errResponse }"
          console.log errResponse
          message.error errResponse.data
          $ionicLoading.hide()

        
      
      stripe.setPublishableKey('pk_test_bfa4lYmoaJZTm9d94qBTEEra')
      stripe.card.createToken $scope.card, stripe_response
      # console.log stripe
    
    $scope.add_validation = (e) ->
      console.log "he hey"
      t = e.target
      $(t).addClass('validation')
      console.log e
      return true

])

$(document).on 'focus', '#cardNumber', (e) ->
  console.log e
  $(@).css 'border-color', 'red !important'