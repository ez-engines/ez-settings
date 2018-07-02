module SimpleForm
  module Components
    # Needs to be enabled in order to do automatic lookups
    module Labels
      # Name of the component method
      def left_label(wrapper_options = nil)
        @left_label ||= begin
          options[:left_label].to_s.html_safe if options[:left_label].present?
        end
      end

      # Name of the component method
      def right_label(wrapper_options = nil)
        @right_label ||= begin
          options[:right_label].to_s.html_safe if options[:right_label].present?
        end
      end

      def has_left_label?
        left_label.present?
      end

      def has_right_label?
        right_label.present?
      end
    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Labels)
