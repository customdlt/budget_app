class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }, length: { maximum: 255 }

  before_save {self.email = email.downcase }
  has_secure_password
end
