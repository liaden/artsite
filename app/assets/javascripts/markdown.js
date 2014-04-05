function preview_markdown(source, destination) {
  var data = { markdown: $('#'+source)[0].value }
  $('#'+destination).load('/markdown/preview', data)
}
