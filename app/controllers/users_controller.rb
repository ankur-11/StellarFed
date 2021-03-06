class UsersController < ApplicationController
  before_action :set_search_query_and_type, only: [:federation_search]
  before_action :set_search_query, only: [:search]

  def show
    @user = User.confirmed.where(email: params[:id]).first
    render :show, status: @user.blank? ? :not_found : :ok and return
  end

  def search
    @user = User.confirmed.where("email = ? OR account_id = ?", @search_query, @search_query).first
    if @user.present?
      redirect_to user_path(@user) and return
    end
    render :show and return
  end

  def federation_search
    response.headers['Access-Control-Allow-Origin'] = '*'
    case @search_type
    when 'name'
      @user = User.get(@search_query)
    when 'id'
      @user = User.confirmed.where(account_id: @search_query).first
    else
      render status: :bad_request, json: { detail: "cannot handle '#{@search_type}' type" }.to_json and return
    end

    unless @user.confirmed?
      render status: :not_found, json: { detail: "no record found" }.to_json and return
    end

    resp = {
      stellar_address: @user.stellar_address,
      account_id: @user.account_id,
    }.merge(@memo.present? ? { memo: @memo, memo_type: 'text' } : {})

    render status: :ok, json: resp.to_json and return
  end

  private

  def set_search_query_and_type
    return unless set_search_query
    return unless set_search_type

    # Extract memo if present by looking for + after the before but before *
    # Example: john@email.com+memo*stellarfed.org
    if @search_type == 'name'
      matches = @search_query.scan(/^(.+@[^\+]+)\+?(.+)?/)
      if matches.blank?
        render status: :bad_request, json: { detail: "bad query" }.to_json and return
      end

      @search_query, @memo = matches.first
    end
  end

  def set_search_query
    if params[:q].blank?
      render status: :bad_request, json: { detail: "missing query" }.to_json and return
    end
    
    @search_query ||= params[:q].gsub(/\*#{Regexp.quote(StellarFed::Application::DOMAIN)}$/, '')
  end

  def set_search_type
    if params[:type].blank?
      render status: :bad_request, json: { detail: "missing type" }.to_json and return
    end

    @search_type ||= params[:type]
  end
end
