class Check < ActiveRecord::Base
  
  belongs_to :member
  
  def is_first?
    self.member.checks.last.id == self.id
  end
  
end
