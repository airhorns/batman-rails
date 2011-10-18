# Batman-Rails

Easily setup and use batman.js (0.7.0) with rails 3.1

## Rails 3.1 setup
This gem requires the use of rails 3.1, coffeescript and the new rails asset pipeline provided by sprockets.

This gem vendors the latest version of batman.js for Rails 3.1 and greater. The files will be added to the asset pipeline and available for you to use. 
    
### Installation

In your Gemfile, add this line:

    gem "batman-rails"
  
Then run the following commands:

    bundle install
    rails g batman:install

### Layout and namespacing

Running `rails g batman:install` will create the following directory structure under `app/assets/javascripts/`:
  
    controllers/
    models/
    helpers/
    
It will also create a toplevel app_name.coffee file to setup namespacing and setup initial requires.
    
## Generators
batman-rails provides 3 simple generators to help get you started using batman.js with rails 3.1. 
The generators will only create client side code (javascript).

### Model Generator

    rails g batman:model
    
This generator creates a batman model and collection inside `app/assets/javascript/models` to be used to talk to the rails backend.

### Controllers
    
    rails g batman:controller
    
This generator creates a batman controller for the given actions provided.

### Scaffolding

    rails g batman:scaffold
    
This generator creates a controller, helper and mode to create a simple crud single page app

## Example Usage

Created a new rails 3.1 application called `blog`.

    rails new blog

Edit your Gemfile and add

    gem 'batman-rails'

Install the gem and generate scaffolding.

    bundle install
    rails g batman:install
    rails g scaffold Post title:string content:string
    rake db:migrate
    rails g batman:scaffold Post title:string content:string
    
You now have installed the batman-rails gem, setup a default directory structure for your frontend batman code. 
Then you generated the usual rails server side crud scaffolding and finally generated batman.js code to provide a simple single page crud app.
You have one last step:
