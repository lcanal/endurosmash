class CreateActivityZones < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_zones do |t|
      t.string  :aid
      t.string  :type
      t.integer :zone1
      t.integer :zone2
      t.integer :zone3
      t.integer :zone4
      t.integer :zone5
      t.integer :zone6
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
