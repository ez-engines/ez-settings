require 'json'
require 'redis'
require 'active_support/hash_with_indifferent_access'

module Ez::Settings
  module Backend
    class Redis
      PREFIX = 'ez:settings'

      def initialize(namespace)
        @namespace = namespace
      end

      def read
        value = client.get(key)
        value.nil? ? {} : JSON.parse(value).deep_symbolize_keys
      end

      def write(data)
        new_data = read.merge(data)
        client.set(key, JSON.generate(new_data))
      end

      private

      attr_reader :namespace

      def key
        @key ||= "#{PREFIX}:#{namespace}"
      end

      def client
        @client ||= ::Redis.current
      end
    end
  end
end
