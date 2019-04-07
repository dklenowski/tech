Categories: web
Tags: javascript
      jquery

# Jquery Notes

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
