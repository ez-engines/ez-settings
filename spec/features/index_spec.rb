require 'rails_helper'

RSpec.describe 'Index' do
  subject { page }

  before { visit '/settings' }

  it 'has view elements' do
    is_expected.to have_content 'Ez Settings'

    # Nav links
    within('.ez-settings-nav-menu') do
      is_expected.to have_link 'Ez Settings'
      expect(page.find_link('Ez Settings')[:href]).to eq '/settings'

      is_expected.to have_link 'General'
      expect(page.find_link('General')[:href]).to eq '/settings/general'

      is_expected.to have_link 'Dummy Group'
      expect(page.find_link('Dummy Group')[:href]).to eq '/settings/dummy_group'
    end

    # Overview links
    within('.ez-settings-overview') do
      is_expected.to have_link 'General'
      expect(page.find_link('General')[:href]).to eq '/settings/general'

      is_expected.to have_link 'Dummy Group'
      expect(page.find_link('Dummy Group')[:href]).to eq '/settings/dummy_group'
    end
  end

  it 'redirects to settings page' do
    within('.ez-settings-nav-menu') do
      click_link 'Ez Settings'
    end

    expect(page).to have_current_path '/settings'
  end

  it 'redirects to group page' do
    within('.ez-settings-nav-menu') do
      click_link 'General'
    end

    expect(page).to have_current_path '/settings/general'
  end

  it 'redirects to group page' do
    within('.ez-settings-nav-menu') do
      click_link 'Dummy Group'
    end

    expect(page).to have_current_path '/settings/dummy_group'
  end

  it 'shows suffixes where specified' do
    expect(page).to have_css('.ez-settings-overview-page-cell-with-suffix', count: 1)
    expect(page).to have_css('.ez-settings-overview-page-suffix-label', count: 1)
  end
end
