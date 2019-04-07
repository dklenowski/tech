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

# HTML

## value of an element

	$("#input").val();

# for each class

		$(".bookmark").each(function () {
           $(this).click(function () {
           		...


# for a id

		$("#bookmark").each(...)

# dump class attributes for element

		$(this).attr("class"))

# check if an element has a class

		if ($(this).hasClass("material-icon-button-selected")) {

		}

# ajax

        $.ajax({
            type: 'POST',
            url: '/video/' + vid.val() + '/bookmark/',
            headers: {'X-CSRFToken': getCookie('csrftoken')},
            success: function (response, status, xhr) {
                console.log(response);
                console.log();
                console.log(xhr.getAllResponseHeaders());
                if (response.result == 'success') {
                    console.log("success");
                    //$("#bookmark-icon").css('color', '#000000');
                }
            }
        });

# set css on element

		$("#bookmark-icon").css('color', '#000000');


# children

   		var children = $(this).children();

        $(children).each(function(index, item){
            console.log(index);
            console.log(item);
        });

# get the first child

		$(this).first();

		// for some reason the above doesnt work in all cases?
		// but the below seems to
		$(this).children(":first");

# to access an innner element (when you know the type)

		<a id="live_right">
		<input type="hidden" value="{{ live.next_page_number }}"/>
		</a>

		$("#live_right > input").val());


# Miscelaneous

## Convert to json

    json = JSON.stringify({'email': str})

## Console logging

    console.log("story " + name + " story");

    // maybe slightly faster, insert's spaces for you
    console.log("story", name, "story");

    // with objects
    const v = `${follower.displayName} is now following you.`;

