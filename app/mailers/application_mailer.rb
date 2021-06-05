class ApplicationMailer < ActionMailer::Base
  default from: 'Incalate <contacto@incalate.com>'
  layout 'mailer'

  before_action :load_info

  def load_info
    @info = Information.first
  end
end
