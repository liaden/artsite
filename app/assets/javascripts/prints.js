function build_form(material) {
  $('#print-form').empty();
  $('#print-form').dform( $("#json-form").data('json-form-url')+'?material='+material,
    function(data) {
        alert('success');
        hookup_ajax_create_on_submit(material);
    }
  )
}

function hookup_ajax_create_on_submit(material) {
  $('#save-button').click(function() {
    var posting = $.post( $('json-form').data('submit-url'), $('#print-form').serialize());

    posting.done( function(data) {
      var print_contents = $(data).find('.print-instance');
      $('#'+material+'-prints').append(print_contents);
    });

    return false;
  });
}
