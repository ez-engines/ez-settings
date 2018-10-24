module Ez::Settings
  module Backend
    class ActiveRecord
      def read
        hash = {}
        ActiveRecordsStore.all.each do |settings|
          hash[settings.group] ||= {}
          hash[settings.group].merge!(settings.key => settings.value)
        end
        hash.deep_symbolize_keys
      end

      def write(data)
        group = data.keys[0]
        pairs = data.values[0]
        existing_settings = ActiveRecordsStore.where(group: group, key: pairs.keys)
        records = pairs.map do |pair|
          record(existing_settings, pair) || ActiveRecordsStore.new(group: group, key: pair[0], value: pair[1])
        end
        records.each(&:save!)
      end

      private

      def record(existing_settings, pair)
        record = existing_settings.find { |r| r.key == pair[0].to_s }
        return if record.nil?
        record.tap { |r| r.value = pair[1] }
      end
    end
  end
end
