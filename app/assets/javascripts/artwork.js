$(document).ready(function() {
  $('#artwork_created_at').datepicker();
});

function delete_artwork(caller) {
  $.ajax( {
    url: $(caller).data('delete-url'),
    type: 'DELETE',
    success:  function() {
      $(caller).closest('.artwork-cell').remove(); 
    },
    error: function() {
      console.log('Error occurred when deleting artwork.');
    }
  });
}

function toggle_feature(caller) {

  if( caller.innerHTML == 'Feature') {
    var new_value = true;
    var new_text = 'Remove from featured';
  }else {
    var new_value = false;
    var new_text = 'Feature';
  }
  
  $.ajax( {
        url: $(caller).data('update-url'), 
        type: 'PUT',
        data: { 
          artwork: { featured: new_value },
          bip: 'skip'
        }, 
        success: function() {
           caller.innerHTML = new_text;
           if($('#featured-filter').hasClass('active')) {
             $(caller).closest('.artwork-cell').remove(); 
           } 
        },
        error: function() {
          console.log('An error has occurred in toggling featured status.');
        }
  });
}
