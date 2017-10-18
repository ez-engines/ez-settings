module Ez
  module Settings
    module RequestDispatcher
      # should implement :params

      def interface
        return unless params[:ez_settings_interface]

        # TODO: add raise exception in nil
        Ez::Registry.data(:settings_interfaces).find do |interface|
          interface.name ==  params[:ez_settings_interface].to_sym
        end
      end

      def group
        return unless interface

        # TODO: add raise exception if nil
        interface.groups.find { |g| g.name == params[:group].to_sym }
      end
    end
  end
end
