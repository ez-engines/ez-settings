# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Form' do
  subject { page }

  after { delete_dummy_config_file! }

  before do
    delete_dummy_config_file!

    visit '/settings/dummy_group'
  end

  it 'has form elements' do
    # Title
    is_expected.to have_content 'Settings'
    is_expected.to have_content 'Dummy Group'

    # String field
    is_expected.to have_css 'label', text: 'Dummy String'
    is_expected.to have_field 'Dummy String', with: 'dummy_string'

    # Checkbox
    is_expected.to have_css 'label', text: 'Dummy Bool'
    is_expected.to have_checked_field 'Dummy Bool'

    # Integer field
    is_expected.to have_css 'label', text: 'Dummy Integer'
    is_expected.to have_field 'Dummy Integer', with: '777', minimum: '0'

    within('.ui.right.labeled.input') do
      is_expected.to have_css '.ui.basic.label'
    end

    # Select field
    is_expected.to have_css 'label', text: 'Dummy Select'
    is_expected.to have_select 'Dummy Select', selected: 'foo', with_options: %w[foo bar baz]

    # Non validation field
    is_expected.to have_css 'label', text: 'Dummy Not Validate'
    is_expected.to have_field 'Dummy Not Validate'

    # Non UI field
    is_expected.not_to have_css 'label', text: 'Dummy Not For UI'
    is_expected.not_to have_field 'Dummy Not For UI'

    # Actions
    is_expected.to have_button 'Save Dummy Settings'
    is_expected.to have_link 'Cancel Dummy Settings'
  end
end
