# frozen_string_literal: true

require 'ez/settings/backend/file_system'

RSpec.describe Ez::Settings::Backend::FileSystem do
  subject { described_class.new 'settings.yml' }

  describe '#read' do
    context 'no file' do
      before { allow(File).to receive(:exist?) { false } }

      it { expect(subject.read).to eq({}) }
    end

    context 'with file' do
      let(:params) { { 'a' => 'a', 'b' => 'b' } }

      before do
        allow(File).to receive(:exist?) { true }
        allow(YAML).to receive(:load_file).with('settings.yml').and_return(params)
      end

      it 'loads yaml file' do
        expect(YAML).to receive(:load_file).with('settings.yml')

        subject.read
      end

      it { expect(subject.read).to eq(a: 'a', b: 'b') }
    end

    describe '#write' do
      context 'existing data in file' do
        let(:params) { { a: 'a', c: 'c', b: 'b' } }

        before { allow(subject).to receive(:read) { { a: 'not a', c: 'c' } } }

        it 'read, merge and write new data' do
          expect(File).to receive(:write).with('settings.yml', params.deep_stringify_keys.to_yaml)

          subject.write(params)
        end
      end

      context 'no file or empty' do
        let(:params) { { a: 'a', b: 'b' } }

        it 'read, merge and write new data' do
          expect(File).to receive(:write).with(any_args)

          subject.write(params)
        end
      end
    end
  end
end
