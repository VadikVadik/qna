class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.string :status, default: 'none'
      t.integer :votable_rating
      t.references :votable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.index [:user_id, :votable_id, :votable_type], unique: true

      t.timestamps
    end
  end
end
