dummy_app = Ez::Settings::Interface.define(:dummy_app) do
  group :general do
    key :app_name
  end

  group :dummy_group do
    key :dummy_string,                        default: -> { 'dummy_string' }
    key :dummy_bool,         type: :boolean,  default: -> { true }
    key :dummy_integer,      type: :integer,  default: -> { 777 }, suffix: 'EUR', min: 0, wrapper: :semantic_right_labeled_input
    key :dummy_select,       type: :select,   default: -> { 'foo' }, collection: %w(foo bar baz)
    key :dummy_not_validate, required: false, presence: false
    key :dummy_not_for_ui,   required: false, ui:       false
  end
end

dummy_app.configure do |config|
  config.file = Rails.root.join('config', 'settings.yml')
end

Ez::Registry.in(:settings_interfaces, by: Dummy) do |registry|
  registry.add dummy_app
end
