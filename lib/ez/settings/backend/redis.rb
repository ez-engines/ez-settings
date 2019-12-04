# frozen_string_literal: true

require 'json'
require 'active_support/hash_with_indifferent_access'

module Ez::Settings
  module Backend
    class Redis
      PREFIX = 'ez:settings'
      NAMESPACE = 'config'

      attr_reader :connection, :namespace

      def initialize(connection, namespace: NAMESPACE)
        @connection = connection
        @namespace = namespace
      end

      def read
        value = connection.get(key)
        value.nil? ? {} : JSON.parse(value).deep_symbolize_keys
      end

      def write(data)
        new_data = read.merge(data)
        connection.set(key, JSON.generate(new_data))
      end

      private

      def key
        @key ||= "#{PREFIX}:#{namespace}"
      end
    end
  end
end
