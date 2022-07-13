class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  attr_accessor :remember_token, :activation_token, :reset_token
  
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: {maximum: 50}
  VALIDATE_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
                    format: {with: VALIDATE_EMAIL_REGEX},
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6}, allow_nil: true
  
  # usersのfixture(テスト用アカウント作成)のためにパスワードをpassword_digestにするためのメソッド
  # https://github.com/rails/rails/blob/main/activemodel/lib/active_model/secure_password.rb参照
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  #ランダムなトークンを生成
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  #渡されたトークンがダイジェストと一致したらtrueを返す
  #remember_tokenはローカル変数。上のattr_accessorで定義しているものとは違う
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # アカウントを有効化する
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end
  
  # アカウント有効化のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  #パスワード再設定の属性を生成する
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now)
  end
  
  # パスワード再設定用のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  def feed
    Micropost.where("user_id=?", id)
  end
  
  private
  
  # メールアドレスを全て小文字にする(before_saveでメソッド参照されてる)
  def downcase_email
    self.email.downcase!
  end
  
  # 有効かトークンとダイジェストを作成する(before_createでメソッド参照されてる)
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
  
end
