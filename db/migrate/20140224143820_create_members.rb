#encoding: utf-8
class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :school_id
      t.integer :k_id
      t.string :name
      t.string :gender
      t.string :in_time
      t.string :mem_no
      t.string :login_name
      t.string :login_pwd
    end
    Member.create(:school_id => 1, :k_id => 1, :name => "张三", :gender => "男", :in_time => "2011-9", :mem_no => '111', :login_name => "a1", :login_pwd => "")
    Member.create(:school_id => 1, :k_id => 1, :name => "李四", :gender => "女", :in_time => "2011-9", :mem_no => '222', :login_name => "a2", :login_pwd => "")
  end
end
