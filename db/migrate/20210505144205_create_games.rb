class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.string :status
      t.string :calls
      t.string :pattern
      t.string :state
      t.text :json

      t.timestamps
    end
  end
end
