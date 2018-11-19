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
    
    validates :type, :inversable, presence: true

    attr_accessor :foreign_concept

    after_create :create_inverse, unless: :has_inverse?
    after_destroy :destroy_inverses, if: :has_inverse?

    scope :broader, -> { where type: 'broader' }
    scope :narrower, -> { where type: 'narrower' }
    scope :close, -> { where type: 'close' }
    scope :exact, -> { where type: 'exact' }
    scope :related, -> { where type: 'related' }

    def foreign_concept
      inversable.try(:to_global_id)
    end

    def foreign_concept=(params)
      gid,name = params.split(',')
      if GlobalID::Locator.locate gid
        self.inversable = GlobalID::Locator.locate(gid)
      else
        hyper_concept = Vocabulary::HyperConcept.create(uri: gid, label: name)
        self.inversable = hyper_concept
      end
    end

    def inverse_type
      case type
      when 'close' then 'close'
      when 'exact' then 'exact'
      when 'related' then 'related'
      when 'broader' then 'narrower'
      when 'narrower' then 'broader'
      end
    end

    def create_inverse
      self.class.create(inverse_match_options.merge(creator: self.creator))
    end
  
    def destroy_inverses
      inverses.destroy_all
    end
  
    def has_inverse?
      self.class.exists?(inverse_match_options)
    end
  
    def inverses
      self.class.where(inverse_match_options)
    end
  
    def inverse_match_options
      { concept: inversable, inversable: concept, type: inverse_type }
    end

  end
end