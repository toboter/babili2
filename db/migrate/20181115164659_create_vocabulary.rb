class CreateVocabulary < ActiveRecord::Migration[5.2]
  def change
    create_table :vocabulary_schemes, id: :uuid do |t|
      t.references :profile, foreign_key: true, type: :uuid
      t.references :creator, foreign_key: {to_table: :users}, type: :uuid
      t.string     :abbr
      t.string     :name
      t.string     :slug
      t.integer    :concepts_count
      t.timestamps
    end
    add_index :vocabulary_schemes, :slug, unique: true
    add_index :vocabulary_schemes, :abbr

    create_table :vocabulary_concepts, id: :uuid do |t|
      t.references :scheme, foreign_key: {to_table: :vocabulary_schemes}, type: :uuid
      t.string     :type
      t.integer    :references_count
      t.timestamps
    end
    add_index :vocabulary_concepts, :type

    create_table :vocabulary_states, id: :uuid do |t|
      t.references :concept, foreign_key: {to_table: :vocabulary_concepts}, type: :uuid
      t.references :creator, foreign_key: {to_table: :users}, type: :uuid
      t.string     :state
      t.timestamps
    end
    add_index :vocabulary_states, :state
    
    create_table :vocabulary_labels, id: :uuid do |t|
      t.references :labelable, polymorphic: true, type: :uuid
      t.references :creator, foreign_key: {to_table: :users}, type: :uuid
      t.string     :type
      t.string     :vernacular
      t.string     :historical
      t.string     :body
      t.string     :language
      t.boolean    :abbrevation
      t.timestamps
    end
    add_index :vocabulary_labels, :type

    create_table :vocabulary_notes, id: :uuid do |t|
      t.references :notable, polymorphic: true, type: :uuid
      t.references :creator, foreign_key: {to_table: :users}, type: :uuid
      t.string     :type
      t.text       :body
      t.string     :language
      t.timestamps
    end
    add_index :vocabulary_notes, :type

    create_table :vocabulary_relationships, id: :uuid do |t|
      t.references :concept, foreign_key: {to_table: :vocabulary_concepts}, type: :uuid
      t.references :creator, foreign_key: {to_table: :users}, type: :uuid
      t.string     :type
      t.references :inversable, polymorphic: true, type: :uuid, index: { name: 'index_vocabulary_relationships_on_inverseable' } # entweder hyper_concept oder concept
      t.timestamps
    end
    add_index :vocabulary_relationships, :type

    create_table :vocabulary_hyper_concepts, id: :uuid do |t|
      t.string     :uri
      t.timestamps
    end
  end
end
