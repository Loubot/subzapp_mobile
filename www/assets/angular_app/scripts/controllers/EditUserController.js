// Generated by CoffeeScript 1.10.0
'use strict';
angular.module('subzapp_mobile').controller('EditUserController', [
  '$scope', '$state', '$http', '$window', 'message', 'user', 'RESOURCES', 'stripe', '$rootScope', '$ionicModal', function($scope, $state, $http, $window, message, user, RESOURCES, stripe, $rootScope, $ionicModal) {
    var user_token;
    console.log('EditUser Controller');
    user_token = window.localStorage.getItem('user_token');
    if (!(window.USER != null)) {
      user.get_user().then((function(res) {
        return $scope.user = $rootScope.USER;
      }), function(errResponse) {
        console.log("User get error " + (JSON.stringify(errResponse)));
        window.USER = null;
        return $state.go('login');
      });
    } else {
      console.log('else');
      $scope.orgs = window.USER.orgs;
      $scope.user = USER;
    }
    $scope.edit_user = function() {
      return $http({
        method: 'POST',
        url: RESOURCES.DOMAIN + "/edit-user",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        },
        data: {
          id: $scope.user.id,
          firstName: $scope.user.firstName,
          lastName: $scope.user.lastName
        }
      }).then((function(response) {
        console.log("Edit user response " + (JSON.stringify(response)));
        return message.success('User updated ok');
      }), function(errResponse) {
        console.log("Edit user error " + (JSON.stringify(errResponse)));
        return message.errir(JSON.stringify(errResponse));
      });
    };

    /* Stripe payments */
    $scope.stripe_submit = function() {
      var amount, stripe_response;
      console.log('stripe');
      console.log($scope.card);
      amount = $scope.card.amount;
      delete $scope.card.amount;
      console.log("amount " + amount + " ");
      stripe_response = function(status, token) {
        console.log(status);
        console.log(token);
        console.log("amount " + amount);
        return $http({
          method: 'POST',
          url: RESOURCES.DOMAIN + "/create-payment",
          headers: {
            'Authorization': "JWT " + user_token,
            "Content-Type": "application/json"
          },
          data: {
            stripe_token: token.id,
            amount: amount,
            user_id: USER.id
          }
        }).then((function(res) {
          console.log(res);
          return message.success(res.data.message);
        }), function(errResponse) {
          console.log("Create payment error " + (JSON.stringify(errResponse)));
          console.log(errResponse);
          return message.error(errResponse.data);
        });
      };
      stripe.setPublishableKey('pk_test_bfa4lYmoaJZTm9d94qBTEEra');
      stripe.card.createToken($scope.card, stripe_response);
      return console.log(stripe);
    };
    $scope.add_validation = function(e) {
      var t;
      console.log("he hey");
      t = e.target;
      $(t).addClass('validation');
      console.log(e);
      return true;
    };
    $('#myModal').modal('show');
    return $scope.openModal = function() {
      $ionicModal.fromTemplateUrl('assets/angular_app/views/modals/payment-form.html', {
        scope: $scope,
        animation: 'slide-in-up'
      }).then(function(modal) {
        $scope.modal = modal;
      });
      $scope.openModal = function() {
        console.log('hererer');
        return $scope.modal.show();
      };
      return $scope.closeModal = function() {
        return $scope.modal.hide();
      };
    };
  }
]);
