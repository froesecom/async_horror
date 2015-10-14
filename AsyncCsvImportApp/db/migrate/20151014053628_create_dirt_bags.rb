class CreateDirtBags < ActiveRecord::Migration
  def change
    create_table :dirt_bags do |t|
      t.string :first_name
      t.string :last_name
      t.string :company_name
      t.string :address
      t.string :city
      t.string :state
      t.string :post
      t.string :phone1
      t.string :phone2
      t.string :email
      t.string :web

      t.timestamps null: false
    end
  end
end
