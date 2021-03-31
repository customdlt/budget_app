class AddCategoryIdToExpense < ActiveRecord::Migration[6.0]
  def change
    add_reference :expenses, :category, null: false, foreign_key: true
  end
end
