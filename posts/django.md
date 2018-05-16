Categories: python
Tags: python
      django

## Create a dependency

	email = self.cleaned_data['email']
	password = self.cleaned_data['password']
	user = User.objects.create_user(email, password)
	user.save()
	profile, created = Profile.objects.update_or_create(user=user)

## Convert QuerySet to array

- QuerySet's are lazy.
- Convert to list forces evaluation (http://django-doc-pootle-test.readthedocs.io/en/latest/ref/models/querysets.html)

        result = User.objects.filter(Q(username__icontains=to) | Q(nickname__icontains=to))
        users = list(result)

# Splinter

## Getting an attribute

- `to` is a form field with name `to`

		<input type="text" name="to" required="" id="id_to" class="requiredField  dare-has-error" value="mary" maxlength="255" style="width:360px" placeholder="a friends email/username/nickname" data-toggle="tooltip" data-placement="bottom" title="" data-original-title="Sorry, couldn't find that user, you might need to use an email.">

- `data-original-title` is an attribute

        el = self.browser.find_by_name('to').first
        self.assertEquals(el._element.get_attribute('data-original-title'),
                          "Sorry, couldn't find that user, you might need to use an email.")

