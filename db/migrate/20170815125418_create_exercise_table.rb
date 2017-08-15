class CreateExerciseTable < ActiveRecord::Migration[5.1]
  def change
  	create_table :exercises do |t|
  		t.string :name
  		t.integer :lbs
  		t.integer :reps
  		t.integer :workout_id
  	end
  end
end
