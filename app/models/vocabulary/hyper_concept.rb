module Vocabulary
  class HyperConcept < ApplicationRecord
    has_many :labels, as: :labelable, dependent: :destroy
    has_many :relationships, as: :inversable, dependent: :destroy

    validates :uri, presence: true

    def name
      labels.first
    end

    def api_uri
      uri
    end
  end
end