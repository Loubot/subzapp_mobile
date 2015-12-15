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
  '$ionicModal'
  ( $scope, $state, $http, $window, message, user, RESOURCES, stripe, $rootScope, $ionicModal ) ->
    console.log 'EditUser Controller'
    
    user_token = window.localStorage.getItem 'user_token'
    
    if !(window.USER?)
      user.get_user().then ( (res) ->
        # console.log res
                
        USER = $rootScope.USER
        $scope.tokens = USER.tokens[0].amount
      ), ( errResponse ) ->
        console.log "User get error #{ JSON.stringify errResponse }"
        $rootScope.USER = null
        $state.go 'login'
    else 
      console.log 'else'
      USER = $rootScope.USER
      $scope.orgs = USER.orgs
      $scope.user = USER
      $scope.tokens = USER.tokens[0].amount

    
    $scope.edit_user = ->
      console.log $scope.user_data
      
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/edit-user"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        data: 
          id: $scope.user_data.id
          firstName: $scope.user_data.firstName
          lastName: $scope.user_data.lastName
      ).then ( (response) ->
        console.log "Edit user response #{ JSON.stringify response }"
        message.success('User updated ok')
      ), ( errResponse ) ->
        console.log "Edit user error #{ JSON.stringify errResponse }"
        message.errir JSON.stringify errResponse


    ### Stripe payments ###
    # $scope.card = 
    #   amount: 1 # set amount to 1 as default
    #   number: 4242424242424242
    #   cvc: 123
    #   exp_month: 12
    #   exp_year: 17

    $scope.stripe_submit = ->
      console.log 'stripe'
      console.log $scope.card

      amount = $scope.card.amount

      delete $scope.card.amount
      console.log "amount #{ amount } "
      

      stripe_response = (status, token) ->
        console.log status
        console.log token
        console.log "amount #{ amount }"

        $http(
          method: 'POST'
          url: "#{ RESOURCES.DOMAIN }/create-payment"
          headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
          data:
            stripe_token: token.id
            amount: amount
            user_id: $rootScope.USER.id
        ).then ( ( res ) ->
          console.log "res #{ JSON.stringify res.data.token.amount }"
          # console.log res
          message.success res.data.message
          $scope.tokens = 'hello'
          $scope.modal.hide()
        ), ( errResponse ) ->
          console.log "Create payment error #{ JSON.stringify errResponse }"
          console.log errResponse
          message.error errResponse.data

        # stripe.customers.create(
        #   source: response
        #   description: 'payinguser@example.com').then((customer) ->
        #   stripe.charges.create
        #     amount: 1000
        #     currency: 'usd'
        #     customer: customer.id
        # ).then (charge) ->
        #   # YOUR CODE: Save the customer ID and other info in a database for later!
        #   console.log charge
        #   return
     
      
      stripe.setPublishableKey('pk_test_bfa4lYmoaJZTm9d94qBTEEra')
      stripe.card.createToken $scope.card, stripe_response
      console.log stripe
    # stripeProvider.setPublishableKey('pk_test_bfa4lYmoaJZTm9d94qBTEEra')

    $scope.add_validation = (e) ->
      console.log "he hey"
      t = e.target
      $(t).addClass('validation')
      console.log e
      return true


    $scope.openModal = ->
      $ionicModal.fromTemplateUrl('assets/angular_app/views/modals/payment-form.html',
        scope: $scope
        animation: 'slide-in-up').then (modal) ->
        $scope.modal = modal
        return

      $scope.openModal = ->
        console.log 'hererer'
        $scope.modal.show()

      $scope.closeModal = ->
        $scope.modal.hide()
        $scope.modal.remove()
        


])

$(document).on 'focus', '#cardNumber', (e) ->
  console.log e
  $(@).css 'border-color', 'red !important'