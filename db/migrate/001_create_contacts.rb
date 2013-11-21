class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :name
      t.string :phone
      t.string :company
      t.string :city
      t.string :address
      t.string :post
      t.string :qq
      t.string :email
      t.string :weixin
      t.string :weibo
      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
