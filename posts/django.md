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