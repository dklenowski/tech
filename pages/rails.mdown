Categories: ruby
Tags: rails

# Rails

## Cheat

  * To use gem's (outside of a rails environment) you need to 'require \'rubygems\'' first.

### Console Access ###

    script/console

### Migrations

    daves:/mnt/lw/current dave$ script/generate migration
add_original_filename_to_songs

          exists  db/migrate

          create  db/migrate/013_add_original_filename_to_songs.rb


    // then rake db:migrate

## Upgrading rails

  1. Edit the config/environment.rb file and change the version.

  2. Update gem

### sudo gem update --system

  3. Update gem plugins

### gem update

  4. Run the update command:

### rails rake:update

Note: You may need to upgrade the rails gem using. # gem install -v=2.3.3
rails

## ActiveRecord

  * Object relational mapping that maps a row in a table/view and encapsulates
database access and adds domain logic to that data.

  * Will automatically create getters/setters for field names of a database
table.

## Params

  * CGI variables and values available through built in 'params' method.

e.g.


    # mail input field
    params[:email]

    # or if stored more deeply
    params[:user][:email]


Note: - There is also the @params variable, better to use params method.

## Generation

    ruby script/generate [ model | controller | scaffold ] <name>


**Scaffold**

  * Auto generated framework for manipulating a model.
  * When run, generates 'scaffold' for a particular model and grants access to
the model through a generated controller.

**Model**

  * Automatically mapped to a database table whose name is the plural of the
form of the model's class.
  * e.g. A "Product" model will be automatically associated with a "products"
table.

**Controller**

  * Handle incoming requests from the browser.

**Testing**


     rake db:test:prepare


  * Copies schema from development database to production database.


  ## Ruby Routes

    * Map incoming URLs to specific controls, actions and also map to parameters
  within application.
    * Similar to Apache mod_rewrite (bit more advanced!)
    * Components are separated by '/'
    * Pattern component of the form :name sets the parameter name to whatever
  the value is in the corresponding position in the URL (i.e. can set particular
  fields e.g. :day, :date) and can also use regex'es to ensure correctly formed
  URL).

  e.g.

      map.connect ':user', 'controller' => 'recipies', :action => 'list',
  :filter => 'user'


  ### Default Route
      map.connect ':controller/:action/:id'


    * e.g. for

      store/add_to_card/123

    * you will end up with

      @params = { :controller => 'store', :action => 'add_to_cart', :id => 123 }

  ### Named Routes

    * Used to be specific about what routes are generated.
    * Use a name other than "connect" to create a named route.

  e.g.

      map.index 'blog/', 'controller' => 'blog', :action => 'index'
