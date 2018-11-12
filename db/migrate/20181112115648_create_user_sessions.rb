class CreateUserSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :user_sessions, id: :uuid do |t|
      t.references :user, foreign_key: true, type: :uuid
      t.string     :session_id
      t.inet       :ip
      t.string     :user_agent

      t.timestamps
    end
    add_index :user_sessions, :session_id, unique: true
  end
end
