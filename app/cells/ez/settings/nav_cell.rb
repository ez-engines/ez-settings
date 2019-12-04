# frozen_string_literal: true

module Ez::Settings
  class NavCell < BaseCell
    def nav_label
      t(LABEL, scope: SCOPE, default: 'Settings')
    end

    def settings_link
      link_to nav_label,
              interface.config.default_path,
              class: css_for(:nav_menu_item, dynamic: 'settings/')
    end
  end
end
