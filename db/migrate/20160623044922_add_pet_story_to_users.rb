class AddPetStoryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pet_story, :string
  end
end
