Categories: python
Tags: objects

## Python Objects

### `__new__` and `__init__`

Reference: http://mail.python.org/pipermail/tutor/2008-April/061426.html

- Use `__new__` when you need to control the creation of a new instance.
- Use `__init__` when you need to control initialization of a new instance.

#### `__new__`

- First step of instance creation.  
- It's called first, and is responsible for returning a new instance of your class.  

#### `__init__`
- In contrast, `__init__` doesn't return anything; it's only responsible for initializing the instance after it's been created.
- In general, you shouldn't need to override `__new__` unless you're subclassing an immutable type like `str`, `int`, `unicode` or `tuple`.

### `__str__` 

Reference: http://docs.python.org/reference/datamodel.html

- "Informal" string representation of the object.
- Return value must be a string.
- i.e. the output of `__str__` is used in `print .. % str(object)`

### `__repr__` 

Reference: http://docs.python.org/reference/datamodel.html

- "Official" string representation of the object.
- Should look like a valid Python expression, if not possible then string of the form `<...some useful description>` should be returned.

- **Note:** `__repr__` is used when calling `str()` on an object in a list.
