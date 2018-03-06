class ApplicationMailer < ActionMailer::Base
  default from: "StellarFed <ankur@#{DOMAIN}>"
  layout 'mailer'
end
