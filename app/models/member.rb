class Member < ActiveRecord::Base
  
  belongs_to :school
  belongs_to :k
  
  has_many :checks, :order => "id desc"
  
  def checks_data_for_chart
    data = {}
    data["categories"] = []
    data["series_l"] = []
    data["series_r"] = []
    
    checks = self.checks
    i = 0
    checks.each do |check|
      if i > 4
        break
      end
      params = JSON.parse check.params
      data["categories"] << check.check_date
      data["series_l"] << params["l"]["a"]
      data["series_r"] << params["r"]["a"]
      i = i + 1
    end
    data["categories"].reverse!
    data["series_l"].reverse!
    data["series_r"].reverse!
    data
  end
  
end
