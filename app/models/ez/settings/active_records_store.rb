module Ez
  module Settings
    class ActiveRecordsStore < Ez::Settings::ApplicationRecord
      self.table_name = :ez_settings_store
      validates :key, uniqueness: { scope: :group }
    end
  end
end
