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

  def stellar_address
    "#{self.email}*#{DOMAIN}"
  end

  def account_id_qr_code
    barcode = Barby::QrCode.new(self.account_id, level: :q, size: 5)
    base64_output = Base64.encode64(barcode.to_png({ xdim: 5 }))
    "data:image/png;base64,#{base64_output}"
  end
end
