class CreateInvestments < ActiveRecord::Migration[8.0]
  def change
    create_table :investments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :fundraise, null: false, foreign_key: true
      t.integer :amount_cents, null: false, default: 0

      t.timestamps
    end

    add_index :investments, [ :user_id, :fundraise_id ]
  end
end
