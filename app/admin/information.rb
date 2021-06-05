ActiveAdmin.register Information do

  actions :all, except: [:new, :show, :create, :destroy]

  controller do
    before_action :redirect_to_edit, only: [:index]
    before_action :permit_params

    def permit_params
      params.permit!
    end

    def redirect_to_edit
      redirect_to edit_admin_information_path(Information.first)
    end
  end

end
