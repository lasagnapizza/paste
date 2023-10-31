class CreateNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :notes do |t|
      t.text :body, null: false
      t.string :slug, null: false, index: {unique: true}
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
