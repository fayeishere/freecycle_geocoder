class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :date
      t.string :message_id
      t.string :subject
      t.string :location
      t.string :body
      t.string :latitude
      t.string :longitude
      t.string :data

      t.timestamps
    end
  end
end
