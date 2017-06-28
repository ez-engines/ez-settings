module Ez::Settings
  NotRegistredInterfaceError = Class.new(StandardError)
  NotRegistredGroupError     = Class.new(StandardError)
  NotRegistredKeyError       = Class.new(StandardError)

  module Accessors
    def [](interface_name, group_name, key_name)
      interface = Ez::Registry.data(:settings_interfaces).find do |interface|
        interface.name == interface_name.to_sym
      end

      unless interface
        raise NotRegistredInterfaceError, "Interface #{interface_name} is not registred!"
      end

      group = interface.groups.find { |g| g.name == group_name.to_sym }

      unless group
        raise NotRegistredGroupError, "Group #{group_name} is not registred for #{interface_name} interface"
      end

      store = Ez::Settings::Store.new(group, interface.config.backend)

      begin
        store.send(key_name.to_sym)
      rescue NoMethodError
        raise NotRegistredKeyError, "Key #{key_name} is not registred for #{interface_name} interface, #{group_name} group"
      end
    end
  end
end
