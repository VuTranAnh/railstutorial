class ApplicationMailer < ActionMailer::Base
  default from: Settings.mailer
  layout "mailer"
end
