require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require *Rails.groups(:assets) if defined?(Bundler)

module Bootstrap
  class Application < Rails::Application

    # make sure the log directory is set up
    puts `mkdir -p ./log`
    puts `touch ./log/#{Rails.env}.log`

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths += %W(#{config.root}/app/jobs)
    config.autoload_paths += %W(#{config.root}/app/bots)
    config.autoload_paths += %W(#{config.root}/lib)

    # removes mongo for heroku precompile
    require "ext/precompile_hack"

    # Enable the asset pipeline
    config.assets.enabled = true
    config.assets.precompile << '*.js'
    config.assets.precompile << '*.css'

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # disable mongoid preloading
    config.mongoid.preload_models = false

    # checks to see if we're on a mobile device
    config.middleware.use "Rack::MobileDetect"
    config.middleware.use "Rack::Deflater"

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = Settings.default_time_zone

    config.action_mailer.default_url_options = { :host => Settings.email_host }

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation, ]

    # configure generators for mongoid/rspec
    config.generators do |g|
      g.orm             :mongoid
      g.test_framework  :rspec, :fixtures => true
      g.integration_tool :rspec
      g.fixture_replacement :fabrication, :dir => "db/fabricators"
    end

  end
end
