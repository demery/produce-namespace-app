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

* <https://github.com/demery/produce-namespace-app/tarball/0.1-models-1>

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


## Renaming the application


What gives?

The problem is the application is named 'Produce' and this is conflicting with
the Produce namespace. So, let's rename the application to 'Grocer' in all
these files:

	   Rakefile
	   app/views/layouts/application.html.erb
	   config/application.rb
	   config/environment.rb
	   config/environments/development.rb
	   config/environments/production.rb
	   config/environments/test.rb
	   config/initializers/secret_token.rb
	   config/initializers/session_store.rb
	   config/routes.rb

And rename the directory too:

     $ cd ..
     # close all windows, apps etc. touching the produce dir
     $ mv produce grocer
     $ cd grocer

* <https://github.com/demery/produce-namespace-app/tarball/0.2-models-2>

> NOTE: I neglected to change 'Produce' to 'Grocer' in `config.ru` until a
> later commit; you'll need to do that if you want to run the app.

Now rerun the model specs:

     $ rake spec:models
     /Users/doug/.rvm/rubies/ruby-1.9.2-p318/bin/ruby -S rspec ./spec/models/produce/fruit_spec.rb
     .........
     
     Finished in 0.08784 seconds
     9 examples, 0 failures

Excellent. All green.

## Fix the view specs

Let's run the view specs now

     $ rake spec:views
     /Users/doug/.rvm/rubies/ruby-1.9.2-p318/bin/ruby -S rspec ./spec/views/produce/fruits/edit.html.erb_spec.rb ./spec/views/produce/fruits/index.html.erb_spec.rb ./spec/views/produce/fruits/new.html.erb_spec.rb ./spec/views/produce/fruits/show.html.erb_spec.rb
     FFFF
     
     Failures:
     
       1) produce_fruits/edit renders the edit fruit form
          Failure/Error: render
          ActionView::MissingTemplate:
            Missing template produce_fruits/edit with {:handlers=>[:erb, :builder, :coffee], :formats=>[:html, :text, :js, :css, :ics, :csv, :xml, :rss, :atom, :yaml, :multipart_form, :url_encoded_form, :json], :locale=>[:en, :en]}. Searched in:
              * "/Users/doug/code/scratch/grocer/app/views"
          # ./spec/views/produce/fruits/edit.html.erb_spec.rb:13:in `block (2 levels) in <top (required)>'
     
       2) produce_fruits/index renders a list of produce_fruits
          Failure/Error: render
          ActionView::MissingTemplate:
            Missing template produce_fruits/index with {:handlers=>[:erb, :builder, :coffee], :formats=>[:html, :text, :js, :css, :ics, :csv, :xml, :rss, :atom, :yaml, :multipart_form, :url_encoded_form, :json], :locale=>[:en, :en]}. Searched in:
              * "/Users/doug/code/scratch/grocer/app/views"
          # ./spec/views/produce/fruits/index.html.erb_spec.rb:20:in `block (2 levels) in <top (required)>'
     
       3) produce_fruits/new renders new fruit form
          Failure/Error: render
          ActionView::MissingTemplate:
            Missing template produce_fruits/new with {:handlers=>[:erb, :builder, :coffee], :formats=>[:html, :text, :js, :css, :ics, :csv, :xml, :rss, :atom, :yaml, :multipart_form, :url_encoded_form, :json], :locale=>[:en, :en]}. Searched in:
              * "/Users/doug/code/scratch/grocer/app/views"
          # ./spec/views/produce/fruits/new.html.erb_spec.rb:13:in `block (2 levels) in <top (required)>'
     
       4) produce_fruits/show renders attributes in <p>
          Failure/Error: render
          ActionView::MissingTemplate:
            Missing template produce_fruits/show with {:handlers=>[:erb, :builder, :coffee], :formats=>[:html, :text, :js, :css, :ics, :csv, :xml, :rss, :atom, :yaml, :multipart_form, :url_encoded_form, :json], :locale=>[:en, :en]}. Searched in:
              * "/Users/doug/code/scratch/grocer/app/views"
          # ./spec/views/produce/fruits/show.html.erb_spec.rb:13:in `block (2 levels) in <top (required)>'
     
     Finished in 0.07256 seconds
     4 examples, 4 failures
     
     Failed examples:
     
     rspec ./spec/views/produce/fruits/edit.html.erb_spec.rb:12 # produce_fruits/edit renders the edit fruit form
     rspec ./spec/views/produce/fruits/index.html.erb_spec.rb:19 # produce_fruits/index renders a list of produce_fruits
     rspec ./spec/views/produce/fruits/new.html.erb_spec.rb:12 # produce_fruits/new renders new fruit form
     rspec ./spec/views/produce/fruits/show.html.erb_spec.rb:12 # produce_fruits/show renders attributes in <p>
     rake aborted!
     /Users/doug/.rvm/rubies/ruby-1.9.2-p318/bin/ruby -S rspec ./spec/views/produce/fruits/edit.html.erb_spec.rb ./spec/views/produce/fruits/index.html.erb_spec.rb ./spec/views/produce/fruits/new.html.erb_spec.rb ./spec/views/produce/fruits/show.html.erb_spec.rb failed

