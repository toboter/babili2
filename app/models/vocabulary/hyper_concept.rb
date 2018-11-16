module Vocabulary
  class HyperConcept < ApplicationRecord
    has_many :relationships, as: :inversable, dependent: :destroy

    validates :uri, presence: true

    def name
      label
    end

    def api_uri
      uri
    end
  end
end