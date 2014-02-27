class CreateMasters < ActiveRecord::Migration
  def change
    create_table :masters do |t|
      t.integer :school_id
      t.string :login_name
      t.string :login_pwd
    end
    
    Master.create(:school_id => 1, :login_name => "master", :login_pwd => "master")
  end
end
