require_relative 'key'
require_relative '../store'

module Ez::Settings
  class Interface
    class Group
      OverwriteKeyError = Class.new(StandardError)

      attr_reader :name, :options, :keys, :store, :interface

      def initialize(name, interface, options = {}, &block)
        @name      = name
        @interface = interface
        @options   = options
        @keys      = []

        instance_eval(&block)
      end

      def key(key_name, params = {})
        prevent_key_rewrite!(key_name)

        keys << Interface::Key.new(key_name, params.merge(group: name, interface: interface))
        keys
      end

      def ui_keys
        keys.select(&:ui?)
      end

      def store(backend)
        Ez::Settings::Store.new(self, backend, options)
      end

      private

      def prevent_key_rewrite!(key_name)
        return unless keys.map(&:name).include?(key_name)

        raise OverwriteKeyError, "Key #{key_name} already registred in #{name} group"
      end
    end
  end
end
