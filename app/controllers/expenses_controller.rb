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

  def edit
    @expense = Expense.find(params[:id])
  end

  def update
    @expense = Expense.find(params[:id])
    if @expense.update(amount_paid: @expense.amount_paid + expense_params[:amount_paid].to_f)
      redirect_to user_path(@expense.user)
    else
      render 'edit'
    end
  end

  def show
    @expense = Expense.find(params[:id])
    @user = User.find(@expense.user_id)
    @user_expenses = Expense.where(user_id: @expense.user_id)
  end

  def destroy
    @expense = Expense.find(params[:id])
    user = current_user
    @expense.destroy
    redirect_to user_path(user)
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
  params.require(:expense).permit(:due_date, :amount_due, :amount_paid, :paid, :description, :user_id, :category_id)
  end
end
