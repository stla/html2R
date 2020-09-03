var HTMLeditor, Reditor;

$(document).on("shiny:connected", function() {
  HTMLeditor = ace.edit("aceHTML");
  Reditor = ace.edit("aceR");
  Shiny.addCustomMessageHandler("updateScrollBarH", function(editor) {
    setTimeout(function() {
      switch(editor) {
        case "HTML":
          HTMLeditor.renderer.$updateScrollBarH();
          break;
        case "R":
          Reditor.renderer.$updateScrollBarH();
          break;
      }
    }, 0);
  });
});

$(document).ready(function() {
  $("#parse").on("click", function() {
    var html = HTMLeditor.getValue();
    var json = window.himalaya.parse(html);
    Shiny.setInputValue("json:html2R.list", json);
  });
  $("#copy").on("click", function() {
    var R = Reditor.getValue();
    navigator.clipboard.writeText(R);
  });
});
