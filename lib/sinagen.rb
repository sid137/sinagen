#!/usr/bin/env ruby
require 'thor'
require 'thor/group'
require 'thor/util'
require 'active_support/inflector'


class Sinagen < Thor::Group
  include Thor::Actions

  argument :name, :type => :string, :desc => "Th app name for your sinatra app"
  desc "Generates a skeleton Sinatra app ready to deploy to heroku"

  source_root File.expand_path('../../templates', __FILE__)
  #    models
  #    db/
  #       migrate/
  def setup
    say "Creating sinatra app #{name}...", :green
    self.destination_root = "#{name}/"
  end 

  def create_root_directory
    template "config.ru"
    template "Gemfile"
    template "application.rb", "#{name}.rb"
  end 

  def install_rspec
    directory "spec" 
    template ".rspec"
    # TODO: Edit to only make sinatra necessary dirs
  end 

  def install_compass
    in_root do
      copy_file "views/stylesheets/main.sass"
      run 'compass init  --quiet --css-dir=public/stylesheets \
      --sass-dir=views/stylesheets --javascripts-dir=public/javascripts \
      --images-dir=public/images -x sass --using blueprint/basic'  
      # TODO: Make quiet
    end
  end 

  def run_bundler
    in_root do
      run 'bundle install'
    end
  end

  def create_git_repository
    in_root do
      template ".gitignore"
      git :init
      run "find . \\( -type d -empty \\) -and \\( -not -regex ./\\.git.* \\) -exec touch {}/.gitignore \\;"
      git :add => "."
      git :commit => "-q -a -m 'Finishing application setup'"
    end
  end

  def finish
    in_root do
      template "README.md"
      readme 'README.md'
      run 'rspec spec/setup_spec.rb'
    end
  end

  private

  # Utility methods stolen from Rails
  #
  # https://github.com/rails/rails/blob/master/railties/lib/rails/generators/actions.rb
  # https://github.com/rails/rails/blob/master/railties/lib/rails/generators/rails/app/app_generator.rb

  # Run a command in git.
  #
  # ==== Examples
  #
  #   git :init
  #   git :add => "this.file that.rb"
  #   git :add => "onefile.rb", :rm => "badfile.cxx"
  #
  def git(command={})
    if command.is_a?(Symbol)
      run "git #{command}"
    else
      command.each do |command, options|
        run "git #{command} #{options}"
      end
    end
  end

  # Reads the given file at the source root and prints it in the console.
  #
  # === Example
  #
  #   readme "README"
  #
  def readme(path)
    log File.read(find_in_source_paths(path))
  end

  # Define log for backwards compatibility. If just one argument is sent,
  # invoke say, otherwise invoke say_status. Differently from say and
  # similarly to say_status, this method respects the quiet? option given.
  #
  def log(*args)
    if args.size == 1
      say args.first.to_s unless options.quiet?
    else
      args << (self.behavior == :invoke ? :green : :red)
      say_status *args
    end
  end
end
