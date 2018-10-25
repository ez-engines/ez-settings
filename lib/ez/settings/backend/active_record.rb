module Ez::Settings
  module Backend
    class ActiveRecord
      def read
        ActiveRecordsStore.all.each_with_object({}) do |settings, hsh|
          hsh[settings.group] ||= {}
          hsh[settings.group][settings.key] = settings.value
        end.deep_symbolize_keys
      end

      def write(data)
        group = data.keys[0]
        pairs = data.values[0]
        existing_settings = ActiveRecordsStore.where(group: group, key: pairs.keys)
        pairs.map do |key, value|
          record(existing_settings, key, value) || ActiveRecordsStore.new(group: group, key: key, value: value)
        end.each(&:save!)
      end

      private

      def record(existing_settings, key, value)
        record = existing_settings.find { |r| r.key == key.to_s }

        return unless record

        record.tap { |r| r.value = value }
      end
    end
  end
end
