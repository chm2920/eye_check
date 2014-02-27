#encoding: utf-8
class CreateKs < ActiveRecord::Migration
  def change
    create_table :ks do |t|
      t.integer :school_id
      t.string :grade
      t.string :name
    end
    K.create(:school_id => 1, :grade => 1, :name => "一班")
    K.create(:school_id => 1, :grade => 1, :name => "二班")
  end
end
