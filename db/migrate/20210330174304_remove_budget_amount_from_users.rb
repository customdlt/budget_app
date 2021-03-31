class RemoveBudgetAmountFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :budget_amount, :decimal
  end
end
