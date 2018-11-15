module Vocabulary
  class Relationship < ApplicationRecord
    self.inheritance_column = :_type_disabled
    TYPES = %w(close exact related broader narrower)

    belongs_to :concept, touch: true
    belongs_to :creator, class_name: 'User'
    belongs_to :inversable, polymorphic: true, touch: true
    
    validates :property, :associatable, presence: true

    attr_accessor :associated_concept
    def associated_concept
      associatable
    end

    def associated_concept=(params)
      gid,name = params.split(',')
      if GlobalID::Locator.locate gid
        self.associatable = GlobalID::Locator.locate(gid)
      else
        ext_concept = Vocab::ExternalConcept.create(uri: gid, label: name)
        self.associatable = ext_concept
      end
    end

  end
end