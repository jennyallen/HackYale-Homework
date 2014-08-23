class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :name
      t.string :organization
      t.references :user, index: true

      t.timestamps
    end
  end
end
