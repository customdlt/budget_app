class CreateExpenses < ActiveRecord::Migration[6.0]
  def change
    create_table :expenses do |t|
      t.datetime :due_date
      t.decimal :amount_due
      t.decimal :amount_paid
      t.boolean :paid
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
