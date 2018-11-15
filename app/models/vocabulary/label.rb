module Vocabulary
  class Label < ApplicationRecord
    self.inheritance_column = :_type_disabled
    TYPES = %w(Preferred Alternative Hidden)
    VERNACULARS = %w(Vernacular Other Undetermined)
    HISTORICALS = %w(Current Historical Both Unknown NotApplicable)

    belongs_to :creator, class_name: 'Person'
    belongs_to :labelable, polymorphic: true, touch: true

    validates :body, :language, :type, :vernacular, :historical, presence: true
    validates :body, uniqueness: { scope: [:language, :concept_id], 
      message: "should only exist once per concept and language" }

  end
end