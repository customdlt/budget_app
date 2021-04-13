require 'test_helper'

class ExpenseTest < ActiveSupport::TestCase
  setup do
    @test_expense = Expense.new(
      due_date: '12 Apr 2021',
      amount_due: 100.00,
      amount_paid: 0.00,
      paid: false,
      user: users(:one),
      category: categories(:one),
      description: 'Test Expense'
    )
  end

  test "expense should be valid with all details" do
    assert @test_expense.valid?
  end

  test "expense without description should not be valid" do
    @test_expense.description = nil
    assert @test_expense.invalid?
  end

  test "expense without due_date should not be valid" do
    @test_expense.due_date = nil
    assert @test_expense.invalid?
  end

  test "expense amount_due should be numerical" do
    @test_expense.amount_due = 'test'
    assert @test_expense.invalid?
  end

  test "expense amount_paid should be numerical" do
    @test_expense.amount_paid = '12 Apr 2021'
    assert @test_expense.invalid?
  end

  test "expense without user should not be valid" do
    @test_expense.user = nil
    assert @test_expense.invalid?
  end

  test "expense without category should not be valid" do
    @test_expense.category = nil
    assert @test_expense.invalid?
  end

  test "expense amount_paid can't be more than amount due" do
    @test_expense.amount_paid = 105.00
    assert_no_difference 'Expense.count' do
      @test_expense.save
    end
  end
end
