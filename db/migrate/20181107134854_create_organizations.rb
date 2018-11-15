class CreateOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :organizations, id: :uuid do |t|
      t.references :creator, foreign_key: {to_table: :users}, type: :uuid

      t.timestamps
    end
  end
end
