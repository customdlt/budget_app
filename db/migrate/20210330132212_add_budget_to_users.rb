class AddBudgetToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :budget_amount, :decimal
  end
end
