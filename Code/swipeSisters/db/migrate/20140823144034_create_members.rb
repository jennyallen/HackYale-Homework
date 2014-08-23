class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :fname
      t.string :lname
      t.string :netid
      t.string :email
      t.string :year
      t.string :college
      t.references :list, index: true

      t.timestamps
    end
  end
end
