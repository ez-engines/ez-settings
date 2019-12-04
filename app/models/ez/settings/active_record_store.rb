# frozen_string_literal: true

module Ez
  module Settings
    class ActiveRecordStore < Ez::Settings::ApplicationRecord
      self.table_name = Ez::Settings.config.active_record_table_name || :ez_settings

      validates :key, uniqueness: { scope: :group }
    end
  end
end
