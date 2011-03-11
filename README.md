# Sinagen - A Sinatra app generator

This gem generates an application skeleton for developing Sinatra apps.  The
application can the be uploaded to Heroku for usage


## Installation

    gem install sinagen

## Usage

Create an app folder, where NAME is the project name

    sinagen NAME

## What it does

When you run the sinagen command, it generates a project directory and carries
out the following tasks:

* Creates the root project directory with a NAME.rb sinatra file, a Gemfile, and
  a config.ru file.  The Sinatra app uses a "modular" format (as opposed to a
  Classic top-level format.  See
  [Sinatra Readme: Modular vs. Classic](http://www.sinatrarb.com/intro#Modular%20vs.%20Classic%20Style) for details)


* Sets up Rspec for the Sinatra app to use for development

* Installs the [Compass CSS framework](http://compass-style.org/) for sass and simple css layouts

* Initializes a git repository in the app directory, and makes an initial commit
  of all the files, and creates a .gitignore

* Runs a simple rspec test, spec/setup_spec.rb, to make sure that the setup as gone properly, and
  that the app loads and runs on your system

* runs 'bundle install' to install the necessary gems and generate the
  Gemfile.lock

The **sinagen** command generates the following layout in the project directory
called NAME

    project/
        README.md
        config.rb                # Compass configuration
        config.ru                # For rack
        Gemfile                  # Some basic gems prefilled
        Gemfile.lock
        .git/                   
        .gitignore      
        .rspec                   # Rspec config file
        public/
            images/
            stylesheets/         # CSS files generated from compiled sass
                ie.css
                print.css
                screen.css
                main.css
        spec/
            spec_helper.rb        
            setup_spec.rb        # Test app setup
        .sass-cache              # Compass tmp files, under gitignore
        view/
            stylesheets/
                ie.sass
                print.sass
                screen.sass
                main.sass
                    partials/
                        _base.sass

## The Sinatra App

### This app: 

  - Contains an inline haml layout that loads JQuery from the [oogle CDN](http://code.google.com/apis/libraries/devguide.html#jquery), [HTML5 Shiv](http://code.google.com/p/html5shiv/), and [IE9.js](http://code.google.com/p/ie7-js/) for HTML5 compatibility

  - has Compass configured for css generation.  To generate css run

    compass compile .

  - uses Rspec for testing



## To Deploy

Follow the typical Heroku deployment instructions to deploy to heroku

    heroku create appname

    git push heroku master


## Todo

Alot..


## Limitations

Developed on ruby 1.9.2.  Probably does not work on earlier versions of Ruby

No tests yet

Pre-alpha.... 

== Contributing to sinagen
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2011 Sidney Burks. See LICENSE.txt for
further details.

