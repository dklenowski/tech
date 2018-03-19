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


# Jquery

## setting text

	$("#flag_count").text(response.count);
	$("viewId").innerHTML = response.count + " views";


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
