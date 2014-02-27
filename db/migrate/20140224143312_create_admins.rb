class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.column :login_name, :string
      t.column :login_pwd, :string
    end
    
    Admin.create(:login_name => "admin", :login_pwd => "admin")
  end
end
