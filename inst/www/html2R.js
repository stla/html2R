var HTMLeditor;

$(document).on("shiny:connected", function() {
  HTMLeditor = ace.edit("aceHTML");
});

$(document).ready(function() {
  $("#parse").on("click", function() {
    var html = HTMLeditor.getValue();
    var json = window.himalaya.parse(html);
    Shiny.setInputValue("json:html2R.list", json);
  });
});
