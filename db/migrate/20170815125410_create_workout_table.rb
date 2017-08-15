class CreateWorkoutTable < ActiveRecord::Migration[5.1]
  def change
  	create_table :workouts do |t|
  		t.string :name
  		t.date :date
  		t.integer :user_id
  	end
  end
end
