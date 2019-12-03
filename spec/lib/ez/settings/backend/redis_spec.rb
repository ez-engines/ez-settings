require 'ez/settings/backend/redis'

require 'fakeredis'

describe Ez::Settings::Backend::Redis do
  let(:fake_connection) { Redis.current }

  describe '#read' do
    context 'configuration does not exist' do
      it 'returns empty hash' do
        expect(described_class.new(fake_connection).read).to eq({})
      end
    end

    context 'configuration exists' do
      before do
        described_class.new(fake_connection).write(a: 1, b: 'abc', c: true)
      end

      it 'returns configuration hash' do
        expect(described_class.new(fake_connection).read).to eq(a: 1, b: 'abc', c: true)
      end
    end

    context 'different configuration exists' do
      before do
        described_class.new(fake_connection, namespace: 'test').write(a: 1, b: 'abc', c: true)
      end

      it 'returns empty hash' do
        expect(described_class.new(fake_connection).read).to eq({})
      end
    end
  end

  describe '#write' do
    subject { described_class.new(fake_connection) }

    context 'configuration hash exists' do
      it 'should merge new and existing configurations' do
        subject.write(name: 'John Doe')
        subject.write(age: 35)
        subject.write(single: false)

        expect(subject.read).to eq(
          name:   'John Doe',
          age:    35,
          single: false
        )
      end
    end
  end
end
