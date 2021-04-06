class BudgetsController < ApplicationController

  def new
    @budget = Budget.new
  end

  def edit
    @budget = Budget.find(params[:id])
  end

  def update
    @budget = Budget.find(params[:id])
    if @budget.update(amount: @budget.amount + params[:budget][:amount].to_f)
      redirect_to user_path(@budget.user)
    else
      render 'edit'
    end
  end

  private

  def budget_params
    params.require(:budget).permit(:amount)
  end
end
