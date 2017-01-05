class User < ApplicationRecord
  attr_accessor :remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_secure_password

  has_many :microposts

  validates :name, presence: true, length: {maximum: Settings.max_name_length}
  validates :email, format: {with: VALID_EMAIL_REGEX}
  validates :email, presence: true, length: {maximum: Settings.max_email}
  validates :email, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.min_pass},
    allow_nil: true

  before_save {self.email = email.downcase}

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end
end
