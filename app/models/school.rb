class School < ActiveRecord::Base
  
  has_many :ks, -> { order "grade asc"}, dependent: :destroy
  
  has_many :masters
  has_many :members, dependent: :destroy
  
end
