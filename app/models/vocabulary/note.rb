module Vocabulary
  class Note < ApplicationRecord
    self.inheritance_column = :_type_disabled
    TYPES = %w(Scope Definition Example History Editorial Change)

    # has_paper_trail

    belongs_to :creator, class_name: 'User'
    belongs_to :notable, polymorphic: true, touch: true

    validates :type, :body, :language, presence: true

  end
end