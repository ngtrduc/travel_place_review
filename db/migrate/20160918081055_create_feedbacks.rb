class CreateFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :feedbacks do |t|
      t.string :description
      t.string :image
      t.references :place_review, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end