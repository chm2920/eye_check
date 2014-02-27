class K < ActiveRecord::Base
  
  belongs_to :school
  
  has_many :members
  
end
