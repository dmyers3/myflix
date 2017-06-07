class CreateQueue < ActiveRecord::Migration
  def change
    create_table :queue_positions do |t|
      t.integer :user_id, :video_id, :position
      t.timestamps
    end
  end
end
