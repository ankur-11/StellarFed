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

  scope :confirmed -> { where.not(confirmed_at: nil) }
  scope :who_receive_notifications, -> { where(receive_email_notifications: true) }
  
  after_update_commit :update_cache
  after_destroy :uncache

  def stellar_address(opts = {})
    if opts[:html]
      "#{self.email}<span class='asterisk'>*</span>#{StellarFederation::Application::DOMAIN}".html_safe
    else
      "#{self.email}*#{StellarFederation::Application::DOMAIN}"
    end
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
    StellarFederation::Application::CACHE_CLIENT.srem(account_id, email) rescue nil
  end

  def cache
    if receive_email_notifications
      StellarFederation::Application::CACHE_CLIENT.sadd(account_id, email) rescue nil
    end
  end

  private

  def update_cache
    receive_email_notifications ? cache : uncache
  end
end
