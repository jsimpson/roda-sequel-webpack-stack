# frozen_string_literal: true

begin
  require_relative '.env.rb'
rescue LoadError
  $stderr.warn 'No environment file.'
end

require 'roda'

Dir['./lib/helpers/*.rb'].sort.each { |file| require file }

# :nodoc:
class App < Roda
  include WebpackHelper

  plugin :default_headers,
    'Content-Type' => 'text/html',
    'X-Frame-Options' => 'deny',
    'X-Content-Type-Options' => 'nosniff',
    'X-XSS-Protection' => '1; mode=block'

  plugin :content_security_policy do |csp|
    csp.default_src :none
    csp.style_src :self, 'https://maxcdn.bootstrapcdn.com'
    csp.form_action :self
    csp.script_src :self
    csp.connect_src :self
    csp.base_uri :none
    csp.frame_ancestors :none
  end

  plugin :route_csrf
  plugin :flash
  plugin :assets, css: 'app.scss', css_opts: { style: :compressed, cache: false }, timestamp_paths: true
  plugin :render, escape: true, layout: './layout'
  plugin :view_options
  plugin :public
  plugin :hash_routes

  logger = if ENV['RACK_ENV'] == 'test'
             Class.new { def write(_) end }.new
           else
             $stderr
           end
  plugin :common_logger, logger

  plugin :not_found do
    @page_title = 'File Not Found'
    view(content: '')
  end

  if ENV['RACK_ENV'] == 'development'
    plugin :exception_page

    # :nodoc:
    class RodaRequest
      def assets
        exception_page_assets
        super
      end
    end
  end

  plugin :error_handler do |e|
    case e
    when Roda::RodaPlugins::RouteCsrf::InvalidToken
      @page_title = 'Invalid Security Token'
      response.status = 400
      view(content: '<p>An invalid security token was submitted with this request, and this request could not be processed.</p>')
    else
      $stderr.print "#{e.class}: #{e.message}\n"
      $stderr.puts e.backtrace

      next exception_page(e, assets: true) if ENV['RACK_ENV'] == 'development'

      @page_title = 'Internal Server Error'
      view(content: '')
    end
  end

  plugin :sessions,
    key: '_App.session',
    secret: ENV.send((ENV['RACK_ENV'] == 'development' ? :[] : :delete), 'APP_SESSION_SECRET')

  route do |r|
    r.public

    r.root do
      view :root
    end
  end
end
