class RenameAmountToTotalAmountInBudgets < ActiveRecord::Migration[6.0]
  def change
    rename_column :budgets, :amount, :total_amount
  end
end
