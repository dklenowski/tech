Categories: web
Tags: javascript

# Javascript Notes

# Functions

- `one` is only defined when that line is reached.
- `two` is a function declaration and defined as soon as surrounding function/script executed.

        var one = function() {
            // Some code
        };

        function two() {
            // Some code
        }

- See http://adripofjavascript.com/blog/drips/variable-and-function-hoisting.html for more detail.

# Miscelaneous

## Convert to json

    json = JSON.stringify({'email': str})

# Jquery

## retreiving text

    <input id="emailInput" type="text" class="form-control email" placeholder="an email"/>

## setting text

	$("#flag_count").text(response.count);
	$("viewId").innerHTML = response.count + " views";

    var str = $(".email").val();

## Unfocus (on chrome)

		$('.btn').blur()

## Change css

		$("#mainContent").css('marginTop', '50px');

## perform operation on each element


        $(".checkbox").each(function () {
        	// do something
        	if ($(this).prop("checked") == true) {
                enable = true;
            }
        });

# AJAX

## Sending a POST ajax

        $.ajax({
          type: 'POST',
          url: "http://post.url",
          headers: {'X-CSRFToken': getCookie('csrftoken')},
          success: function (response) {
            var viewstr = response.count + " views";
            $("#viewId").text(viewstr);
          }
        });

## Redirect to page after ajax


        $.ajax({
          type: 'POST',
          url: "http://post.url",
          dataType: 'json',
          data: json,
          headers: {'X-CSRFToken': getCookie('csrftoken')},
          success: function (response) {
            if (response.result == 'ok') {
              window.location.href = "http://get.url?val=response.count";
          }
          }
        });


