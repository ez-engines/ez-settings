module Ez::Settings
  class InstallActiveRecordsStoreGenerator < Rails::Generators::Base
    def create_migration
      create_file "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_ez_settings_store.rb",
        "class CreateEzSettingsStore < ActiveRecord::Migration[5.0]
  def change
    create_table :ez_settings_store do |t|
      t.string :group
      t.string :key
      t.string :value

      t.timestamps
    end

    add_index :ez_settings_store, [:key, :group], unique: true
  end
end
"
    end
  end
end
