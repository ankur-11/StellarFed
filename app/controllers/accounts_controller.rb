require 'openssl'
require 'base64'

class AccountsController < ApplicationController
  before_action :account_params, only: [:show]

  def show
    @account = Account.where(email: @email).first
    if @account.blank? || @account.hashed_address != @token
      not_found
    end
    @account.destroy
    render :show and return
  end

  private

  def account_params
    permitted_params = params.permit(:id, :token)
    @email = permitted_params[:id]
    @token = permitted_params[:token]
  end
end
