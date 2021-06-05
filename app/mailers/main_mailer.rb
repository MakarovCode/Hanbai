class MainMailer < ApplicationMailer
  def daily(user_id, activities_ids)
    @activities = Activity.where(id: activities_ids)
    @main_message = "Tienes #{@activities.count} actividades para hoy:"
    @user = User.find user_id
    @call_to_action = "Ir a mis actividades"

    mail to: @user.email, subject: "(Incalate) Actividades de hoy."
  end

  def just_before_activity(user_id, activity_id)
    @user = User.find user_id
    @activity = Activity.find activity_id
    subject = "(Incalate) actividad en 15 minutos."

    unless @activity.activity_type.nil?
      subject = "(Incalate) #{@activity.activity_type.name} en 15 minutos."
    end

    if !@activity.activity_type.nil? && !@activity.person.nil?
      subject = "(Incalate) #{@activity.activity_type.name} con #{@activity.person.name} en 15 minutos."
    end

    @main_message = "Actividad en 15 minutos:"
    @call_to_action = "Ir a mis actividades"

    mail to: @user.email, subject: subject
  end

  def new_contact
    @main_message = "Lorem ipsum dolor amtet"
    @user = User.last
    @call_to_action = "Ir a mi cuenta"
    @url = root_url
    mail to: "simon@devpenguin.co", subject: "(Incalate) Actividades de hoy."
  end

  def new_post
    @main_message = "Lorem ipsum dolor amtet"
    @user = User.last
    @call_to_action = "Ir a mi cuenta"
    @url = root_url
    mail to: "simon@devpenguin.co", subject: "(Incalate) Actividades de hoy."
  end

  def invite(host, user, funnel)
    @main_message = "#{host.name} te han invitado al embudo #{funnel.name}"
    @user = user
    @call_to_action = "Entrar al embudo"
    @url = app_funnels_path(funnel_id: funnel.id)
    mail to: user.email, subject: "(Incalate) Tienes una nueva invitación."
  end

  def invite_outsider(host, email, funnel)
    @main_message = "#{host.name} te han invitado al embudo #{funnel.name}"
    @user = email
    @call_to_action = "Entrar al embudo"
    @url = app_funnels_path(funnel_id: funnel.id)
    mail to: email, subject: "(Incalate) Tienes una nueva invitación."
  end

  def account_expiring(user, end_date)
    @main_message = "Tu cuenta esta por expirar, renueva tu cuenta antes del #{end_date.strftime('%Y-%m-%d')}"
    @user = user
    @call_to_action = "Ir a mi cuenta"
    @url = app_user_account_index_path(user)
    mail to: user.email, subject: "(Incalate) Tu cuenta GOLD esta por expirar."
  end

  def account_expired(user)
    @main_message = "Tu cuenta ha expirado, renueva tu cuenta ahora y no pierdas los beneficios de tu cuenta GOLD."
    @user = user
    @call_to_action = "Ir a mi cuenta"
    @url = app_user_account_index_path(user)
    mail to: user.email, subject: "(Incalate) Tu cuenta GOLD ha expirado."
  end

end
