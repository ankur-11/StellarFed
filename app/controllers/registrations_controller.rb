class RegistrationsController < Devise::RegistrationsController
  private
  def sign_up_params
    params.require(:user).permit(:email, :password, :account_id)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :current_password, :account_id, :avatar)
  end
end
