class CreateActivityZones < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_zones do |t|
      t.string :type
      t.string :sid
      t.integer :duration
      t.integer :activity
      t.integer :zone1
      t.integer :zone2
      t.integer :zone3
      t.integer :zone4
      t.integer :zone5
      t.integer :zone6

      t.timestamps
    end
    add_index :activity_zones, :activity, unique: true
    add_index :activity_zones, :sid, unique: true
  end
end
