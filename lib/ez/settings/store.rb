require 'active_model'

require 'ez/settings/config'

module Ez::Settings
  class Store
    delegate :keys, to: :group

    attr_reader :group, :errors, :backend

    def initialize(group, backend)
      @group   = group
      @errors  = ActiveModel::Errors.new(self)
      @backend = backend

      define_accessors

      keys.each { |key| default_or_exists_value(data, key) }
    end

    def validate
      @errors = ActiveModel::Errors.new(self)

      group.keys.select(&:required?).each do |key|
        errors.add(key.name, "can't be blank") if self.send(key.name).blank?
      end
    end

    def valid?
      errors.empty?
    end

    def invalid?
      !valid?
    end

    def update(params)
      params.each { |key, value| self.public_send("#{key}=", value) }

      validate
      return self unless errors.empty?

      backend.write(schema)

      self
    end

    def schema
      {
        group.name => group.keys.map(&:name).each_with_object({}) do |key_name, schema|
          schema[key_name] = send(key_name)
        end
      }
    end

    private

    def default_or_exists_value(from_data, key)
      value = from_data[key.name].nil? ? key.default : from_data[key.name]

      public_send("#{key.name}=", value)
    end

    def data
      @data ||= backend.read[group.name] || {}
    end

    def define_accessors
      group.keys.map(&:name).each do |name|
        define_singleton_method(name) do
          instance_variable_get("@#{name}")
        end

        define_singleton_method("#{name}=") do |value|
          instance_variable_set("@#{name}", value)
        end
      end
    end
  end
end
