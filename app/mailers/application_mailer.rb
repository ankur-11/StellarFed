class ApplicationMailer < ActionMailer::Base
  default from: "info@#{StellarFed::Application::DOMAIN}"
  layout 'mailer'
end
