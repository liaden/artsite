// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery.ui.datepicker
//= require jquery_ujs
//= require svg
//= require best_in_place
//= require foundation
//= require navbar
//= require jquery.dform-1.1.0.min
//= require artwork
//= require show
//= require main
//= require prints

$(function() { 
  $(".best_in_place").best_in_place(); 
  $(document).foundation();
});

function circular_pictures(node_name) {
  var node = $('#'+node_name)
  if (node.length == 0) {
    console.log('did not find '+node);
    return;
  }

  var image_url = node.children('img').first().attr('src');
  node.empty();

  var drawing = SVG(node_name).size(250,250).move(-150,0);
  var image = drawing.image(image_url);
  var circle = drawing.circle(250);
  
  image.clipWith(circle);
}

