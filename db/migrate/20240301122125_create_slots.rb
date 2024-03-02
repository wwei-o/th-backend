class CreateSlots < ActiveRecord::Migration[7.1]
  def change
    create_table :slots do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tour, null: false, foreign_key: true
      t.datetime :startDate
      t.datetime :endDate
      t.time :startTime
      t.time :endTime
      t.integer :status, default: 1

      t.timestamps
    end
  end
end
