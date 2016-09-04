class AddPetNameAndPetAgeAndPetBreedingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pet_name, :string
    add_column :users, :pet_age, :int
    add_column :users, :pet_breeding, :string
  end
end
