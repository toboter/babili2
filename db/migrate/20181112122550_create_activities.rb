# Migration responsible for creating a table with activities
class CreateActivities < (ActiveRecord.version.release() < Gem::Version.new('5.2.0') ? ActiveRecord::Migration : ActiveRecord::Migration[5.2])
  # Create table
  def self.up
    create_table :activities, id: :uuid do |t|
      t.references :trackable, polymorphic: true, type: :uuid
      t.references :owner, polymorphic: true, type: :uuid
      t.string     :key
      t.text       :parameters
      t.references :recipient, polymorphic: true, type: :uuid
      
      t.timestamps
    end
  end

  # Drop table
  def self.down
    drop_table :activities
  end
end
