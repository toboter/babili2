class CreateVocabulary < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :concepts_count, :integer

    create_table :vocabulary_concepts, id: :uuid do |t|
      t.references :profile, foreign_key: true, type: :uuid
      t.references :source, foreign_key: {to_table: :vocabulary_concepts}, type: :uuid
      t.references :creator, foreign_key: {to_table: :users}, type: :uuid
      t.string     :type
      t.jsonb      :data
      t.integer    :references_count, default: 0
      t.timestamps
    end
    add_index :vocabulary_concepts, :type
    add_index :vocabulary_concepts, :data, using: :gin

    create_table :vocabulary_states, id: :uuid do |t|
      t.references :concept, foreign_key: {to_table: :vocabulary_concepts}, type: :uuid
      t.references :creator, foreign_key: {to_table: :users}, type: :uuid
      t.string     :type
      t.timestamps
    end
    add_index :vocabulary_states, :type
    
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
      t.string     :label
      t.timestamps
    end
  end
end
