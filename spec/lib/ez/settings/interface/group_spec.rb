require 'ez/settings/interface/group'

RSpec.describe Ez::Settings::Interface::Group do
  let(:double_interface) { double Ez::Settings::Interface, name: :test }
  let(:dummy_backend)    { double :dummy_backend, read: {} }

  let(:test_group) do
    described_class.new(:test_group, double_interface.name, some: :option) do
      key :first_test_key
      key :second_first_test_key, ui: false
    end
  end

  describe '#initialize' do
    context 'unique keys' do
      it { expect(test_group).to be_instance_of described_class }
      it { expect(test_group.name).to eq :test_group }
      it { expect(test_group.interface).to eq double_interface.name }
      it { expect(test_group.keys.count).to eq 2 }
      it { expect(test_group.keys[0]).to be_instance_of Ez::Settings::Interface::Key }
      it { expect(test_group.keys[0].interface).to eq double_interface.name }
      it { expect(test_group.keys[1]).to be_instance_of Ez::Settings::Interface::Key }
      it { expect(test_group.ui_keys).to eq [test_group.keys[0]] }
      it { expect(test_group.store(dummy_backend)).to be_instance_of Ez::Settings::Store }
    end

    context 'repeat key' do
      it 'raise exception' do
        expect {
          test_group.instance_eval { key :first_test_key }
        }.to raise_exception(Ez::Settings::Interface::Group::OverwriteKeyError)
      end
    end
  end
end
