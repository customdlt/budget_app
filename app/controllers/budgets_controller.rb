class BudgetsController < ApplicationController
  before_action :authenticate
  before_action :correct_user?,  only: [:edit, :update]

  def new
    @budget = Budget.new
  end

  def edit
    set_budget
  end

  def update
    set_budget
    if @budget.update(amount: @budget.amount + params[:budget][:amount].to_f)
      redirect_to user_path(@budget.user)
    else
      flash[:error] = @budget.errors.full_messages[0]
      render 'edit'
    end
  end

  private

  def correct_user?
    set_budget
    unless current_user?(@budget.user)
      redirect_to user_path(current_user)
    end
  end

  def set_budget
    @budget = Budget.find(params[:id])
  end

  def budget_params
    params.require(:budget).permit(:amount)
  end
end
