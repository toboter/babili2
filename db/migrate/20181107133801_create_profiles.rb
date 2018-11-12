class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles, id: :uuid do |t|
      t.references :owner, polymorphic: true, type: :uuid
      t.string :slug
      t.string :namespace
      t.string :name
      t.string :location
      t.string :url
      t.text :about
      t.text :avatar_data

      t.timestamps
    end
    add_index :profiles, :slug, unique: true
    add_index :profiles, :namespace, unique: true
  end
end
