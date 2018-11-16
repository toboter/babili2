# t.references :notable, polymorphic: true, type: :uuid
# t.references :creator, foreign_key: {to_table: :users}, type: :uuid
# t.string     :type
# t.text       :body
# t.string     :language

module Vocabulary
  class Note
    include AttrJson::Model, AttrJson::Model::CocoonCompat
    attr_json :type, :string
    attr_json :body, :text
    attr_json :lang, :string

    TYPES = %w(Scope Definition Example History Editorial Change)

    validates :type, :body, :lang, presence: true

  end
end