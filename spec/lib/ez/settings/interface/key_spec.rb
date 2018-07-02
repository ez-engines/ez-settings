require 'ez/settings/interface/key'

RSpec.describe Ez::Settings::Interface::Key do
  describe '#initialize' do
    context 'defaults' do
      let(:default_key) { described_class.new(:default_key, group: double(:group), interface: double(:interface)) }

      it { expect(default_key).to            be_instance_of described_class }
      it { expect(default_key.name).to       eq :default_key }
      it { expect(default_key.type).to       eq :string }
      it { expect(default_key.group).to_not  be_nil }
      it { expect(default_key.interface).to_not  be_nil }
      it { expect(default_key.default).to    be_nil }
      it { expect(default_key.ui).to         eq true }
      it { expect(default_key.required).to   eq true }
      it { expect(default_key.collection).to eq [] }
      it { expect(default_key.options).to    eq({}) }
      it { expect(default_key.suffix).to     be_nil }
    end

    context 'custom' do
      let(:custom_key) do
        described_class.new(:custom_key,
          group:      double(:group),
          interface:  double(:interface),
          type:       :my_type,
          default:    -> { 'My Default' },
          ui:         false,
          required:   false,
          collection: %i[yes no],
          options:    { some: :option },
          suffix:     'EUR',
          min:        2
        )
      end

      it { expect(custom_key).to            be_instance_of described_class }
      it { expect(custom_key.name).to       eq :custom_key }
      it { expect(custom_key.type).to       eq :my_type }
      it { expect(custom_key.default).to    eq 'My Default' }
      it { expect(custom_key.ui).to         eq false }
      it { expect(custom_key.required).to   eq false }
      it { expect(custom_key.collection).to eq  %i[yes no] }
      it { expect(custom_key.options).to    eq({ some: :option }) }
      it { expect(custom_key.suffix).to     eq 'EUR' }
      it { expect(custom_key.min).to        eq 2 }
    end
  end
end
