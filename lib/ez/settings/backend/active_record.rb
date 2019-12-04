# frozen_string_literal: true

require 'active_record'

module Ez::Settings
  module Backend
    class ActiveRecord
      def read
        return {} unless try_db_connection && check_settings_table

        ActiveRecordStore.all.each_with_object({}) do |settings, hsh|
          hsh[settings.group] ||= {}
          hsh[settings.group][settings.key] = settings.value
        end.deep_symbolize_keys
      end

      def write(data)
        return unless try_db_connection && check_settings_table

        group = data.keys[0]
        pairs = data.values[0]
        existing_settings = ActiveRecordStore.where(group: group, key: pairs.keys)
        pairs.map do |key, value|
          record(existing_settings, key, value) || ActiveRecordStore.new(group: group, key: key, value: value)
        end.each(&:save!)
      end

      private

      def record(existing_settings, key, value)
        record = existing_settings.find { |r| r.key == key.to_s }

        return unless record

        record.tap { |r| r.value = value }
      end

      def try_db_connection
        ::ActiveRecord::Base.connection
      rescue ::ActiveRecord::NoDatabaseError
        message('Database does not exist')
        false
      end

      def check_settings_table
        settings_table = Ez::Settings.config.active_record_table_name || :ez_settings
        if ::ActiveRecord::Base.connection.data_source_exists?(settings_table)
          return true
        end

        message("Table #{settings_table} does not exists. Please, check migrations")
        false
      end

      def message(txt, level = 'WARN')
        STDOUT.puts("[#{level}] Ez::Settings: #{txt}")
      end
    end
  end
end
