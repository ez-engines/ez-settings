# frozen_string_literal: true

require 'ez/configurator'

module Ez::Settings
  include Ez::Configurator

  configure do |config|
    config.base_controller = 'ApplicationController'
  end
end
