require 'test_helper'

class BudgetTest < ActiveSupport::TestCase
  setup  do
    @test_budget = Budget.new(
      user: users(:one),
      amount: 1000.00
    )
  end

  test "budget should not be valid without an amount" do
    @test_budget.amount = nil
    assert @test_budget.invalid?
  end

  test "budget should not be valid without an user" do
    @test_budget.user = nil
    assert @test_budget.invalid?
  end

  test "budget should not be valid with amount not being a number" do
    @test_budget.amount = 'amount'
    assert @test_budget.invalid?
  end

  test "test budget should be valid" do
    assert @test_budget.valid?
  end
end
