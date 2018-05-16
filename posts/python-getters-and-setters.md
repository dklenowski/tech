Categories: python
Tags: getter
      setter

### Python getter and setter properties ###

Generic Decorator Format:

    @decorator
    def func(args): 
      ....

which is automatically translated to:

    func = decorator(funct)


e.g. 

      class Person:
        @property
        def name(self):
          ...

is translated to:

      class Person
        def name(self)
          ...
        
        name = property(name)

#### A more complete example ####

      import unittest
      
      class Person:
        def __init__(self, firstname, lastname):
          self.firstname = firstname
          self.lastname = lastname
      
        @property
        def firstname(self):          # firstname = property(firstname)
          """ doc comment for firstname getter """
          return self.firstname
      
        @firstname.setter             # firstname = firstname.setter(firstname)
        def firstname(self, firstname):
          self.firstname = firstname
      
        @property 
        def lastname(self):
          """ doc comment for lastname getter """
          return self.lastname
      
        @lastname.setter
        def lastname(self, lastname):
          self.lastname = lastname
      
        def __str__(self):
          return "%s %s" % ( self.firstname, self.lastname )
      
      
      class PersonTests(unittest.TestCase):
        def test_init(self):
          person = Person('eddie', 'vedder')
          self.assertEqual('eddie vedder', str(person), 'init')
      
        def test_firstname(self):
          person = Person('eddie', 'vedder')
          person.firstname = 'bill'
          self.assertEqual('bill vedder', str(person), 'firstname')
      
        def test_setters(self):
          person = Person('eddie', 'vedder')
          person.firstname = 'bill'
          person.lastname = 'murray'
          self.assertEqual('bill murray', str(person), 'firstname+lastname')
      
      
      if __name__ == '__main__': 
        unittest.main()

## Note inheriting from `object`

When using object's the above code will fail (a recursive loop?), instead the following has to be used:

      import unittest
      
      class Person(object):
        def __init__(self, firstname, lastname):
          self._firstname = firstname
          self._lastname = lastname
      
        @property
        def firstname(self):          # firstname = property(firstname)
          """ doc comment for firstname getter """
          return self._firstname
      
        @firstname.setter             # firstname = firstname.setter(firstname)
        def firstname(self, firstname):
          self._firstname = firstname
      
        @property 
        def lastname(self):
          """ doc comment for lastname getter """
          return self._lastname
      
        @lastname.setter
        def lastname(self, lastname):
          self._lastname = lastname
      
        def __str__(self):
          return "%s %s" % ( self.firstname, self.lastname )
      
      
      class PersonTests(unittest.TestCase):
        def test_init(self):
          person = Person('eddie', 'vedder')
          self.assertEqual('eddie vedder', str(person), 'init')
      
        def test_firstname(self):
          person = Person('eddie', 'vedder')
          person.firstname = 'bill'
          self.assertEqual('bill vedder', str(person), 'firstname')
      
        def test_setters(self):
          person = Person('eddie', 'vedder')
          person.firstname = 'bill'
          person.lastname = 'murray'
          self.assertEqual('bill murray', str(person), 'firstname+lastname')
      
      
      if __name__ == '__main__': 
        unittest.main()

### i.e.

- for the property object's/constructor use the `_` versions of the variables (e.g. `self._firstname`) while when accessing the variables within the `class` use the property decorators (e.g. `self.firstname`)
- the `_` variable versions could also be used internally (i.e. `self._firstname`)

    
