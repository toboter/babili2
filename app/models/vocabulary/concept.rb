module Vocabulary
  class Concept < ApplicationRecord
    self.inheritance_column = :_type_disabled
    TYPES = %w(Concept Collection)

    # searchkick
    # has paper trail

    include AttrJson::Record
    include AttrJson::NestedAttributes
    include AttrJson::Record::QueryScopes
    attr_json_config(default_container_attribute: :data)
    attr_json :labels, Label.to_type, array: true, rails_attribute: true, accepts_nested_attributes: { reject_if: proc { |attributes| attributes['body'].blank? } }
    attr_json :notes, Note.to_type, array: true, rails_attribute: true, accepts_nested_attributes: { reject_if: proc { |attributes| attributes['body'].blank? } }

    belongs_to :creator, class_name: 'User'
    belongs_to :profile, counter_cache: true 
    # has_many :references, as: :referenceable
    has_many :states, dependent: :destroy
    has_many :relationships, dependent: :destroy
      has_many :local_concepts, as: :inverseable, through: :relationships, dependent: :destroy, source: :inversable, source_type: 'Vocabulary::Concept'
      has_many :narrower_concepts, -> { merge(Vocabulary::Relationship.narrower) }, as: :inverseable, through: :relationships, dependent: :destroy, source: :inversable, source_type: 'Vocabulary::Concept'
      has_many :broader_concepts, -> { merge(Vocabulary::Relationship.broader) }, as: :inverseable, through: :relationships, dependent: :destroy, source: :inversable, source_type: 'Vocabulary::Concept'
      has_many :close_concepts, -> { merge(Vocabulary::Relationship.close) }, as: :inverseable, through: :relationships, dependent: :destroy, source: :inversable, source_type: 'Vocabulary::Concept'
      has_many :exact_concepts, -> { merge(Vocabulary::Relationship.exact) }, as: :inverseable, through: :relationships, dependent: :destroy, source: :inversable, source_type: 'Vocabulary::Concept'
      has_many :related_concepts, -> { merge(Vocabulary::Relationship.related) }, as: :inverseable, through: :relationships, dependent: :destroy, source: :inversable, source_type: 'Vocabulary::Concept'

 
    def root?
      self.in?(self.class.roots)
    end

    scope :roots, -> {
      relationships = Vocabulary::Relationship.arel_table
      concepts = Vocabulary::Concept.arel_table
      where(
        Vocabulary::Relationship \
          .where(relationships[:concept_id].eq(concepts[:id])) \
          .where(relationships[:type].eq('broader')) \
          .exists
          .not
      )
    }

    attr_accessor :current_state

    validates :type, :creator, :labels, presence: true

    accepts_nested_attributes_for :relationships, allow_destroy: true, reject_if: proc { |attributes| attributes['foreign_concept'].blank? }
    accepts_nested_attributes_for :states, reject_if: :all_blank, allow_destroy: true

    def current_state
      states.order(created_at: :desc).first.try(:type) || 'Unstable'
    end

    def current_state=(params)
      self.states.build(params) unless params[:type] == current_state
    end
#    after_commit :reindex_concept
#
#    # surpress double entries in search, only show the original
#    def should_index?
#      !matches.where(associatable_type: "Vocab::Concept", property: "exact").exists?
#    end
#
#    def search_data
#      {
#        broader: broader_concepts.map{|b| b.labels.map(&:body).join(' ') },
#        narrower: narrower_concepts.map{|n| n.labels.map(&:body).join(' ') },
#        scheme: scheme.title,
#        labels: labels.map(&:body),
#        notes: notes.map(&:body),
#        matches: matches.map{|m| [m.property, m.associatable.try(:name)] }
#      }
#    end
#
#    def reindex_concept
#      concept.reindex
#    end

    def preferred_label(lang=nil)
      labels.select{ |l| l.type == 'Preferred' and l.lang == lang and l.abbr == false }.first.presence || labels.select{ |l| l.type == 'Preferred' and l.abbr == false }.first
    end

    def name(lang=nil)
      type == 'Collection' ? "<#{preferred_label(lang).try(:body)}>" : preferred_label(lang).try(:body)
    end

    def definition(lang=nil)
      notes.select{ |n| n.type == 'Definition' and n.lang == lang }.first.try(:body).presence || notes.select{ |n| n.type == 'Definition' }.first.try(:body)
    end

#    def indent
#      ancestor_links.first ? (ancestor_links.first.distance.to_i+1)*17 : 20
#    end
#
#    def contributors
#      [creator].concat(labels.map(&:creator)).concat(notes.map(&:creator)).flatten.uniq
#    end
#
#
#    def self.sorted_by(sort_option)
#      direction = ((sort_option =~ /desc$/) ? 'desc' : 'asc').to_sym
#      case sort_option.to_s
#      when /^updated_at_/
#        { updated_at: direction }
#      else
#        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
#      end
#    end
#
#    def self.options_for_sorted_by
#      [
#        ['Updated asc', 'updated_at_asc'],
#        ['Updated desc', 'updated_at_desc']
#      ]
#    end
  end
end