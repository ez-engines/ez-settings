# frozen_string_literal: true

require 'generator_spec'
require 'generators/ez/settings/install_generator'

describe Ez::Settings::InstallGenerator, type: :generator do
  destination File.expand_path('../tmp', __dir__)
  arguments %w[something]

  before(:all) do
    prepare_destination
    run_generator
  end

  it 'creates a config initializer' do
    assert_file 'config/initializers/ez_settings.rb', "# By default engine try to inherit from ApplicationController, but you could change this:
# Ez::Settings.config.base_controller = 'Admin::BaseController'
#
# Then you should define settings interfaces (you can create as much as you need)
# Ierachy is pretty simple: Interface -> Group -> Key
#
# Interface DSL allows you to do this very declaratively
#
app = Ez::Settings::Interface.define :app do         # :app - interface name
  group :general do                                  # :general - name of the group
    key :app_title, default: -> { 'Main app title' } # :app_title - key name for store value in :general group for :app interface
  end

  # And so on...
  group :admin do
    key :app_title, default: -> { 'Admin app title' }
  end

  # If you want to see all power of the engine, add this showcase:
  group :showcase do
    key :string,                        default: -> { 'simple string' }
    key :bool,         type: :boolean,  default: -> { true }
    key :integer,      type: :integer,  default: -> { 777 }
    key :select,       type: :select,   default: -> { 'foo' }, collection: %w(foo bar baz)
    key :not_validate, required: false, presence: false
    key :not_for_ui,   required: false, ui:       false
  end
  # Keys could have:
  # :type (string by default), now ez-settings supports only: string, boolean, integer and select
  # :default value (as callable objects)
  # :required - be or not (all keys are required by default)
  # :ui visible or not (all keys are UI visible by default)
end

# After defining settings interface groups/keys you need to configure it:
app.configure do |config|
  # Backend adapter to store all settings
  config.backend = Ez::Settings::Backend::FileSystem.new(Rails.root.join('config', 'settings.yml'))
  # Redis is also supported:
  # config.backend = Ez::Settings::Backend::Redis.new('config')

  # Default path for redirect in controller
  config.default_path = '/admin/settings'

  # Pass your custom css classes through css_map config
  # Defaults would be merged with yours:
  # config.custom_css_map  = {
  #   nav_label:                           'ez-settings-nav-label',
  #   nav_menu:                            'ez-settings-nav-menu',
  #   nav_menu_item:                       'ez-settings-nav-menu-item',
  #   overview_page_wrapper:               'ez-settings-overview',
  #   overview_page_section:               'ez-settings-overview-section',
  #   overview_page_section_header:        'ez-settings-overview-section-header',
  #   overview_page_section_content:       'ez-settings-overview-section-content',
  #   overview_page_section_content_key:   'ez-settings-overview-section-content-key',
  #   overview_page_section_content_value: 'ez-settings-overview-section-content-value',
  #   group_page_wrapper:                  'ez-settings-group-wrapper',
  #   group_page_inner_wrapper:            'ez-settings-group-inner-wrapper',
  #   group_page_header:                   'ez-settings-group-header',
  #   group_page_form_wrapper:             'ez-settings-group-form-wrapper',
  #   group_page_form_inner:               'ez-settings-group-form-inner',
  #   group_page_form_field_row:           'ez-settings-group-form-field-row',
  #   group_page_form_string_wrapper:      'ez-settings-group-form-string-wrapper',
  #   group_page_form_boolean_wrapper:     'ez-settings-group-form-boolean-wrapper',
  #   group_page_form_select_wrapper:      'ez-settings-group-form-select-wrapper',
  #   group_page_actions_wrapper:          'ez-settings-group-actions-wrapper',
  #   group_page_actions_save_button:      'ez-settings-group-actions-save-btn',
  #   group_page_actions_cancel_link:      'ez-settings-group-actions-cancel-link'
  # }
  #
  # Highly recommend inspecting settings page DOM.
  # You can find there a lot of interesting id/class stuff
  #
  # You even can define dynamic map for allows to decide which CSS class could be added
  # `if` must contain callable object that receives controller as a first argument and dynamic element as second one:
  #
  # In this example, you easily could add 'active' CSS class if route end with some fragment:
  # config.dynamic_css_map = {
  #   nav_menu_item: {
  #     css_class: 'active',
  #     if: ->(controller, path_fragment) { controller.request.path.end_with?(path_fragment.to_s) }
  #   }
  # }
end

# Register `app` variable as settings interface
Ez::Registry.in(:settings_interfaces, by: 'YourAppName') do |registry|
  registry.add app
end"
  end

  it 'creates a I18n yaml file' do
    assert_file 'config/locales/ez_settings.en.yml', "en:
  ez_settings:
    label: Ez Settings
    interfaces:
      app:
        label: App Settings
        actions:
          save:
            label: Update
          cancel:
            label: Cancel
        groups:
          general:
            label: General
            description: General settings of your application
          admin:
            label: Admin
            description: Admin area settings
          showcase:
            label: Showcase
            description: Just an example of possible settings UI elements
            keys:
              string:
                label: String
              bool:
                label: Bool
              integer:
                label: Integer
              select:
                label: Select
              not_validate:
                label: Not Validate
              not_for_ui:
                label: Not For UI
        "
  end
end
