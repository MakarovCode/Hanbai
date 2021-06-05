module EasyPayULatam
  class ApplicationMailer < ActionMailer::Base
    layout 'easy_pay_u_latam/mailer'
    default from: 'Incalate <contacto@incalate.com>'

    before_action :load_info

    def load_info
      @info = Information.first
    end
  end
end
