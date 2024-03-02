class CreateTours < ActiveRecord::Migration[7.1]
  def change
    create_table :tours do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :desc
      t.integer :mode
      t.integer :status, default: 1

      t.timestamps
    end
  end
end
