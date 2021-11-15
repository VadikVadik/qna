class CreateAwards < ActiveRecord::Migration[6.1]
  def change
    create_table :awards do |t|
      t.string :title
      t.references :question, null: false, foreign_key: true
      t.references :owner, foreign_key: {to_table: :users}, optional: true

      t.timestamps
    end
  end
end
