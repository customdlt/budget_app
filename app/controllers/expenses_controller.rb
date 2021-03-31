class ExpensesController < ApplicationController
  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)
    @expense.user = current_user
    if @expense.save
      redirect_to user_path(@expense.user)
    else
      render 'new'
    end
  end

  def show
    @expense = Expense.find(params[:id])
    @user = User.find(@expense.user_id)
    @user_expenses = Expense.where(user_id: @expense.user_id)
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:due_date, :amount_due, :amount_paid, :paid, :description, :user_id, :category_id)
  end
end
