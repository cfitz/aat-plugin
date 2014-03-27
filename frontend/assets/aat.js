$(function() {
  var $searchForm = $("#aat_search");
  var $importForm = $("#aat_import");
  var $results = $("#results");
  var $selected = $("#selected");

  var selected_terms = {};

  var renderResults = function(json) {
    $results.empty();
    $results.append(AS.renderTemplate("template_aat_result_summary", json));
    $.each(json.records, function(i, record) {
      var $result = $(AS.renderTemplate("template_aat_result", {record: record, selected: selected_terms}));
      if (selected_terms[record.uuid]) {
        $(".alert-success", $result).removeClass("hide");
      } else {
        $("button", $result).removeClass("hide");
      }
      $results.append($result);

    });
   // $results.append(AS.renderTemplate("template_aat_pagination", json));
    $('tr', $results).each(function(i, e) {hljs.highlightBlock(e)});
  };


  var selectedTerms = function() {
    var result = [];
    $("[data-uri]", $selected).each(function() {
      console.log("hello"); 
      result.push($(this).data("uri"));
    })
    return result;
  };

  var removeSelected = function(uri) {
    selected_terms[uri] = false;
    $("[data-uri='"+uri+"']", $selected).remove();
    var $result = $("[data-uri='"+uri+"']", $results);
    if ($result.length > 0) {
      $result.removeClass("hide");
      $result.siblings(".alert").addClass("hide");
    }

    if (selectedTerms().length === 0) {
      $selected.siblings(".alert-info").removeClass("hide");
      $("#import-selected").attr("disabled", "disabled");
    }
  };

  var addSelected = function(uri,term, $result) {
    selected_terms[uri] = true;
    $selected.append(AS.renderTemplate("template_aat_selected", {uri: uri, term: term}))

    $(".alert-success", $result).removeClass("hide");
    $("button", $result).addClass("hide");

    $selected.siblings(".alert-info").addClass("hide");
    $("#import-selected").removeAttr("disabled", "disabled");
  };


  var resizeSelectedBox = function() {
    $selected.closest(".selected-container").width($selected.closest(".span4").width() - 30);
  };


  $searchForm.ajaxForm({
    dataType: "json",
    type: "GET",
    beforeSubmit: function() {
      if (!$("#search-query", $searchForm).val()) {
          return false;
      }
      $(".btn", $searchForm).attr("disabled", "disabled").addClass("disabled").addClass("busy");
    },
    success: function(json) {
      $(".btn", $searchForm).removeAttr("disabled").removeClass("disabled").removeClass("busy");
      renderResults(json);
    }
  });


  $importForm.ajaxForm({
    dataType: "json",
    type: "POST",
    beforeSubmit: function() {
      $("#import-selected").attr("disabled", "disabled").addClass("disabled").addClass("busy");
    },
    success: function(json) {
        $("#import-selected").removeClass("busy");
        if (json.job_uri) {
            AS.openQuickModal(AS.renderTemplate("template_aat_import_success_title"), AS.renderTemplate("template_aat_import_success_message"));
            setTimeout(function() {
              window.location = json.job_uri;
            }, 2000);
        } else {
            // error
            $("#import-selected").removeAttr("disabled").removeClass("disabled");
            AS.openQuickModal(AS.renderTemplate("template_aat_import_error_title"), json.error);
        }
    }
  });


  $results.on("click", ".aat-pagination a", function(event) {
  }).on("click", ".aat-result button", function(event) {
    var term = $(this).data("term"); 
    var uri = $(this).data("uri"); 
    if (selected_terms[uri]) {
      removeSelected(uri);
    } else {
      addSelected(uri, term, $(this).closest('.aat-result'));
    }
  });

  $selected.on("click", ".remove-selected", function(event) {
    var uri = $(this).parent().data("uri");
    removeSelected(uri);
  });


  $(window).resize(resizeSelectedBox);
  resizeSelectedBox();
})
