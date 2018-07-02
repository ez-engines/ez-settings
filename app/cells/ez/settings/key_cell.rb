module Ez::Settings
  class KeyCell < BaseCell
    form

    option :form

    private

    def html_options
      {
        label:           i18n_key_label(model),
        as:              model.type,
        collection:      model.collection,
        include_blank:   model.default.present?,
        required:        model.required?,
        checked_value:   true.to_s,
        unchecked_value: false.to_s,
        input_html: {
          min: model.min
        }
      }.merge(model.options)
    end
  end
end
