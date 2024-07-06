class CreateIngredients < ActiveRecord::Migration[7.1]
  def change
    create_table :ingredients do |t|
      t.string :name, null: false
      t.integer :stock, null: false, default: 0

      t.timestamps
    end
    add_index :ingredients, :name, unique: true
  end
end
