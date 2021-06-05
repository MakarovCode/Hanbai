##
# Esta clase representa el un contacto de la aplicación.

class Landing::ContactsController < Landing::LandingController

	def create
    contact = Contact.new permit_params
    if contact.save
      render status: 200, json: {message: "¡Gracias por contactarnos!, nos contactaremos contigo lo antes posible. "}
    else
      render status: 411, json: {message: "Revisa el formulario", errors: contact.errors.full_messages.to_sentence}
    end
	end

  private

  def permit_params
    params.require(:contact).permit(:name, :email, :phone, :message, :subject)
  end

end
