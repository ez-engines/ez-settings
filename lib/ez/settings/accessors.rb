module Ez::Settings
  NotRegistredInterfaceError = Class.new(StandardError)
  NotRegistredGroupError     = Class.new(StandardError)
  NotRegistredKeyError       = Class.new(StandardError)

  module Accessors
    def [](interface_name, group_name = nil, key_name = nil)
      interface = interface(interface_name)

      not_registered_interface!(interface_name) unless interface

      if only_interface?(interface, group_name, key_name)
        interface.groups
      else
        group = group(interface, group_name)

        not_registered_group!(interface_name, group_name) unless group

        if interface_and_group?(interface, group_name, key_name)
          group(interface, group_name).keys
        else
          begin
            store(interface, group).send(key_name.to_sym)
          rescue NoMethodError
            not_registered_key!(interface_name, group_name, key_name)
          end
        end
      end
    end
  end

  private_class_method def self.interface(interface_name)
    Ez::Registry.data(:settings_interfaces).find do |interface|
      interface.name == interface_name.to_sym
    end
  end

  private_class_method def self.group(interface, group_name)
    interface.groups.find { |g| g.name == group_name.to_sym }
  end

  private_class_method def self.store(interface, group)
    Ez::Settings::Store.new(group, interface.config.backend)
  end

  private_class_method def self.only_interface?(interface, group_name, key_name)
    interface && group_name.nil? && key_name.nil?
  end

  private_class_method def self.interface_and_group?(interface, group_name, key_name)
    interface && group_name && key_name.nil?
  end

  private_class_method def self.not_registered_interface!(interface_name)
    raise NotRegistredInterfaceError, "Interface #{interface_name} is not registred!"
  end

  private_class_method def self.not_registered_group!(interface_name, group_name)
    raise NotRegistredGroupError, "Group #{group_name} is not registred for #{interface_name} interface"
  end

  private_class_method def self.not_registered_key!(interface_name, group_name, key_name)
    raise NotRegistredKeyError, "Key #{key_name} is not registred for #{interface_name} interface, #{group_name} group"
  end
end
