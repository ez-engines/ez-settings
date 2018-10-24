require 'ez/settings/backend/active_record'

RSpec.describe Ez::Settings::Backend::ActiveRecord do
  subject { described_class.new }

  describe '#read' do
    context 'configuration does not exist' do
      it 'returns empty relation' do
        expect(described_class.new.read).to eq({})
      end
    end

    context 'configuration exists' do
      before do
        described_class.new.write(abc: { new: 42 })
      end

      it 'returns configuration hash' do
        expect(described_class.new.read).to eq(abc: { new: '42' })
      end
    end
  end

  describe '#write' do
    subject { described_class.new }

    context 'configuration hash exists' do
      it 'should merge new and existing configurations' do
        subject.write(awesome_group: { simple: 'or not' })
        subject.write(awesome_group: { hard: 'handle that' })
        subject.write(awesome_group: { hard: 'just run' })
        expect(subject.read).to eq(
          awesome_group: {
            simple: 'or not',
            hard: 'just run'
          }
        )
      end
    end
  end
end
