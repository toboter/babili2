class CreateMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :memberships, id: :uuid do |t|
      t.references :user, foreign_key: true, type: :uuid
      t.references :organization, foreign_key: true, type: :uuid
      t.references :approver, foreign_key: {to_table: :users}, type: :uuid
      t.datetime   :approved_at
      t.boolean    :active, default: true, null: false
      t.string     :role

      t.timestamps
    end
    add_index :memberships, :approved_at
    add_index :memberships, :role
    add_index :memberships, :active
  end
end
