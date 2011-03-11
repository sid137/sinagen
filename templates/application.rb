require 'sinatra/base'
require 'haml'
require 'yaml'
require 'logger'

module <%= name.camelize %>
  class Application < Sinatra::Base
    configure do
      enable :logging, :inline_templates
      set :haml, :format => :html5
      set :app_file, __FILE__
      # Uncomment in order to use custom  error handlers
      #disable :raise_errors
      #disable :show_exceptions
    end

    get '/' do
      haml :index
    end
  end
end

__END__
@@ index
Hello world

@@ layout
!!! 
%html(lang='en')
  %head
    %meta(charset='utf-8')

    %title <%= name.capitalize %>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.min.js"></script>
    <link rel="stylesheet" href="stylesheets/main.css" />

    <!--[if IE]><link href="stylesheets/ie.css" rel="stylesheet" /><![endif]-->
    <!-- HTML5 Shiv http://code.google.com/p/html5shiv/ -->
    <!--[if lt IE 9]> 
    <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script> 
    <script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/IE9.js">IE7_PNG_SUFFIX=".png";</script>
    <![endif]-->

  %body
    #container
      %header
      #main
        = yield
      %footer
