require 'generator_spec'
require 'generators/ez/settings/active_record_migrations_generator'

describe Ez::Settings::ActiveRecordMigrationsGenerator, type: :generator do
  destination File.expand_path('../tmp', __dir__)
  arguments %w[something]

  let(:delay_in_seconds) { 5 }

  before(:all) do
    prepare_destination
    run_generator
  end

  it 'creates a migration for active records store' do
    assert_file "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_ez_settings.rb",
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
