# frozen_string_literal: true

class ActionDispatch::Routing::Mapper
  def ez_settings_for(interface)
    defaults ez_settings_interface: interface do
      mount Ez::Settings::Engine, at: '/settings', as: :ez_settings
    end
  end
end
