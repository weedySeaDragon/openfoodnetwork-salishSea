Darkswarm.controller "CheckoutCtrl", ($scope, $rootScope, order, $location, $anchorScroll) ->
  $scope.require_ship_address = false
  $scope.order = order
  $scope.userOpen = true

  $scope.initialize = ->
    # Our shipping_methods comes through as a hash like so: {id: requires_shipping_address}
    # Here we default to the first shipping method if none is selected
    $scope.order.shipping_method_id ||= Object.keys(order.shipping_methods)[0]
    $scope.order.ship_address_same_as_billing = true if $scope.order.ship_address_same_as_billing == null
    $scope.shippingMethodChanged()
  
  $scope.shippingPrice = ->
    $scope.shippingMethod().price

  $scope.cartTotal = ->
    $scope.shippingPrice() + $scope.order.display_total

  $scope.shippingMethod = ->
    $scope.order.shipping_methods[$scope.order.shipping_method_id]

  $scope.shippingMethodChanged = ->
    $scope.require_ship_address = $scope.shippingMethod().require_ship_address if $scope.shippingMethod()

  $scope.purchase = (event)->
    event.preventDefault()
    checkout.submit()

   $scope.scrollTo = (name)->
      #$scope.userOpen = false
      $("#order_email").focus()
      $location.hash(name);
      $anchorScroll();

  $scope.initialize()

