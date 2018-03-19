Categories: python
Tags: python
      django

## Create a dependency

 email = self.cleaned_data['email']
 password = self.cleaned_data['password']
 user = User.objects.create_user(email, password)
 user.save()
 profile, created = Profile.objects.update_or_create(user=user)