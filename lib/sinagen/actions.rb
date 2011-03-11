require 'open-uri'
require 'rbconfig'
require 'active_support/core_ext'

module Actions


  # Adds an entry into Gemfile for the supplied gem. If env
  # is specified, add the gem to the given environment.
  #
  # ==== Example
  #
  #   gem "rspec", :group => :test
  #   gem "technoweenie-restful-authentication", :lib => "restful-authentication", :source => "http://gems.github.com/"
  #   gem "rails", "3.0", :git => "git://github.com/rails/rails"
  #
  def gem(*args)
    options = args.extract_options!
    name, version = args

    # Set the message to be shown in logs. Uses the git repo if one is given,
    # otherwise use name (version).
    parts, message = [ name.inspect ], name
    if version ||= options.delete(:version)
      parts   << version.inspect
      message << " (#{version})"
    end
    message = options[:git] if options[:git]

    log :gemfile, message

    options.each do |option, value|
      parts << ":#{option} => #{value.inspect}"
    end

    puts "root is #{destination_root}"
    in_root do
      append_file "Gemfile", "gem #{parts.join(", ")}\n", :verbose => false
    end
  end

  # Add the given source to Gemfile
  #
  # ==== Example
  #
  #   add_source "http://gems.github.com/"
  def add_source(source, options={})
    log :source, source

    in_root do
      prepend_file "Gemfile", "source #{source.inspect}\n", :verbose => false
    end
  end


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

  # Create a new file in the lib/ directory. Code can be specified
  # in a block or a data string can be given.
  #
  # ==== Examples
  #
  #   lib("crypto.rb") do
  #     "crypted_special_value = '#{rand}--#{Time.now}--#{rand(1337)}--'"
  #   end
  #
  #   lib("foreign.rb", "# Foreign code is fun")
  #
  def lib(filename, data=nil, &block)
    log :lib, filename
    create_file("lib/#{filename}", data, :verbose => false, &block)
  end

  # Create a new Rakefile with the provided code (either in a block or a string).
  #
  # ==== Examples
  #
  #   rakefile("bootstrap.rake") do
  #     project = ask("What is the UNIX name of your project?")
  #
  #     <<-TASK
  #       namespace :#{project} do
  #         task :bootstrap do
  #           puts "i like boots!"
  #         end
  #       end
  #     TASK
  #   end
  #
  #   rakefile("seed.rake", "puts 'im plantin ur seedz'")
  #
  def rakefile(filename, data=nil, &block)
    log :rakefile, filename
    create_file("lib/tasks/#{filename}", data, :verbose => false, &block)
  end


  # Runs the supplied rake task
  #
  # ==== Example
  #
  #   rake("db:migrate")
  #   rake("db:migrate", :env => "production")
  #   rake("gems:install", :sudo => true)
  #
  def rake(command, options={})
    log :rake, command
    env  = options[:env] || 'development'
    sudo = options[:sudo] ? 'sudo ' : ''
    in_root { run("#{sudo}#{extify(:rake)} #{command} RAILS_ENV=#{env}", :verbose => false) }
  end

  # Make an entry in Rails routing file config/routes.rb
  #
  # === Example
  #
  #   route "root :to => 'welcome'"
  #
  def route(routing_code)
    log :route, routing_code
    sentinel = /\.routes\.draw do(?:\s*\|map\|)?\s*$/

    in_root do
      inject_into_file 'config/routes.rb', "\n  #{routing_code}\n", { :after => sentinel, :verbose => false }
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

  protected

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

