# What?

This is a toy application  I created to figure out how to user rspec-rails with
a namespaced app.

# What I did

I created an application "produce" with a namespaced scaffold, Produce::Fruit,
to figure out how to test namespaced models, controllers, views, etc. with
rspec.

## Create the application

Created a Rails 3.1 app called produce:

    $ rails new produce --skip-test-unit

## Install rspec and factory\_girl

Added `rspec-rails` and `factory_girl_rails` to my `Gemfile`:

    group :development, :test do
      gem 'rspec-rails'
      gem 'factory_girl_rails'
    end

Ran `bundle` to get it all in place.

Installed rspec:

    $ rails g rspec:install

## Create a scaffold for Produce::Fruit

Generated a scaffold for Produce::Fruit:

    $ rails g scaffold Produce::Fruit kind:string variety:string quantity:integer 

Migrated and cloned the database:

    $ rake db:migrate db:test:clone

## Run rspec the first time

Ran rspec:

    $ bundle exec rspec

The result:

     Finished in 0.05994 seconds
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

## Change 1: Model spec

Fruit needs some validations to test:


    # app/models/produce/fruit.rb
    class Produce::Fruit < ActiveRecord::Base
      attr_accessible :variety, :kind, :quantity
    
      validates_presence_of :kind
      validates_presence_of :variety
      validates_uniqueness_of :kind
    end

And create a standard model spec:

    # spec/models/produce/fruit_spec.rb
    require 'spec_helper'
    
    module Produce
      describe Fruit do
        def valid_attributes
          @valid_attributes ||= {
            kind: "apple",
            variety: "Gala",
            quantity: 3
          }
        end
    
        # ------------------------------------------------------------
        # initialization
        # ------------------------------------------------------------
        context "(initialization)" do
          it "is valid" do
            Produce::Fruit.new(valid_attributes).should be_valid
          end
    
          it "creates a Fruit" do
            Produce::Fruit.create!(valid_attributes).should be_a(Fruit)
          end
    
          it "has a factory" do
            Factory(:produce_fruit).should be_a(Fruit)
          end
        end # context "(initialization)"
    
        # ------------------------------------------------------------
        # attributes
        # ------------------------------------------------------------
        context "(attributes)" do
          it "has a kind" do
            Produce::Fruit.new(kind: (kind = "apple")).kind.should eq(kind)
          end
    
          it "has a variety" do
            Produce::Fruit.new(variety: (variety = "gala")).variety.should eq(variety)
          end
    
          it "has a quantity" do
            Produce::Fruit.new(quantity: (quantity = 3)).quantity.should eq(quantity)
          end
        end # context "(attributes)"
    
        # ------------------------------------------------------------
        # validations
        # ------------------------------------------------------------
        context "(validations)" do
          it "requires kind" do
            Produce::Fruit.new(kind: nil).should have(1).error_on(:kind)
          end
    
          it "requires variety" do
            Produce::Fruit .new(variety: nil).should have(1).error_on(:variety)
          end
    
          it "requires a kind be unique" do
            Produce::Fruit.create!(valid_attributes)
            Produce::Fruit.new(valid_attributes).should have(1).error_on(:kind)
          end
        end # context "(validations)"
      end
    end

And this doesn't work, because the application can't find the table named
`fruits`.  It can't find the table, because the table is named
`produce_fruits`.  The method `Produce::Fruits.table_name` should return
`produce_fruits` but it doesn't.  The Produce module defines the prefix
correctly:

    # app/models/produce.rb
    module Produce
      def self.table_name_prefix
        'produce_'
      end
    end

But the module doesn't even seem to have the method `table_name_prefix`:

     1.9.2p318 :013 > Produce.table_name_prefix
     NoMethodError: undefined method `table_name_prefix' for Produce:Module
     	from (irb):13
     	from /Users/doug/.rvm/gems/ruby-1.9.2-p318@produce/gems/railties-3.1.4/lib/rails/commands/console.rb:45:in `start'
     	from /Users/doug/.rvm/gems/ruby-1.9.2-p318@produce/gems/railties-3.1.4/lib/rails/commands/console.rb:8:in `start'
     	from /Users/doug/.rvm/gems/ruby-1.9.2-p318@produce/gems/railties-3.1.4/lib/rails/commands.rb:40:in `<top (required)>'
     	from script/rails:6:in `require'
     	from script/rails:6:in `<main>'
     1.9.2p318 :014 > 
