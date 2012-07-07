# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery -> 
    prints.setup()

prints = 
    setup: ->
        $('input[class^="print_"]').change ->
            words = $(this).attr('class').split('_')
            # words[0] is 'print'
            material = words[1]
            dimension = words[2]

            price = (Number) $('#'+material+'_'+dimension+'_price').text()

            if material == 'photopaper'
                # we have frames to handle as well
                $('input[class^="framing_photopaper"]').each (i) ->
                    if $(this).is(':checked')
                        frame_type = $(this).attr('class').split('_')[2]
                        price_id = '#photopaper_'+dimension+'_'+frame_type+'_framing_price'
                        price = price + (Number) $(price_id).text()

                        $('#'+material+'_total_amount').text('$'+price+'.00')
            
        $('input[class^="framing_"]').change ->

            words = $(this).attr('class').split('_')
            material = 'photopaper' # words[1] as well
            frame_type = words[2]

            $('input[class^="print_photopaper"]').each (i) ->
                if $(this).is(':checked')
                    dimension = $(this).attr('class').split('_')[2]
                    
                    price = (Number) $('#'+material+'_'+dimension+'_price').text() # print price
                    price += (Number) $('#'+material+'_'+dimension+'_'+frame_type+'_framing_price' ).text() # frame price added
                    
                    $('#'+material+'_total_amount').text('$'+price+'.00')

