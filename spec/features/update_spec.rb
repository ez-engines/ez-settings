# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Update' do
  subject { page }
  after { delete_dummy_config_file! }

  before do
    delete_dummy_config_file!

    visit '/settings/dummy_group'

    fill_in 'Dummy String', with: 'New Value for Dummy String'
    uncheck 'Dummy Bool'
    fill_in 'Dummy Integer', with: '666'
    select  'bar', from: 'Dummy Select'
    fill_in 'Dummy Not Validate', with: 'I wanna be validateable'

    click_button 'Save'
  end

  it 'success and updates settings values' do
    expect(page.status_code).to eq 200
    is_expected.to have_current_path '/settings'

    within('.ez-settings-nav-menu') { click_link 'Dummy Group' }

    is_expected.to have_field 'Dummy String', with: 'New Value for Dummy String'
    is_expected.to have_unchecked_field 'Dummy Bool'
    is_expected.to have_field  'Dummy Integer', with: '666'
    is_expected.to have_select 'Dummy Select', selected: 'bar', with_options: %w[foo bar baz]
    is_expected.to have_field  'Dummy Not Validate', with: 'I wanna be validateable'
  end
end
