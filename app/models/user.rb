class User < ApplicationRecord
  before_save { email.downcase! }
  validates :name, presence: true, length: {maximum: 50}
  VALIDATE_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
                    format: {with: VALIDATE_EMAIL_REGEX},
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: {minimum: 5}
  validates :password_confirmation, presence: true, length: {minimum: 6}
  
  # usersのfixture(テスト用アカウント作成)のためにパスワードをpassword_digestにするためのメソッド
  # https://github.com/rails/rails/blob/main/activemodel/lib/active_model/secure_password.rb参照
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
