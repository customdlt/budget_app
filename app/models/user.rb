class User < ApplicationRecord
  has_one :budget
  accepts_nested_attributes_for :budget
  has_many :expenses

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates_presence_of :username

  validates :email, presence: true, uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }, length: { maximum: 255 }

  before_save :downcase_email
  has_secure_password

  private

  def downcase_email
    self.email = email.downcase
  end
end
