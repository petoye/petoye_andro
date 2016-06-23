class AddPetTypeAndPetBreedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pet_type, :string
    add_column :users, :pet_breed, :string
  end
end
