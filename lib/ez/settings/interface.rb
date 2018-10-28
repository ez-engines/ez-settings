require_relative 'interface/group'
require_relative 'interface/key'
require_relative 'store'

require 'ez/configurator'
require 'ez/settings/backend/file_system'
require 'ez/settings/backend/active_record'

module Ez::Settings
  class Interface
    include Ez::Configurator

    configure do |config|
      config.base_controller = 'ApplicationController'
      config.default_path    = '/settings'
      config.backend         = Backend::FileSystem.new('settings.yml')
      config.custom_css_map  = {}
      config.dynamic_css_map = {}
    end

    def self.define(name, &block)
      interface = new(name)
      interface.instance_eval(&block)
      interface
    end

    delegate :config, :configure, to: :class

    attr_reader :name, :groups, :store

    def initialize(name)
      @name = name
      @keys, @groups = [], []
    end

    def define(&block)
      self.instance_eval(&block)
    end

    def group(name, options = {}, &block)
      find_or_initialize_group(name, options, &block)
    end

    def keys
      groups.map(&:keys).flatten
    end

    private

    def find_or_initialize_group(name, options = {}, &block)
      existing_group = groups.find { |g| g.name == name }

      if existing_group
        existing_group.instance_eval(&block)
      else
        add_group(Group.new(name, self.name, options, &block))
      end
    end

    def add_group(group)
      @groups << group

      group
    end
  end
end
