# frozen_string_literal: true

module Ez
  module Settings
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
