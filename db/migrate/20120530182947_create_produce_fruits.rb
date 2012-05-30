class CreateProduceFruits < ActiveRecord::Migration
  def change
    create_table :produce_fruits do |t|
      t.string :kind
      t.string :variety
      t.integer :quantity

      t.timestamps
    end
  end
end
