class CreatePatterns < ActiveRecord::Migration[6.1]
  def change
    create_table :patterns do |t|
      t.string :name
      t.string :card, limit: 25

      t.timestamps
    end
  end
end
