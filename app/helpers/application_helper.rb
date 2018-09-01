module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @user ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def donate_account
    User.where(email: StellarFed::Application::DONATION_ACCOUNT).first
  end
end
