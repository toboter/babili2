# t.references :labelable, polymorphic: true, type: :uuid
# t.references :creator, foreign_key: {to_table: :users}, type: :uuid
# t.string     :type
# t.string     :vernacular
# t.string     :historical
# t.string     :body
# t.string     :language
# t.boolean    :abbrevation

module Vocabulary
  class Label
    include AttrJson::Model, AttrJson::Model::CocoonCompat
    attr_json :type, :string
    attr_json :vernacular, :string
    attr_json :historical, :string
    attr_json :body, :text
    attr_json :lang, :string
    attr_json :abbr, :boolean

    TYPES = %w(Preferred Alternative Hidden)
    VERNACULARS = %w(Vernacular Other Undetermined)
    HISTORICALS = %w(Current Historical Both Unknown NotApplicable)

    validates :body, :lang, :type, :vernacular, :historical, presence: true

  end
end