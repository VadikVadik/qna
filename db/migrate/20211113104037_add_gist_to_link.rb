class AddGistToLink < ActiveRecord::Migration[6.1]
  def change
    add_column :links, :gist, :boolean, default: false
  end
end
