//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require foundation
//= require svg
//= require routes
//= require best_in_place
//= require best_in_place.jquery-ui
//= require navbar
//= require jquery.dform-1.1.0.min
//= require artwork
//= require show
//= require main
//= require prints
//= require markdown

$(function() { 
  $(".best_in_place").best_in_place(); 
  $(document).foundation();
});

function circular_pictures(node_name) {
  var node = $('#'+node_name)
  if (node.length == 0) {
    return;
  }

  var image_url = node.children('img').first().attr('src');
  node.empty();

  var drawing = SVG(node_name).size(250,250).move(-150,0);
  var image = drawing.image(image_url);
  var circle = drawing.circle(250);
  
  image.clipWith(circle);
}
