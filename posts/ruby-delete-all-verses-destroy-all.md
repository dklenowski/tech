Categories: ruby
Tags: delete_all
      destroy_all

- `delete_all` disassociates objects from parent (e.g. by setting the key to `null`), while `destroy_all` actually destroys the objects.
- e.g. used within a model


        def regenerateSomething
          self.entries.destroy_all
          # now we can regenerate entries ..
        end



### Reference: The Rails 3 Way, Second Edition, 7.2 One-to-Many relationships

> It’s worth noting, for performance reasons, that calling delete_all first loads the entire collection of associated objects into memory in order to grab their ids. Then it executes a SQL UPDATE that sets foreign keys for all currently associated objects to nil, effectively disassociating them from their parent. Since it loads the entire association into memory, it would be ill-advised to use this method with an extremely large collection of associated objects.