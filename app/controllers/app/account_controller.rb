##
# Esta clase representa la cuenta del usuario de la aplicación.

class App::AccountController < App::AppController

	def index

	end

	def create
		amount = 15000 if params[:period] == "month"
		amount = 75000 if params[:period] == "semester"
		amount = 100000 if params[:period] == "year"

		period = "del año" if params[:period] == "year"
		period = "del semestre" if params[:period] == "semester"
		period = "del mes" if params[:period] == "month"

		end_date = Date.today + 1.month if params[:period] == "month"
		end_date = Date.today + 6.months if params[:period] == "semester"
		end_date = Date.today + 1.year if params[:period] == "year"

		@payu_payment = EasyPayULatam::PayuPayment.create(
			amount: amount,
			currency: "COP",
			period: params[:period],
			user_id: current_user.id,
			description: "Pago #{period} Incalate",
			start_date: Date.today,
			end_date: end_date
		)

		redirect_to "/easy_pay_u_latam/pay_u_payments/#{@payu_payment.id}/edit?user_id=#{current_user.id}", notice: "Completa el formulario y serás redireccionado a PayU para que realices tu pago."
	end

	private

	# EasyPayULatam::PayuPayment.create(amount: 10000,currency: "COP",period: "year",user_id: 35,description: "Pago 3M Incalate Free UPICKS",start_date: Date.today,end_date: Date.today + 3.year,status: 1)
	# EasyPayULatam::PayuPayment.create(amount: 10000,currency: "COP",period: "year",user_id: 36,description: "Pago 3M Incalate Free UPICKS",start_date: Date.today,end_date: Date.today + 3.year,status: 1)

end
