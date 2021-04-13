require 'test_helper'

class BudgetsControllerTest < ActionDispatch::IntegrationTest
  test "should get redirect if not logged in" do
    get edit_budget_path(1)
    assert_redirected_to login_path
  end

  test "budget should not be updated if amount is not a number" do
    login_as_user(users(:one), 'secret')
    budget = budgets(:one)
    amount_text_budget_params = setup_budget_params
    amount_text_budget_params[:amount] = 'words'
    assert_equal budget.amount, 5000.45
    patch budget_path(budget),  params:  { budget: amount_text_budget_params }
    assert_equal Budget.find(budget.id).amount, 5000.45
  end

  test "budget should be updated if amount is valid" do
    login_as_user(users(:one), 'secret')
    budget = budgets(:one)
    assert_equal budget.amount, 5000.45
    patch budget_path(budget),  params:  { budget: setup_budget_params }
    assert_equal Budget.find(budget.id).amount, 6500.45
  end

  def setup_budget_params
    { amount: 1500.00 }
  end
end
