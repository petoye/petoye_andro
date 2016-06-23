class CreateAdoptions < ActiveRecord::Migration
  def change
    create_table :adoptions do |t|
      t.integer :user_id
      t.string :pet_type
      t.string :breed
      t.integer :age
      t.string :description

      t.timestamps null: false
    end
  end
end
