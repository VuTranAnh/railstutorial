class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_secure_password

  has_many :microposts

  validates :name, presence: true, length: {maximum: Settings.max_name}
  validates :email, format: {with: VALID_EMAIL_REGEX}
  validates :email, presence: true, length: {maximum: Settings.max_email}
  validates :email, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.min_pass}

  before_save {self.email = email.downcase}
end
