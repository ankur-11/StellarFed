class ApplicationMailer < ActionMailer::Base
  default from: "StellarFed <ankur@#{StellarFed::Application::DOMAIN}>"
  layout 'mailer'
end
