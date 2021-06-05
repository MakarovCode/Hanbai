class HistoryLog < ApplicationRecord
  belongs_to :user
  belongs_to :funnel
  belongs_to :stage
  belongs_to :deal
  belongs_to :activity

  def self.create_for(user, object, action)
    if object.class.name.demodulize == "Funnel"
      create user_id: user.id, funnel_id: object.id, action_text: action
    elsif object.class.name.demodulize == "Stage"
      create user_id: user.id, funnel_id: object.funnel.id, stage_id: object.id, action_text: action
    elsif object.class.name.demodulize == "Deal"
      create user_id: user.id, funnel_id: object.stage.funnel.id, stage_id: object.stage.id, deal_id: object.id, action_text: action
    elsif object.class.name.demodulize == "Activity"
      unless object.deal.nil?
        create user_id: user.id, activity_id: object.id, action_text: action
      else
        create user_id: user.id, funnel_id: object.deal.stage.funnel.id, stage_id: object.deal.stage.id, deal_id: object.deal.id, activity_id: object.id, action_text: action
      end
    end
  end
end
