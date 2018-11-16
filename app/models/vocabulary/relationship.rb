# t.references :concept, foreign_key: {to_table: :vocabulary_concepts}, type: :uuid
# t.references :creator, foreign_key: {to_table: :users}, type: :uuid
# t.string     :type
# t.references :inversable, polymorphic: true, type: :uuid, index: { name: 'index_vocabulary_relationships_on_inverseable' } # entweder hyper_concept oder concept

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