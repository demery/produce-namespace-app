# What?

This is a toy application  I created to figure out how to user rspec-rails with
a namespaced app.

# What I did

Created a Rails 3.1 app called produce:

    $ rails new produce --skip-test-unit

Added `rspec-rails` and `factory_girl_rails` to my `Gemfile`:

    group :development, :test do
      gem 'rspec-rails'
      gem 'factory_girl_rails'
    end

Ran `bundle` to get it all in place.

Installed rspec:

    $ rails g rspec:install

Generated a scaffold for Produce::Fruit:

    $ rails g scaffold Produce::Fruit kind:string variety:string quantity:integer 

Migrated and cloned the database:

    $ rake db:migrate db:test:clone

Ran rspec:

    $ rake rspec

The result:

     Finished in 0.06602 seconds
     30 examples, 28 failures, 2 pending
     
     Failed examples:
     
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:38 # Produce::FruitsController GET index assigns all produce_fruits as @produce_fruits
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:46 # Produce::FruitsController GET show assigns the requested fruit as @fruit
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:54 # Produce::FruitsController GET new assigns a new fruit as @fruit
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:61 # Produce::FruitsController GET edit assigns the requested fruit as @fruit
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:70 # Produce::FruitsController POST create with valid params creates a new Produce::Fruit
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:76 # Produce::FruitsController POST create with valid params assigns a newly created fruit as @fruit
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:82 # Produce::FruitsController POST create with valid params redirects to the created fruit
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:89 # Produce::FruitsController POST create with invalid params assigns a newly created but unsaved fruit as @fruit
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:96 # Produce::FruitsController POST create with invalid params re-renders the 'new' template
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:107 # Produce::FruitsController PUT update with valid params updates the requested fruit
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:117 # Produce::FruitsController PUT update with valid params assigns the requested fruit as @fruit
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:123 # Produce::FruitsController PUT update with valid params redirects to the fruit
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:131 # Produce::FruitsController PUT update with invalid params assigns the fruit as @fruit
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:139 # Produce::FruitsController PUT update with invalid params re-renders the 'edit' template
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:150 # Produce::FruitsController DELETE destroy destroys the requested fruit
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:157 # Produce::FruitsController DELETE destroy redirects to the produce_fruits list
     rspec ./spec/requests/produce/produce_fruits_spec.rb:5 # Produce::Fruits GET /produce_fruits works! (now write some real specs)
     rspec ./spec/routing/produce/fruits_routing_spec.rb:6 # Produce::FruitsController routing routes to #index
     rspec ./spec/routing/produce/fruits_routing_spec.rb:10 # Produce::FruitsController routing routes to #new
     rspec ./spec/routing/produce/fruits_routing_spec.rb:14 # Produce::FruitsController routing routes to #show
     rspec ./spec/routing/produce/fruits_routing_spec.rb:18 # Produce::FruitsController routing routes to #edit
     rspec ./spec/routing/produce/fruits_routing_spec.rb:22 # Produce::FruitsController routing routes to #create
     rspec ./spec/routing/produce/fruits_routing_spec.rb:26 # Produce::FruitsController routing routes to #update
     rspec ./spec/routing/produce/fruits_routing_spec.rb:30 # Produce::FruitsController routing routes to #destroy
     rspec ./spec/views/produce/fruits/edit.html.erb_spec.rb:12 # produce_fruits/edit renders the edit fruit form
     rspec ./spec/views/produce/fruits/index.html.erb_spec.rb:19 # produce_fruits/index renders a list of produce_fruits
     rspec ./spec/views/produce/fruits/new.html.erb_spec.rb:12 # produce_fruits/new renders new fruit form
     rspec ./spec/views/produce/fruits/show.html.erb_spec.rb:12 # produce_fruits/show renders attributes in <p>
     rake aborted!
     /Users/doug/.rvm/rubies/ruby-1.9.2-p318/bin/ruby -S rspec ./spec/controllers/produce/fruits_controller_spec.rb ./spec/helpers/produce/fruits_helper_spec.rb ./spec/models/produce/fruit_spec.rb ./spec/requests/produce/produce_fruits_spec.rb ./spec/routing/produce/fruits_routing_spec.rb ./spec/views/produce/fruits/edit.html.erb_spec.rb ./spec/views/produce/fruits/index.html.erb_spec.rb ./spec/views/produce/fruits/new.html.erb_spec.rb ./spec/views/produce/fruits/show.html.erb_spec.rb failed
     
     
