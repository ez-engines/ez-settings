# frozen_string_literal: true

module Ez
  module Settings
    class SettingsController < Ez::Settings::ApplicationController
      include Ez::Settings::RequestDispatcher

      def index
        view :index
      end

      def show
        render_group(group, group.store(backend))
      end

      def update
        store = group.store(backend).update(params[:settings])

        if store.valid?
          redirect_to interface.config.default_path
        else
          render_group(group, store)
        end
      end

      private

      def render_group(group, store)
        view :group, group, store: store
      end

      def backend
        interface.config.backend
      end
    end
  end
end
