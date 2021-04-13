require 'test_helper'

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  test "should get redirect if not logged in" do
    get new_expense_path
    assert_redirected_to login_path
  end

  test "expense should not be created if Description is not given" do
    login_as_user(users(:one), 'secret')
    description_empty_expense_params = setup_expense_params
    description_empty_expense_params[:description] = nil
    assert_no_difference 'Expense.count' do
      post "/expenses", params: { expense: description_empty_expense_params }
      assert_equal "Description can't be blank", flash[:error]
    end
  end

  test "expense should not be created if due_date is not given" do
    login_as_user(users(:one), 'secret')
    due_date_empty_expense_params = setup_expense_params
    due_date_empty_expense_params[:due_date] = nil
    assert_no_difference 'Expense.count' do
      post "/expenses", params: { expense: due_date_empty_expense_params }
      assert_equal "Due date can't be blank", flash[:error]
    end
  end

  test "expense should not be created if amount_due is not a number" do
    login_as_user(users(:one), 'secret')
    amount_due_text_expense_params = setup_expense_params
    amount_due_text_expense_params[:amount_due] = 'words'
    assert_no_difference 'Expense.count' do
      post "/expenses", params: { expense: amount_due_text_expense_params }
      assert_equal "Amount due is not a number", flash[:error]
    end
  end

  test "expense should not be created if amount_paid is not a number" do
    login_as_user(users(:one), 'secret')
    amount_paid_text_expense_params = setup_expense_params
    amount_paid_text_expense_params[:amount_paid] = 'words'
    assert_no_difference 'Expense.count' do
      post "/expenses", params: { expense: amount_paid_text_expense_params }
      assert_equal "Amount paid is not a number", flash[:error]
    end
  end

  test "expense should not be created if amount paid is over amount due" do
    login_as_user(users(:one), 'secret')
    larger_amount_paid_expense = setup_expense_params
    larger_amount_paid_expense[:amount_paid] = 150.00
    assert_no_difference 'Expense.count' do
      post "/expenses", params: { expense: larger_amount_paid_expense }
      assert_equal "Cannot apply payment amount (total) over amount due", flash[:error]
    end
  end

  test "expense should not be created if amount paid is over remaining budget amount" do
    login_as_user(users(:one), 'secret')
    larger_amount_paid_expense = setup_expense_params
    larger_amount_paid_expense[:amount_due] = 6000.00
    larger_amount_paid_expense[:amount_paid] = 6000.00
    assert_no_difference 'Expense.count' do
      post "/expenses", params: { expense: larger_amount_paid_expense }
      assert_equal "Cannot apply payment amount over remaining budget amount", flash[:error]
    end
  end

  test "expense should be created on post with a valid user" do
    login_as_user(users(:one), 'secret')
    assert_difference 'Expense.count' do
      post "/expenses", params: { expense: setup_expense_params }
    end
  end

  test "expense should be created and paid status false if amount paid is less than amount due" do
    login_as_user(users(:one), 'secret')
    assert_difference 'Expense.count' do
      post "/expenses", params: { expense: setup_expense_params }
    end
    refute Expense.last.paid
  end

  test "expense should be created and paid status true if amount paid is less than amount due" do
    login_as_user(users(:one), 'secret')
    amount_paid_equal_expense = setup_expense_params
    amount_paid_equal_expense[:amount_paid] = 100.00
    assert_difference 'Expense.count' do
      post "/expenses", params: { expense: amount_paid_equal_expense }
    end
    assert Expense.last.paid
  end

  test "payment should not be applied if amount_paid is over amount due" do
    login_as_user(users(:one), 'secret')
    assert_difference 'Expense.count' do
      post "/expenses", params: { expense: setup_expense_params }
    end
    assert_equal Expense.last.amount_paid, 0
    patch expense_path(Expense.last),  params:  { expense: { amount_paid: 150.00 } }
    assert_equal "Cannot apply payment amount (total) over amount due", flash[:error]
    assert_equal Expense.last.amount_paid, 0
  end

  test "payment should not be applied if amount_paid is over remaining budget amount" do
    login_as_user(users(:one), 'secret')
    larger_amount_due_expense = setup_expense_params
    larger_amount_due_expense[:amount_due] = 6000.00
    assert_difference 'Expense.count' do
      post "/expenses", params: { expense: larger_amount_due_expense }
    end
    assert_equal Expense.last.amount_paid, 0
    patch expense_path(Expense.last),  params:  { expense: { amount_paid: 6000.00 } }
    assert_equal  "Cannot apply payment amount over remaining budget amount", flash[:error]
    assert_equal Expense.last.amount_paid, 0
  end

  test "payment should be applied through update action" do
    login_as_user(users(:one), 'secret')
    assert_difference 'Expense.count' do
      post "/expenses", params: { expense: setup_expense_params }
    end
    assert_equal Expense.last.amount_paid, 0
    patch expense_path(Expense.last),  params:  { expense: { amount_paid: 50.00 } }
    assert_equal Expense.last.amount_paid, 50.00
  end

  test "expense paid status should be set to true if payment applied sets amount_paid equal to amount due" do
    login_as_user(users(:one), 'secret')
    assert_difference 'Expense.count' do
      post "/expenses", params: { expense: setup_expense_params }
    end
    refute Expense.last.paid
    patch expense_path(Expense.last),  params:  { expense: { amount_paid: 100.00 } }
    assert Expense.last.paid
  end

  private

  def setup_expense_params
    {
      due_date: '2021-04-22',
      amount_due: 100.00,
      amount_paid: 0.00,
      category_id: categories(:one).id,
      description: 'Test Expense'
    }
  end
end
