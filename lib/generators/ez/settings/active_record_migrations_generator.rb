# frozen_string_literal: true

module Ez::Settings
  class ActiveRecordMigrationsGenerator < Rails::Generators::Base
    def create_migration
      create_file "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_ez_settings.rb",
                  "class CreateEzSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :ez_settings do |t|
      t.string :group, null: false
      t.string :key, null: false
      t.string :value, null: false

      t.timestamps
    end

    add_index :ez_settings, :key
    add_index :ez_settings, :group
    add_index :ez_settings, [:key, :group], unique: true
  end
end
"
    end
  end
end
