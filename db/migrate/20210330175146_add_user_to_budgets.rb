class AddUserToBudgets < ActiveRecord::Migration[6.0]
  def change
    add_reference :budgets, :user, null: false, foreign_key: true
  end
end
