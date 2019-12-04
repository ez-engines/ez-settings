# frozen_string_literal: true

require 'yaml'
require 'active_support/hash_with_indifferent_access'

module Ez::Settings
  module Backend
    class FileSystem
      attr_reader :file

      def initialize(file)
        @file = file
      end

      def read
        return {} unless File.exist?(file)

        YAML.load_file(file).deep_symbolize_keys
      end

      def write(data)
        File.write(file, read.merge(data).deep_stringify_keys.to_yaml)
      end
    end
  end
end
