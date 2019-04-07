Categories: web
Tags: javascript
      ajax
      
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