### Fix the view spec paths

The first problem is that the spec paths are in the form `produce_fruits/edit`:

    describe "produce_fruits/edit" do
    

The should be  in the form `produce/fruits/edit`.  So let's fix that and change
the four view specs in `spec/views/produce/fruits` (`edit`, `index`, `new`, `show`) so
that the describe lines have the forms:

    describe "produce/fruits/ACTION" do

with appropriate values for `ACTION`.

Now running the view specs gives:

     $ rake spec:views
     /Users/doug/.rvm/rubies/ruby-1.9.2-p318/bin/ruby -S rspec ./spec/views/produce/fruits/edit.html.erb_spec.rb ./spec/views/produce/fruits/index.html.erb_spec.rb ./spec/views/produce/fruits/new.html.erb_spec.rb ./spec/views/produce/fruits/show.html.erb_spec.rb
     F.FF
     
     Failures:
     
       1) produce/fruits/edit renders the edit fruit form
          Failure/Error: render
          ActionView::Template::Error:
            undefined method `model_name' for NilClass:Class
          # ./app/views/produce/fruits/_form.html.erb:1:in `_app_views_produce_fruits__form_html_erb__1144309606946020442_70122927594040'
          # ./app/views/produce/fruits/edit.html.erb:3:in `_app_views_produce_fruits_edit_html_erb___3850857416275803114_70122934354380'
          # ./spec/views/produce/fruits/edit.html.erb_spec.rb:13:in `block (2 levels) in <top (required)>'
     
       2) produce/fruits/new renders new fruit form
          Failure/Error: render
          ActionView::Template::Error:
            undefined method `model_name' for NilClass:Class
          # ./app/views/produce/fruits/_form.html.erb:1:in `_app_views_produce_fruits__form_html_erb__1144309606946020442_70122927594040'
          # ./app/views/produce/fruits/new.html.erb:3:in `_app_views_produce_fruits_new_html_erb__2703950448170892510_70122926653260'
          # ./spec/views/produce/fruits/new.html.erb_spec.rb:13:in `block (2 levels) in <top (required)>'
     
       3) produce/fruits/show renders attributes in <p>
          Failure/Error: render
          ActionView::Template::Error:
            undefined method `kind' for nil:NilClass
          # ./app/views/produce/fruits/show.html.erb:5:in `_app_views_produce_fruits_show_html_erb__2956242856153233586_70122926433080'
          # ./spec/views/produce/fruits/show.html.erb_spec.rb:13:in `block (2 levels) in <top (required)>'
     
     Finished in 0.13131 seconds
     4 examples, 3 failures
     
     Failed examples:
     
     rspec ./spec/views/produce/fruits/edit.html.erb_spec.rb:12 # produce/fruits/edit renders the edit fruit form
     rspec ./spec/views/produce/fruits/new.html.erb_spec.rb:12 # produce/fruits/new renders new fruit form
     rspec ./spec/views/produce/fruits/show.html.erb_spec.rb:12 # produce/fruits/show renders attributes in <p>
     rake aborted!
     /Users/doug/.rvm/rubies/ruby-1.9.2-p318/bin/ruby -S rspec ./spec/views/produce/fruits/edit.html.erb_spec.rb ./spec/views/produce/fruits/index.html.erb_spec.rb ./spec/views/produce/fruits/new.html.erb_spec.rb ./spec/views/produce/fruits/show.html.erb_spec.rb failed

That's progress, but we still have a problem.

### Fix view spec `assign` calls

The next problem has to do with divergent view assignment variables between
Rails and rspec. 

Rails assigns fruits to `@produce_fruit`:

    # app/views/produce/fruits/_form.html.erb
    <p>
      <b>Kind:</b>
      <%= @produce_fruit.kind %>
    </p>

The spec generator uses `:fruit`:

    # spec/views/produce/fruits/edit.html.erb_spec.rb
    describe "produce/fruits/edit" do
      before(:each) do
        @fruit = assign(:fruit, stub_model(Produce::Fruit,
          :kind => "MyString",
          :variety => "MyString",
          :quantity => 1
        ))
      end
      # ...
    end

