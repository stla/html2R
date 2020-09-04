var HTMLeditor, Reditor;


$(document).on("shiny:connected", function() {
  HTMLeditor = ace.edit("aceHTML");
  Reditor = ace.edit("aceR");
  Shiny.addCustomMessageHandler("updateScrollBarH", function(editor) {
    setTimeout(function() {
      switch(editor) {
        case "HTML":
          HTMLeditor.renderer.$updateScrollBarH();
          HTMLeditor.renderer.scrollToX(0);
          HTMLeditor.renderer.scrollToY(0);
          break;
        case "R":
          Reditor.renderer.$updateScrollBarH();
          Reditor.renderer.scrollToX(0);
          Reditor.renderer.scrollToY(0);
          break;
      }
    }, 0);
  });
});


$(document).ready(function() {

  document.getElementById("file").addEventListener("change", function() {
    $("label[for=file]").next().find(".form-control")
      .css("border-bottom-right-radius", 0);
    $(this).parent().css("border-bottom-left-radius", 0);
    return true;
  });

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
