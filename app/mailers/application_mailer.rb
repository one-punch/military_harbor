class ApplicationMailer < ActionMailer::Base
  default from: ENV["MAILER_USERNAME"]
  layout 'mailer'
end
