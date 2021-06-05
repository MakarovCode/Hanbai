##
# Esta clase representa los logs.

class App::Api::V1::LogsController < App::Api::ApiController

	##
	# Devuelve la lista de log de embudos, negocios, actividades
	#
	# <b>GET: /api/v1/logs.json</b>
	#
	# === Params:
	#   user_uuid - Usuario UUID
	#   user_token - Usuario Token de autenticación
	#   funnel_id - Id del embudo
	#   deal_id - El caso de filtrar el log por un negocio
	#   activity_id - El caso de filtrar el log por una actividad
	#
	# == Ejemplos
	#
	# === Status Ok
	#   => 200
	#
	# === Respuesta
	#   => [
	#		  {
	#			"id": 1,
	#			"action_text": 1,
	#			"funnel_id": 1,
	#			"deal_id": 1,
	#			"activity_id": 1
	#		  }
	#	   ]
	#
	# === Status Sin autorización
	#   => 422
	#
	# === Respuesta
	#   => {"message": "Necesitas iniciar sesión o registrarte para continuar"}
	#

	def index
		@logs = []
		# funnel = current_user.funnels_as_member.find_by_id params[:funnel_id]
		# @logs = HistoryLog.includes(:funnel, :deal, :stage, :activity, :user).where(funnel_id: params[:funnel_id], deal_id: params[:deal_id]).references(:funnel, :deal, :stage, :activity, :user)
		
		# @logs = funnel.history_logs
	end


end
