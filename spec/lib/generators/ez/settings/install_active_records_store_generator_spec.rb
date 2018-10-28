require 'generator_spec'
require 'generators/ez/settings/install_active_records_store_generator'

describe Ez::Settings::InstallActiveRecordsStoreGenerator, type: :generator do
  destination File.expand_path('../tmp', __dir__)
  arguments %w[something]

  let(:delay_in_seconds) { 5 }

  before(:all) do
    prepare_destination
    run_generator
  end

  it 'creates a migration for active records store' do
    assert_file "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_ez_settings_store.rb",
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
