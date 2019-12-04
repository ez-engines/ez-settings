# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Validations' do
  subject { page }

  before do
    visit '/settings/dummy_group'

    fill_in 'Dummy String',          with: ''
    fill_in 'Dummy Integer',         with: ''
    fill_in 'Dummy Not Validate',    with: ''

    click_button 'Save'
  end

  it 'validates presence' do
    is_expected.to have_current_path '/settings/dummy_group'

    expect_an_error     settings_dummy_string:          :blank
    expect_an_error     settings_dummy_integer:         :blank
    expect_not_an_error settings_dummy_not_validate:    :blank
  end
end