Let's fix the three specs, `show`, `edit`, and `new`, changing `:fruit` to
`:produce_fruit`.  Note that `index` uses the `:produce_fruits` assignment
operator already.

This gets us closer; however, the css matchers in the `edit` and `new` specs do
not work.  Rails is rendering inputs with full, namespaced id's and names,
thus:

      <div class="field">
        <label for="produce_fruit_kind">Kind</label><br />
        <input id="produce_fruit_kind" name="produce_fruit[kind]" size="30" type="text" />
      </div>

The view specs are looking for id's and names **without** the `produce_` prefix:

    assert_select "form", :action => produce_fruits_path(@fruit), :method => "post" do
      assert_select "input#fruit_kind", :name => "fruit[kind]"
      assert_select "input#fruit_variety", :name => "fruit[variety]"
      assert_select "input#fruit_quantity", :name => "fruit[quantity]"
    end


Change the `new` and `edit` specs thus:

    assert_select "form", :action => produce_fruits_path, :method => "post" do
      assert_select "input#produce_fruit_kind", :name => "produce_fruit[kind]"
      assert_select "input#produce_fruit_variety", :name => "produce_fruit[variety]"
      assert_select "input#produce_fruit_quantity", :name => "produce_fruit[quantity]"
    end

Now the specs run:

     $ rake spec:views
     /Users/doug/.rvm/rubies/ruby-1.9.2-p318/bin/ruby -S rspec ./spec/views/produce/fruits/edit.html.erb_spec.rb ./spec/views/produce/fruits/index.html.erb_spec.rb ./spec/views/produce/fruits/new.html.erb_spec.rb ./spec/views/produce/fruits/show.html.erb_spec.rb
     ....
     
     Finished in 0.12522 seconds
     4 examples, 0 failures


* <https://github.com/demery/produce-namespace-app/tarball/0.3-views>

## Controller specs

Before we do anything, we have to fix the controller spec's default attributes
for the Product::Fruit class to work with our validations:

      # spec/controllers/produce/fruits_controller_spec.rb
      def valid_attributes
        {
          kind: 'apple',
          variety: 'fugi'
        }
      end


