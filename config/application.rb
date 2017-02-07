require File.expand_path('../boot', __FILE__)
require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    config.autoload_paths += Dir[Rails.root.join('app', 'uploaders')] # ref http://qiita.com/h5y1m141@github/items/97e1941086c7f9f229ac
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
