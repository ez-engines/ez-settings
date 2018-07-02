# Ez::Settings

[![Gem Version](https://badge.fury.io/rb/ez-settings.svg)](https://badge.fury.io/rb/ez-settings)
[![Build Status](https://travis-ci.org/ez-engines/ez-settings.svg?branch=master)](https://travis-ci.org/ez-engines/ez-settings)

**Ez Settings** (read as "easy settings") - one of the [ez-engines](https://github.com/ez-engines) collection that helps easily add settings interface to your [Rails](http://rubyonrails.org/) application.

- Flexible tool with simple DSL
- Convetion over configuration principles.
- Depends on [ez-core](https://github.com/ez-engines/ez-core)

If you are boring to read all this stuff maybe this video motivates you:

[YouTube demonstrates how easy we integrated ez-settings for our pivorak-web-app only by ±50 lines of code](https://www.youtube.com/watch?v=TiX0QDHEaKA&feature=youtu.be)

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'ez-settings', '~> 0.1'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install ez-settings
```

and `bundle install`

### Initialize

`rails generate ez:settings:install`

Generates initializer config file and I18n yaml file with english keys

`config/ez_settings.rb`
```ruby
# By default engine try to inherit from ApplicationController, but you could change this:
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
  group :showcase, on_change: ->(changes) { YourHandler.call(changes) } do
    key :string,                        default: -> { 'simple string' }
    key :bool,         type: :boolean,  default: -> { true }
    key :integer,      type: :integer,  default: -> { 777 }, min: 0, suffix: 'USD', wrapper: :custom_wrapper
    key :select,       type: :select,   default: -> { 'foo' }, collection: %w(foo bar baz)
    key :not_validate, required: false, presence: false
    key :not_for_ui,   required: false, ui:       false
  end
  # Group could have:
  # :on_change - closure to call after the group is changed
  # Keys could have:
  # :type (string by default), now ez-settings supports only: string, boolean, integer and select
  # :default value (as callable objects)
  # :required - be or not (all keys are required by default)
  # :ui visible or not (all keys are UI visible by default)
  # :min - the minimum value for the element
  # :suffix - unit of measurement
  # :wrapper - custom wrapper for simple_form
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

# Ez::Settings uses Ez::Registry from ez-core lib for storing all knowledges in one place.
# This place is registry records for :settings_interfaces registry
#
# Register `app` variable as settings interface
Ez::Registry.in(:settings_interfaces, by: 'YourAppName') do |registry|
  registry.add app
end
```

### Routes
`config/routes.rb`

```ruby
Rails.application.routes.draw do
  # your routes code before

  # We recommend to hide settings into admin area
  authenticate :user, ->(u) { u.admin? } do
    namespace :admin do
      # :app just interface name as you registred it in Ez::Registry
      ez_settings_for :app
    end
  end

  # more your routes after
end
```

This routes setup allows you to have routes like:

`rake routes | grep settings`
```
 admin_ez_settings          /admin/settings  Ez::Settings::Engine {:interface=>:app}

  root GET  /                 ez/settings/settings#index
       GET  /:group(.:format) ez/settings/settings#show
       PUT  /:group(.:format) ez/settings/settings#update
```

In case of example above you could route:
```
GET      /admin/settings/         - overview page for all :app interface settings
GET/PUT: /admin/settings/general  - general group settings
GET/PUT: /admin/settings/admin    - admin group settings
GET/PUT: /admin/settings/showcase - showcase group settings
```

### Settings accessors
To access your settings use template `Ez::Settings['interface', 'group', 'key']`.

Access interface:
```ruby
Ez::Settings[:app]
#=> <Ez::Settings::Interface:0x007ff1ea7d3168 @groups=[...], @keys=[], @name=:app>
```

Access group:
```ruby
Ez::Settings[:app, :general]
#=> <Ez::Settings::Interface::Group:0x007ff1ea7d2f88 @interface=:app, @keys=[...], @name=:general, @options={}>
```

Access setting value:
```ruby
Ez::Settings[:app, :general, :app_title]
# => 'Main app title'
```

In the case of missing interface/group/key you will receive one of exceptions:
```
NotRegistredInterfaceError
NotRegistredGroupError
NotRegistredKeyError
```

Be careful ;)

### I18n

By default, all interfaces/groups/keys name would be humanized, but in fact, it tries to get translations from YAML first.

If you need, create locale file with this structure:

`config/locales/ez-settings.en.yml`
```yaml
  en:
    ez_settings:
      label: Ez Settings
      interfaces:
        app:
          label: App Settings
          actions:
            save:
              label: Save Settings
            cancel:
              label: Cancel Settings
          groups:
            general:
              label: General
            admin:
              label: Admin
            showcase:
              label: Showcase
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
```

## TODO
This features will be implemented in upcoming 0.2 and 0.3 releases:
- JSON API endpoints and `ez_settings_api_for` routes helper
- Scoped settings (`:scope_id`, `:scope_type`)
- controller before actions as configured callbacks (for external usage)
- Interface description (and show at UI)
- Groups description (and show at UI)
- Keys description (and show at UI)
- Database storage as backend (ActiveRecord)
- UI frameworks adapters: bootsrap3, bootstrap4, foundation, semantic, etc.

## Contributing
Fork => Fix => MR warmly welcomed!

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
