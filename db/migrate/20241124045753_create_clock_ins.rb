class CreateClockIns < ActiveRecord::Migration[7.1]
  def change
    create_table :clock_ins do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :clock_in_time
      t.datetime :clock_out_time

      t.timestamps
    end
  end
end
