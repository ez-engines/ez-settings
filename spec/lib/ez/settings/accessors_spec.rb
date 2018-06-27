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
    it 'returns interface groups' do
      expect(Ez::Settings[:test_settings].count).to   eq 2
      expect(Ez::Settings[:test_settings]).to         all be_an(Ez::Settings::Interface::Group)
      expect(Ez::Settings[:test_settings][0].name).to eq :general
      expect(Ez::Settings[:test_settings][1].name).to eq :secondary
    end

    it 'raises error if interface is not registered' do
      expect{ Ez::Settings[:not_registred_interface] }
        .to raise_error Ez::Settings::NotRegistredInterfaceError
    end
  end

  context 'only interface & group are specified' do
    it 'returns group keys' do
      expect(Ez::Settings[:test_settings, :general].count).to   eq 2
      expect(Ez::Settings[:test_settings, :general]).to         all be_an(Ez::Settings::Interface::Key)
      expect(Ez::Settings[:test_settings, :general][0].name).to eq :app_name
      expect(Ez::Settings[:test_settings, :general][1].name).to eq :api_key
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
