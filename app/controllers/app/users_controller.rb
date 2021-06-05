##
# Esta clase representa el usuario de la aplicación.

class App::UsersController < App::AppController

	def edit
		@user = current_user
	end

	def update
		@user = current_user
		if @user.update params_permit
			redirect_to edit_app_user_path @user, notice: "¡Perfil actualizado correctamente!"
		else
			render :edit
		end
	end

	private

	def params_permit
		params.require(:user).permit(:name, :image, :profession, :birthday, :email, :password, :password_confirmation, setup_attributes: [:id, :remember_me_notifications, :moment_to_be_remember])
	end

end
