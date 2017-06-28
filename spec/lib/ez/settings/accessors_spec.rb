require 'rails_helper'

require 'ez/settings'

RSpec.describe Ez::Settings::Accessors do
  let(:test_settings) do
    Ez::Settings::Interface.define :test_settings do
      group :general do
        key :app_name
        key :api_key
      end

      group :secondary do
        key :redundant_field
      end
    end
  end

  before do
    Ez::Registry.in(:settings_interfaces, by: RSpec) do |registry|
      registry.add test_settings
    end
  end

  it { expect(Ez::Settings[:test_settings, :general, :app_name]).to          be_nil }
  it { expect(Ez::Settings[:test_settings, :general, :api_key]).to           be_nil }
  it { expect(Ez::Settings[:test_settings, :secondary, :redundant_field]).to be_nil }

  it { expect{ Ez::Settings[:not_registred_interface, :not_defined_group, :not_defined_key]}.to raise_error Ez::Settings::NotRegistredInterfaceError }
  it { expect{ Ez::Settings[:test_settings, :not_defined_group, :not_defined_key]}.to raise_error Ez::Settings::NotRegistredGroupError }
  it { expect{ Ez::Settings[:test_settings, :general, :not_defined_key]}.to raise_error Ez::Settings::NotRegistredKeyError }
end
