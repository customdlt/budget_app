class Expense < ApplicationRecord
  belongs_to :user
  belongs_to  :category

  after_commit :apply_payment_to_expense, on: [:create, :update]
  # before_update :prevent_update_if_expense_is_paid, :if => :paid
  before_update :prevent_update_if_payment_exceeds_limits, :if => :amount_paid_changed?

  before_save :payment_exceeds_amount_due?

  private

  def prevent_update_if_payment_exceeds_limits
    if payment_exceeds_remaining_budget_balance? && payment_exceeds_amount_due?
      true
    else
      self.errors[:base] << 'Cannot apply payment because it exceeds limits'
      throw(:abort)
    end
  end

  def payment_exceeds_remaining_budget_balance?
    if payment_difference > user.budget.amount
      self.errors[:base] << 'Cannot apply payment amount over remaining budget amount'
      throw(:abort)
    else
      true
    end
  end

  def payment_exceeds_amount_due?
    if amount_paid > amount_due
      self.errors[:base] << 'Cannot apply payment amount (total) over amount due'
      throw(:abort)
    else
      true
    end
  end

  def apply_payment_to_expense
    set_paid_status
    apply_payment_to_budget
  end

  def set_paid_status
    if amount_paid == amount_due
      self.update_column(:paid, true)
    end
  end

  def apply_payment_to_budget
    user.budget.update_column(
      :amount,
      user.budget.amount - payment_difference
    )
  end

  def payment_difference
    prev_amount_paid = amount_paid_before_last_save || 0.0
    amount_paid - prev_amount_paid
  end
end
