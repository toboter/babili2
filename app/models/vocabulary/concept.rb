module Vocabulary
  class Concept < ApplicationRecord
    self.inheritance_column = :_type_disabled
    TYPES = %w(Concept Collection)

    # searchkick

    belongs_to :creator, class_name: 'Person'
    belongs_to :scheme, counter_cache: true 
      has_one :profile, through: :scheme
    has_many :labels, as: :labelable, dependent: :destroy
    has_many :notes, as: :notable, dependent: :destroy
    # has_many :references, as: :referenceable
    has_many :relationships, dependent: :destroy
      has_many :hyper_concepts, through: :relationships, source: :inverseable, source_type: 'Vocabulary::HyperConcept'
      has_many :local_concepts, through: :relationships, source: :inverseable, source_type: 'Vocabulary::Concept'
      has_many :broader_concepts, -> { where(type: 'broader') }, through: :relationships, source: :inverseable
      has_many :close_concepts, -> { where(type: 'close') }, through: :relationships, source: :inverseable
      has_many :exact_concepts, -> { where(type: 'exact') }, through: :relationships, source: :inverseable
      has_many :narrower_concepts, -> { where(type: 'narrower') }, through: :relationships, source: :inverseable
      has_many :related_concepts, -> { where(type: 'related') }, through: :relationships, source: :inverseable
    has_many :states, dependent: :destroy
      has_one :current_state, -> { order(created_at: :desc).first }, through: :states

    validates :states, :type, :creator, :scheme, :labels, presence: true

    accepts_nested_attributes_for :labels, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :notes, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :relationships, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :states, reject_if: :all_blank, allow_destroy: true

    after_commit :reindex_concept

    # surpress double entries in search, only show the original
    def should_index?
      !matches.where(associatable_type: "Vocab::Concept", property: "exact").exists?
    end

    def search_data
      {
        broader: broader_concepts.map{|b| b.labels.map(&:body).join(' ') },
        narrower: narrower_concepts.map{|n| n.labels.map(&:body).join(' ') },
        scheme: scheme.title,
        labels: labels.map(&:body),
        notes: notes.map(&:body),
        matches: matches.map{|m| [m.property, m.associatable.try(:name)] }
      }
    end

    def reindex_concept
      concept.reindex
    end

    def preferred_label(lang=nil)
      labels.where(type: 'Preferred', language: lang, is_abbrevation: false).first || labels.where(type: 'Preferred', is_abbrevation: false).first
    end

    def name(lang=nil)
      type == 'Collection' ? "<#{preferred_label(lang).try(:body)}>" : preferred_label(lang).try(:body)
    end

    def default_name
      name
    end

    def indent
      ancestor_links.first ? (ancestor_links.first.distance.to_i+1)*17 : 20
    end

    def contributors
      [creator].concat(labels.map(&:creator)).concat(notes.map(&:creator)).flatten.uniq
    end


    def broader_concepts=(ids)
      ids = ids.reject { |c| c.empty? }.split(",").flatten
      parents = Vocab::Concept.find(ids)
      (self.parents - parents).each do |parent_to_remove|
        remove_parent(parent_to_remove)
      end
      self.parents = parents
      unless self.new_record?
        parents.empty? ? self.make_root : ActsAsDAG::HelperMethods.unlink(nil, self)
      end
    end

    def narrower_concepts=(ids)
      ids = ids.reject { |c| c.empty? }.split(",").flatten
      children = Vocab::Concept.find(ids)
      (self.children - children).each do |child_to_remove|
        remove_child(child_to_remove)
        child_to_remove.parents.empty? ? child_to_remove.make_root : ActsAsDAG::HelperMethods.unlink(nil, child_to_remove)
      end
      self.children = children
      children.each do |child|
        ActsAsDAG::HelperMethods.unlink(nil, child)
      end
    end

    def self.sorted_by(sort_option)
      direction = ((sort_option =~ /desc$/) ? 'desc' : 'asc').to_sym
      case sort_option.to_s
      when /^updated_at_/
        { updated_at: direction }
      else
        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
      end
    end

    def self.options_for_sorted_by
      [
        ['Updated asc', 'updated_at_asc'],
        ['Updated desc', 'updated_at_desc']
      ]
    end
  end
end