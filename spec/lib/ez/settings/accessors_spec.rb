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

  context 'interface, group & key are specified' do
    it { expect(Ez::Settings[:test_settings, :general, :app_name]).to          be_nil }
    it { expect(Ez::Settings[:test_settings, :general, :api_key]).to           be_nil }
    it { expect(Ez::Settings[:test_settings, :secondary, :redundant_field]).to be_nil }

    it 'raises error if interface is not registered' do
      expect{ Ez::Settings[:not_registred_interface, :not_defined_group, :not_defined_key] }
        .to raise_error Ez::Settings::NotRegistredInterfaceError
    end

    it 'raises error if group is not registered' do
      expect{ Ez::Settings[:test_settings, :not_defined_group, :not_defined_key] }
        .to raise_error Ez::Settings::NotRegistredGroupError
    end

    it 'raises error if key is not registered' do
      expect{ Ez::Settings[:test_settings, :general, :not_defined_key] }
        .to raise_error Ez::Settings::NotRegistredKeyError
    end
  end

  context 'only interface is specified' do
    it 'returns interface' do
      expect(Ez::Settings[:test_settings]).to      be_an(Ez::Settings::Interface)
      expect(Ez::Settings[:test_settings].name).to eq :test_settings
    end

    it 'raises error if interface is not registered' do
      expect{ Ez::Settings[:not_registred_interface] }
        .to raise_error Ez::Settings::NotRegistredInterfaceError
    end
  end

  context 'only interface & group are specified' do
    it 'returns group' do
      expect(Ez::Settings[:test_settings, :general]).to be_an(Ez::Settings::Interface::Group)
      expect(Ez::Settings[:test_settings, :general].name).to eq :general
    end

    it 'raises error if interface is not registered' do
      expect{ Ez::Settings[:not_registred_interface, :general] }
        .to raise_error Ez::Settings::NotRegistredInterfaceError
    end

    it 'raises error if group is not registered' do
      expect{ Ez::Settings[:test_settings, :not_defined_group] }
        .to raise_error Ez::Settings::NotRegistredGroupError
    end
  end
end
