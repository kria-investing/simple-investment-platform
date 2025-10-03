class CreateFundraises < ActiveRecord::Migration[8.0]
  def change
    create_table :fundraises do |t|
      t.string :title, null: false
      t.text :description
      t.integer :target_cents, null: false, default: 0
      t.string :status, null: false, default: "open"
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
