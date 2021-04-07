class ExpensesController < ApplicationController
  before_action :authenticate
  before_action :correct_user?,  only: [:edit, :update]

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
    set_expense
  end

  def update
    set_expense
    if @expense.update(amount_paid: @expense.amount_paid + expense_params[:amount_paid].to_f)
      redirect_to user_path(@expense.user)
    else
      flash[:error] = @expense.errors.full_messages[0]
      render 'edit'
    end
  end

  def show
    set_expense
    @user = User.find(@expense.user_id)
    @user_expenses = Expense.where(user_id: @expense.user_id)
  end

  def destroy
    set_expense
    user = current_user
    @expense.destroy
    redirect_to user_path(user)
  end

  private

  def correct_user?
    set_expense
    unless current_user?(@expense.user)
      redirect_to user_path(current_user)
    end
  end

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
  params.require(:expense).permit(:due_date, :amount_due, :amount_paid, :paid, :description, :user_id, :category_id)
  end
end
