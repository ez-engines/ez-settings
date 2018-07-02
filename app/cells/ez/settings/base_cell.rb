module Ez::Settings
  class BaseCell < Cell::ViewModel
    include RequestDispatcher

    self.view_paths = ["#{Ez::Settings::Engine.root}/app/cells"]

    delegate :t, to: I18n
    delegate :params, :request, to: :controller
    delegate :dynamic_css_map,  to: :'interface.config'

    SCOPE      = 'ez_settings'
    LABEL      = 'label'
    INTERFACES = 'interfaces'
    GROUPS     = 'groups'
    KEYS       = 'keys'
    ACTIONS    = 'actions'
    SAVE       = 'save'
    CANCEL     = 'cancel'

    def self.form
      include ActionView::Helpers::FormHelper
      include SimpleForm::ActionViewExtensions::FormHelper
      include ActionView::RecordIdentifier
      include ActionView::Helpers::FormOptionsHelper
    end

    def self.option(name, default: nil)
      define_method name do
        options[name]
      end
    end

    def css_for(item, dynamic: nil)
      return "ez-settings-defined-#{item}" unless css_map[item]
      return css_map[item] unless dynamic

      if dynamic_css_map.dig(item, :if)&.call(controller, dynamic)
        dynamic_css_map.dig(item, :css_class) + ' ' + css_map[item]
      else
        css_map[item]
      end
    end

    def css_map
      {
        nav_label:                           'ez-settings-nav-label',
        nav_menu:                            'ez-settings-nav-menu',
        nav_menu_item:                       'ez-settings-nav-menu-item',
        overview_page_wrapper:               'ez-settings-overview',
        overview_page_section:               'ez-settings-overview-section',
        overview_page_section_header:        'ez-settings-overview-section-header',
        overview_page_section_content:       'ez-settings-overview-section-content',
        overview_page_section_content_key:   'ez-settings-overview-section-content-key',
        overview_page_section_content_value: 'ez-settings-overview-section-content-value',
        group_page_wrapper:                  'ez-settings-group-wrapper',
        group_page_inner_wrapper:            'ez-settings-group-inner-wrapper',
        group_page_header:                   'ez-settings-group-header',
        group_page_form_wrapper:             'ez-settings-group-form-wrapper',
        group_page_form_inner:               'ez-settings-group-form-inner',
        group_page_form_field_row:           'ez-settings-group-form-field-row',
        group_page_form_string_wrapper:      'ez-settings-group-form-string-wrapper',
        group_page_form_boolean_wrapper:     'ez-settings-group-form-boolean-wrapper',
        group_page_form_select_wrapper:      'ez-settings-group-form-select-wrapper',
        group_page_actions_wrapper:          'ez-settings-group-actions-wrapper',
        group_page_actions_save_button:      'ez-settings-group-actions-save-btn',
        group_page_actions_cancel_link:      'ez-settings-group-actions-cancel-link'
      }.merge(interface.config.custom_css_map)
    end

    def controller
      context[:controller]
    end

    def group_link(group, options = {})
      link_to i18n_group_label(group),
        group_path(group),
        class: css_for(:nav_menu_item, dynamic: "settings/#{group.name}")
    end

    def group_path(group)
      "#{interface.config.default_path}/#{group.name}"
    end

    def i18n_group_label(group)
      t(LABEL, scope:   [SCOPE, INTERFACES, group.interface, GROUPS, group.name],
               default: group.name.to_s.humanize)
    end

    def i18n_key_label(key)
      t(LABEL, scope:   [SCOPE, INTERFACES, key.interface, GROUPS, key.group, KEYS, key.name],
               default: key.name.to_s.humanize)
    end
  end
end
