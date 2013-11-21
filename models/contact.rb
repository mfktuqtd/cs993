class Contact < ActiveRecord::Base
  #validation
  validates_uniqueness_of :name
  validates_presence_of :phone, :company, :city, :qq, :email
end
