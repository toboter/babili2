migration_class =
  if ActiveRecord::VERSION::MAJOR >= 5
    ActiveRecord::Migration[5.1]
  else
    ActiveRecord::Migration
  end

class CreateFriendlyIdSlugs < migration_class
  def change
    create_table :friendly_id_slugs, id: :uuid do |t|
      t.string   :slug,           null: false
      t.uuid     :sluggable_id,   null: false
      t.string   :sluggable_type, limit: 50
      t.string   :scope
      t.datetime :created_at
    end
    add_index :friendly_id_slugs, :sluggable_id
    add_index :friendly_id_slugs, [:slug, :sluggable_type], length: { slug: 140, sluggable_type: 50 }
    add_index :friendly_id_slugs, [:slug, :sluggable_type, :scope], length: { slug: 70, sluggable_type: 50, scope: 70 }, unique: true
    add_index :friendly_id_slugs, :sluggable_type
  end
end