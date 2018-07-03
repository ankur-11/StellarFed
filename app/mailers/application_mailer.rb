class ApplicationMailer < ActionMailer::Base
  default from: "StellarFed <ankur@#{StellarFederation::Application::DOMAIN}>"
  layout 'mailer'
end
