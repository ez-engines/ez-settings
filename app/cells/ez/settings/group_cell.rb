module Ez::Settings
  class GroupCell < BaseCell
    form

    property :ui_keys
    option :store

    def form_url
      "#{interface.config.default_path}/#{model.name}"
    end

    def save_button(form)
      form.button :submit,
        t(LABEL, scope:   [SCOPE, INTERFACES, model.interface, ACTIONS, SAVE],
                 default: 'Save'),
        class: css_for(:group_page_actions_save_button)
    end

    def cancel_link
      link_to t(LABEL, scope:   [SCOPE, INTERFACES, model.interface, ACTIONS,CANCEL],
                       default: 'Cancel'),
        interface.config.default_path,
        class: css_for(:group_page_actions_cancel_link)
    end
  end
end
