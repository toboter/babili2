module Vocabulary
  class State < ApplicationRecord
    self.inheritance_column = :_type_disabled
    TYPES = %w(Unstable Testing Stable)

    belongs_to :concept, touch: true
    belongs_to :creator, class_name: 'User'

    validates :type, presence: true

  end
end