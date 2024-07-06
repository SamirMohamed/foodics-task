class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :products, :name, unique: true
  end
end
