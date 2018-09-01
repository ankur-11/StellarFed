require 'barby'
require 'barby/barcode'
require 'barby/barcode/qr_code'
require 'barby/outputter/png_outputter'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  self.primary_key = :email
  validates :account_id, presence: true, allow_blank: false, length: { is: 56 }
  has_one_attached :avatar

  scope :confirmed, -> { where.not(confirmed_at: nil) }
  
  after_update_commit :update_cache
  after_destroy :uncache

  def self.get(email)
    user = where(email: email).first
    return user if user.present?

    account = Account.find_or_create(email)
    return User.new(
      email: email,
      account_id: account.public_key,
      confirmed_at: Time.now)
  end

  def self.update_cache
    confirmed.where(receive_email_notifications: true).find_each(&:cache)
  rescue => e
    logger.warn e
  end

  def stellar_address
    "#{self.email}*#{StellarFed::Application::DOMAIN}"
  end

  def account_id_qr_code
    barcode = Barby::QrCode.new(self.account_id, level: :q, size: 5)
    base64_output = Base64.encode64(barcode.to_png({ xdim: 5 }))
    "data:image/png;base64,#{base64_output}"
  end

  def after_confirmation
    super
    cache
  end

  def uncache
    StellarFed::Application::CACHE_CLIENT.srem(account_id, email)
  rescue => e
    logger.warn e
  end

  def cache
    if receive_email_notifications && confirmed?
      StellarFed::Application::CACHE_CLIENT.sadd(account_id, email)
    end
  rescue => e
    logger.warn e
  end

  private

  def update_cache
    receive_email_notifications ? cache : uncache
  end
end
