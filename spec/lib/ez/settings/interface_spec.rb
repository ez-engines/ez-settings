# frozen_string_literal: true

require 'spec_helper'

require 'ez/settings/interface'

RSpec.describe Ez::Settings::Interface do
  let(:test_settings) do
    Ez::Settings::Interface.define :test_settings do
      group :general do
        key :app_name
        key :api_key
        key :api_token
      end

      group :secondary do
        key :redundant_field
      end

      # case of extending
      group :secondary do
        key :extended_filed
      end
    end
  end

  describe '#initialize' do
    it { expect(test_settings).to      be_instance_of described_class }
    it { expect(test_settings.name).to eq :test_settings }
  end

  describe '#config' do
    it { expect(test_settings.config.base_controller).to eq 'ApplicationController' }
    it { expect(test_settings.config.default_path).to    eq '/settings' }
    it { expect(test_settings.config.backend).to         be_instance_of Ez::Settings::Backend::FileSystem }
    it { expect(test_settings.config.backend.file).to    eq 'settings.yml' }
    it { expect(test_settings.config.custom_css_map).to  eq ({}) }
    it { expect(test_settings.config.dynamic_css_map).to eq ({}) }
  end

  describe '#configure' do
    before do
      test_settings.configure do |config|
        config.other_value = 'other value'
      end
    end

    it { expect(test_settings.config.other_value).to eq 'other value' }
  end

  describe '#define' do
    before do
      test_settings.define do
        group :additional_group do
          key :additional_key
        end
      end
    end

    let(:added_group) { test_settings.groups.find { |g| g.name == :additional_group } }

    it { expect(test_settings.groups.map(&:name)).to include(:additional_group) }
    it { expect(added_group.keys.count).to eq 1 }
    it { expect(added_group.keys[0].name).to eq :additional_key }
  end

  def be_group
    be_instance_of Ez::Settings::Interface::Group
  end

  def be_key
    be_instance_of Ez::Settings::Interface::Key
  end

  describe '#groups' do
    it { expect(test_settings.groups.count).to   eq 2 }

    it { expect(test_settings.groups[0]).to      be_group }
    it { expect(test_settings.groups[1]).to      be_group }

    it { expect(test_settings.groups[0].name).to eq :general }
    it { expect(test_settings.groups[1].name).to eq :secondary }

    it { expect(test_settings.groups[1].interface).to eq test_settings.name }
    it { expect(test_settings.groups[1].interface).to eq test_settings.name }
  end

  describe '#groups -> keys' do
    it { expect(test_settings.groups[0].keys.count).to   eq 3 }
    it { expect(test_settings.groups[1].keys.count).to   eq 2 }

    it { expect(test_settings.groups[0].keys[0]).to      be_key }
    it { expect(test_settings.groups[0].keys[1]).to      be_key }
    it { expect(test_settings.groups[0].keys[2]).to      be_key }
    it { expect(test_settings.groups[0].keys[0].name).to eq :app_name }
    it { expect(test_settings.groups[0].keys[1].name).to eq :api_key }
    it { expect(test_settings.groups[0].keys[2].name).to eq :api_token }

    it { expect(test_settings.groups[1].keys[0]).to      be_key }
    it { expect(test_settings.groups[1].keys[0].name).to eq :redundant_field }

    it { expect(test_settings.groups[1].keys[1]).to      be_key }
    it { expect(test_settings.groups[1].keys[1].name).to eq :extended_filed }
  end

  describe '#keys' do
    it { expect(test_settings.keys.count).to eq 5 }
    it { expect(test_settings.keys[0]).to eq test_settings.groups[0].keys[0] }
    it { expect(test_settings.keys[1]).to eq test_settings.groups[0].keys[1] }
    it { expect(test_settings.keys[2]).to eq test_settings.groups[0].keys[2] }
    it { expect(test_settings.keys[3]).to eq test_settings.groups[1].keys[0] }
  end
end
