module Vocabulary
  class Scheme < ApplicationRecord
    extend FriendlyId
    friendly_id :abbr, use: [:slugged, :history]

    belongs_to :creator, class_name: 'User'
    belongs_to :profile
    has_many :concepts, dependent: :destroy
    has_many :notes, as: :notable, dependent: :destroy

    validates :abbr, presence: true

    def should_generate_new_friendly_id?
      abbr_changed? || super
    end

    def contributors
      [creator].concat(concepts.map{|c| c.contributors}).compact.flatten.uniq
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