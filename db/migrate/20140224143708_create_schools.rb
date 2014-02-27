#encoding: utf-8
class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name
    end
    School.create(:name => "学校A")
    School.create(:name => "学校B")
  end
end
