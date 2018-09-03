require 'openssl'
require 'base64'

class AccountsController < ApplicationController
  before_action :set_account_and_token, only: [:show, :destroy]

  def show
    render :show and return
  end

  def destroy
    @account.destroy
    render @account, status: :ok, layout: false
  end

  private

  def set_account_and_token
    permitted_params = params.permit(:id, :token)
    @account = Account.find(permitted_params[:id])
    @token = permitted_params[:token]

    if @account.hashed_address != @token
      not_found
    end
  end
end
