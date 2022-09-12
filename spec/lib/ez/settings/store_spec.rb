# frozen_string_literal: true

require 'spec_helper'

require 'ez/settings/store'
require 'ez/settings/interface'
require 'ez/settings/backend/file_system'

RSpec.describe Ez::Settings::Store do
  let(:test_settings) do
    Ez::Settings::Interface.define :test_settings do
      group :general do
        key :app_name, default: -> { 'Test App' }
        key :api_key
        key :api_token, required: false
      end

      group :secondary do
        key :redundant_field
      end
    end
  end

  let(:file_backend) { Ez::Settings::Backend::FileSystem.new('settings.yml') }

  let(:general_store)   { described_class.new(test_settings.groups[0], file_backend) }
  let(:secondary_store) { described_class.new(test_settings.groups[1], file_backend) }

  after { File.delete(file_backend.file) if File.exist?(file_backend.file) }

  describe '#initialize' do
    context 'general_store' do
      it { expect(general_store.group).to       eq test_settings.groups[0] }
      it { expect(general_store.backend).to     be_instance_of Ez::Settings::Backend::FileSystem }
      it { expect(general_store.keys).to        eq general_store.keys }
      it { expect(general_store.app_name).to    eq 'Test App' }
      it { expect(general_store.api_key).to     be_nil }
      it { expect(general_store.api_token).to   be_nil }
      it { expect { general_store.not_defined }.to raise_exception(NoMethodError) }
    end

    context 'secondary_store' do
      it { expect(secondary_store.group).to_not   eq general_store.group }
      it { expect(secondary_store.backend).to     be_instance_of Ez::Settings::Backend::FileSystem }
      it { expect(secondary_store.keys).to        eq secondary_store.keys }
      it { expect(secondary_store.keys).to        eq secondary_store.keys }
      it { expect { secondary_store.not_defined }.to raise_exception(NoMethodError) }
    end
  end

  describe '#validate' do
    context 'invalid' do
      before { general_store.validate }

      it { expect(general_store.errors).to_not be_empty }
      it { expect(general_store.errors.key?(:api_key)).to be true }
      it { expect(general_store.errors[:api_key]).to eq ["can't be blank"] }
    end
  end

  describe '#errors' do
    it { expect(general_store.errors).to be_instance_of ActiveModel::Errors }
    it { expect(general_store.errors).to be_empty }
  end

  describe '#valid?' do
    it { expect(general_store).to be_valid }
  end

  describe '#invalid?' do
    before { general_store.errors.add(:base, 'errors') }

    it { expect(general_store).to be_invalid }
  end

  describe '#schema' do
    before do
      allow(general_store.backend).to receive(:read).and_return({})
      general_store.update(app_name: 'New Value', api_key: 'Api Key', api_token: 'Api token')
    end

    it { expect(general_store.schema).to eq ({ general: { app_name: 'New Value', api_key: 'Api Key', api_token: 'Api token' } }) }
  end

  describe '#update' do
    let(:key) { SecureRandom.hex(16) }

    it 'works' do
      expect(general_store.backend).to receive(:write).with(general: { app_name: 'Test App', api_key: key, api_token: nil })

      general_store.update(api_key: key)
    end

    it 'calls on_change with changes if present' do
      general_store.instance_variable_set(:@on_change, proc {})

      expect(general_store.on_change).to receive(:call).with(api_key: key)

      general_store.update(api_key: key)
    end
  end
end
