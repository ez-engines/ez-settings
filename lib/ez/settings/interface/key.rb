module Ez::Settings
  class Interface
    class Key
      attr_reader :name, :group, :interface, :type, :default,
                  :ui, :required, :collection, :options, :suffix, :min

      def initialize(name, params)
        @name       = name
        @group      = params.fetch(:group)
        @interface  = params.fetch(:interface)
        @type       = params.fetch(:type, :string)
        @default    = params.fetch(:default, -> {}).call
        @ui         = params.fetch(:ui, true)
        @required   = params.fetch(:required, true)
        @collection = params.fetch(:collection, [])
        @options    = params.fetch(:options, {})
        @suffix     = params.fetch(:suffix, nil)
        @min        = params.fetch(:min, nil)
      end

      # Alias all boolean-like options to predicates methods, please
      alias_method :ui?,       :ui
      alias_method :required?, :required
    end
  end
end
