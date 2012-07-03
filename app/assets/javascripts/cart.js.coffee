# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery -> 
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
    order.setupForm()

order = 
    setupForm: -> 
        $('#checkout').submit -> 
            $('input[type=submit]').attr('disabled', true)
            order.processCard()
            false

    processCard: ->
        card =
            number: $('#card_number').val()
            cvc: $('#card_code').val()
            expMonth: $('#card_month').val()
            expYear: $('#card_year').val()
        Stripe.createToken( card, order.handleStripeResponse)

    handleStripeResponse: (status, response) ->
        if status == 200
            $('#stripe_card_token').val(response.id)
            $('#checkout')[0].submit()
        else
            $('#stripe-error').text(response.error.message)
            $('#stripe-error').removeClass('invisible')
            $('input[type=submit]').attr('disabled', false)
