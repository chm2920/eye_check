class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.integer :member_id
      t.string :check_date
      t.string :check_result
      t.text :params
      t.text :intervention
    end
  end
end
