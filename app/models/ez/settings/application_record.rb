module Ez
  module Settings
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
