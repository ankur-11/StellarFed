class StaticController < ApplicationController
  def welcome
    if current_user.present?
      redirect_to user_path(current_user) and return
    end
  end

  def stellar
    response.headers['Access-Control-Allow-Origin'] = '*'
    render plain: "FEDERATION_SERVER = \"https://#{StellarFed::Application::DOMAIN}/federation\"" and return
  end
end
