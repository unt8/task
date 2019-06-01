class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :login
      t.string :github_id
      t.string :avatar_url
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