Now, 10 of the 16 specs fail:

     $ rake spec:controllers
     /Users/doug/.rvm/rubies/ruby-1.9.2-p318/bin/ruby -S rspec ./spec/controllers/produce/fruits_controller_spec.rb
     .FFFFFFF.FF.F...
     
     Failures:
     
       1) Produce::FruitsController GET show assigns the requested fruit as @fruit
          Failure/Error: assigns(:fruit).should eq(fruit)
            
            expected: #<Produce::Fruit id: 1, kind: "apple", variety: "fugi", quantity: nil, created_at: "2012-05-30 22:52:11", updated_at: "2012-05-30 22:52:11">
                 got: nil
            
            (compared using ==)
          # ./spec/controllers/produce/fruits_controller_spec.rb:52:in `block (3 levels) in <top (required)>'
     
       2) Produce::FruitsController GET new assigns a new fruit as @fruit
          Failure/Error: assigns(:fruit).should be_a_new(Produce::Fruit)
            expected nil to be a new Produce::Fruit(id: integer, kind: string, variety: string, quantity: integer, created_at: datetime, updated_at: datetime)
          # ./spec/controllers/produce/fruits_controller_spec.rb:59:in `block (3 levels) in <top (required)>'
     
       3) Produce::FruitsController GET edit assigns the requested fruit as @fruit
          Failure/Error: assigns(:fruit).should eq(fruit)
            
            expected: #<Produce::Fruit id: 1, kind: "apple", variety: "fugi", quantity: nil, created_at: "2012-05-30 22:52:11", updated_at: "2012-05-30 22:52:11">
                 got: nil
            
            (compared using ==)
          # ./spec/controllers/produce/fruits_controller_spec.rb:67:in `block (3 levels) in <top (required)>'
     
       4) Produce::FruitsController POST create with valid params creates a new Produce::Fruit
          Failure/Error: expect {
            count should have been changed by 1, but was changed by 0
          # ./spec/controllers/produce/fruits_controller_spec.rb:74:in `block (4 levels) in <top (required)>'
     
       5) Produce::FruitsController POST create with valid params assigns a newly created fruit as @fruit
          Failure/Error: assigns(:fruit).should be_a(Produce::Fruit)
            expected nil to be a kind of Produce::Fruit(id: integer, kind: string, variety: string, quantity: integer, created_at: datetime, updated_at: datetime)
          # ./spec/controllers/produce/fruits_controller_spec.rb:81:in `block (4 levels) in <top (required)>'
     
       6) Produce::FruitsController POST create with valid params redirects to the created fruit
          Failure/Error: response.should redirect_to(Produce::Fruit.last)
            Expected response to be a <:redirect>, but was <200>
          # ./spec/controllers/produce/fruits_controller_spec.rb:87:in `block (4 levels) in <top (required)>'
     
       7) Produce::FruitsController POST create with invalid params assigns a newly created but unsaved fruit as @fruit
          Failure/Error: assigns(:fruit).should be_a_new(Produce::Fruit)
            expected nil to be a new Produce::Fruit(id: integer, kind: string, variety: string, quantity: integer, created_at: datetime, updated_at: datetime)
          # ./spec/controllers/produce/fruits_controller_spec.rb:96:in `block (4 levels) in <top (required)>'
     
       8) Produce::FruitsController PUT update with valid params updates the requested fruit
          Failure/Error: put :update, {:id => fruit.to_param, :fruit => {'these' => 'params'}}, valid_session
            #<Produce::Fruit:0x007feed4040270> received :update_attributes with unexpected arguments
              expected: ({"these"=>"params"})
                   got: (nil)
          # ./app/controllers/produce/fruits_controller.rb:62:in `block in update'
          # ./app/controllers/produce/fruits_controller.rb:61:in `update'
          # ./spec/controllers/produce/fruits_controller_spec.rb:117:in `block (4 levels) in <top (required)>'
     
       9) Produce::FruitsController PUT update with valid params assigns the requested fruit as @fruit
          Failure/Error: assigns(:fruit).should eq(fruit)
            
            expected: #<Produce::Fruit id: 1, kind: "apple", variety: "fugi", quantity: nil, created_at: "2012-05-30 22:52:12", updated_at: "2012-05-30 22:52:12">
                 got: nil
            
            (compared using ==)
          # ./spec/controllers/produce/fruits_controller_spec.rb:123:in `block (4 levels) in <top (required)>'
     
       10) Produce::FruitsController PUT update with invalid params assigns the fruit as @fruit
          Failure/Error: assigns(:fruit).should eq(fruit)
            
            expected: #<Produce::Fruit id: 1, kind: "apple", variety: "fugi", quantity: nil, created_at: "2012-05-30 22:52:12", updated_at: "2012-05-30 22:52:12">
                 got: nil
            
            (compared using ==)
          # ./spec/controllers/produce/fruits_controller_spec.rb:139:in `block (4 levels) in <top (required)>'
     
     Finished in 0.2105 seconds
     16 examples, 10 failures
     
     Failed examples:
     
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:49 # Produce::FruitsController GET show assigns the requested fruit as @fruit
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:57 # Produce::FruitsController GET new assigns a new fruit as @fruit
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:64 # Produce::FruitsController GET edit assigns the requested fruit as @fruit
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:73 # Produce::FruitsController POST create with valid params creates a new Produce::Fruit
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:79 # Produce::FruitsController POST create with valid params assigns a newly created fruit as @fruit
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:85 # Produce::FruitsController POST create with valid params redirects to the created fruit
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:92 # Produce::FruitsController POST create with invalid params assigns a newly created but unsaved fruit as @fruit
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:110 # Produce::FruitsController PUT update with valid params updates the requested fruit
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:120 # Produce::FruitsController PUT update with valid params assigns the requested fruit as @fruit
     rspec ./spec/controllers/produce/fruits_controller_spec.rb:134 # Produce::FruitsController PUT update with invalid params assigns the fruit as @fruit
     rake aborted!
     /Users/doug/.rvm/rubies/ruby-1.9.2-p318/bin/ruby -S rspec ./spec/controllers/produce/fruits_controller_spec.rb failed
     
     Tasks: TOP => spec:controllers
     (See full trace by running task with --trace)

This can be fixed by changing `:fruit` to `:produce_fruit` in all cases like these:

        put :update, {:id => fruit.to_param, :fruit => {}}, valid_session
        assigns(:fruit).should eq(fruit)

So that the both the parameters posted and the assigns read thus:

        put :update, {:id => fruit.to_param, :produce_fruit => {}}, valid_session
        assigns(:produce_fruit).should eq(fruit)
 
Now running the controller spec, we have:

     $ rake spec:controllers
     /Users/doug/.rvm/rubies/ruby-1.9.2-p318/bin/ruby -S rspec ./spec/controllers/produce/fruits_controller_spec.rb
     ................
     
     Finished in 0.22144 seconds
     16 examples, 0 failures

* <https://github.com/demery/produce-namespace-app/tarball/0.4-controllers>
