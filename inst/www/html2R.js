var HTMLeditor, Reditor;

function errorAlert() {
  $.alert({
    theme: "bootstrap",
    title: "An error occured!",
    animation: "scale",
    closeAnimation: "scale",
    buttons: {
      okay: {
        text: "Okay",
        btnClass: "btn-blue"
      }
    }
  });
}


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

  $("#aceHTML").one("click", function() {
    $("#background").hide();
    $("#aceHTML,#aceR").css("opacity", 1);
    $("body").css("overflow", "auto");
  });

  $("#file").one("change", function() {
    $("label[for=file]").next().find(".form-control")
      .css("border-bottom-right-radius", 0);
    $(this).parent().css("border-bottom-left-radius", 0);
    $("#background").hide();
    $("#aceHTML,#aceR").css("opacity", 1);
    $("body").css("overflow", "auto");
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

  $("#prettify").on("click", function() {
    if(navigator.onLine) {
      $("#busy").show();
      $(".row").css({"opacity": 0.5, "pointer-events": "none"});
      $.post({
        url: "http://aozozo.com:600/html",
        contentType: "text/plain; charset=UTF-8",
        data: HTMLeditor.getValue(),
        success: function(data) {
          $("#busy").hide();
          $(".row").css({"opacity": 1, "pointer-events": "auto"});
          var formattedCode = decodeURIComponent(data);
          HTMLeditor.setValue(formattedCode, true);
          setTimeout(function() {
            HTMLeditor.renderer.$updateScrollBarH();
            HTMLeditor.renderer.scrollToX(0);
            HTMLeditor.renderer.scrollToY(0);
          }, 0);
        },
        error: function(e) {
          console.log("formatCodeApi error:", e);
          $.getScript(
            "https://www.unpkg.com/prettier@2.0.5/standalone.js"
          ).done(function(script, textStatus) {
            if(textStatus === "success") {
              $.getScript(
                "https://www.unpkg.com/prettier@2.0.5/parser-babel.js"
              ).done(function(script, textStatus) {
                if(textStatus === "success") {
                  $.getScript(
                    "https://www.unpkg.com/prettier@2.0.5/parser-postcss.js"
                  ).done(function(script, textStatus) {
                    if(textStatus === "success") {
                      $.getScript(
                        "https://www.unpkg.com/prettier@2.0.5/parser-html.js"
                      ).done(function(script, textStatus) {
                        if(textStatus === "success") {
                          try {
                            var prettyCode = prettier.format(
                              HTMLeditor.getValue(),
                              {
                                parser: "html",
                                plugins: prettierPlugins
                              }
                            );
                            $("#busy").hide();
                            $(".row").css({"opacity": 1, "pointer-events": "auto"});
                            HTMLeditor.setValue(prettyCode, true);
                            setTimeout(function() {
                              HTMLeditor.renderer.$updateScrollBarH();
                              HTMLeditor.renderer.scrollToX(0);
                              HTMLeditor.renderer.scrollToY(0);
                            }, 0);
                          } catch(err) {
                            $("#busy").hide();
                            $(".row").css({"opacity": 1, "pointer-events": "auto"});
                            $.alert({
                              theme: "bootstrap",
                              title: "Failed to prettify!",
                              content: "This may be due to invalid HTML code.",
                              animation: "scale",
                              closeAnimation: "scale",
                              buttons: {
                                okay: {
                                  text: "Okay",
                                  btnClass: "btn-blue"
                                }
                              }
                            });
                          }
                        } else {
                          errorAlert();
                        }
                      }).fail(function(jqxhr, settings, exception) {
                        console.log("exception:", exception);
                        $("#busy").hide();
                        $(".row").css({"opacity": 1, "pointer-events": "auto"});
                        errorAlert();
                      });
                    } else {
                      errorAlert();
                    }
                  }).fail(function(jqxhr, settings, exception) {
                    console.log("exception:", exception);
                    $("#busy").hide();
                    $(".row").css({"opacity": 1, "pointer-events": "auto"});
                    errorAlert();
                  });
                } else {
                  errorAlert();
                }
              }).fail(function(jqxhr, settings, exception) {
                console.log("exception:", exception);
                $("#busy").hide();
                $(".row").css({"opacity": 1, "pointer-events": "auto"});
                errorAlert();
              });
            } else {
              errorAlert();
            }
          }).fail(function(jqxhr, settings, exception) {
						console.log("exception:", exception);
						$("#busy").hide();
            $(".row").css({"opacity": 1, "pointer-events": "auto"});
            errorAlert();
					});
        }
      });
    } else {
      $.alert({
        theme: "bootstrap",
        title: "No Internet connection!",
        content: "This feature requires an Internet connection.",
        animation: "scale",
        closeAnimation: "scale",
        buttons: {
          okay: {
            text: "Okay",
            btnClass: "btn-blue"
          }
        }
      });
    }
  });

});
