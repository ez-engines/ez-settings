require 'spec_helper'

require 'ez/settings/config'

RSpec.describe Ez::Settings do
  let(:config) { Ez::Settings.config }

  describe '#config' do
    context 'default configuration' do
      it { expect(config.base_controller).to eq 'ApplicationController' }
    end
  end
end
