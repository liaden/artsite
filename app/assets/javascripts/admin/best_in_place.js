function highlight_success() {
  $(this).closest('tr').effect('highlight');
}
function display_errors() {
}

$(document).ready(function() {
  $(".best_in_place").best_in_place();
  $(".best_in_place").bind("ajax:success", highlight_success);
});
