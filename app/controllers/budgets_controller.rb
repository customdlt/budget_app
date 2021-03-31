class BudgetsController < ApplicationController

  def new
    @budget = Budget.new
  end

  private

  def budget_params
    params.require(:budget).permit(:amount)
  end
end
