module Ez
  module Settings
    module RequestDispatcher
      # should implement :params

      def interface
        # TODO: add raise exception in nil
        Ez::Registry.data(:settings_interfaces).find do |interface|
          interface.name ==  params[:interface].to_sym
        end
      end

      def group
        # TODO: add raise exception if nil
        interface.groups.find { |g| g.name == params[:group].to_sym }
      end
    end
  end
end
