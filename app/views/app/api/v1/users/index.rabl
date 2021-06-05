object @users
attributes :id, :name

node :image do |user|
  if user.image.url.nil?
    gravatar_image_url(user.email, :gravatar => { :rating => 'pg' }, secure:false)
  else
    user.image.url
  end
end

node :status do |user|
  if !@funnel.nil?
    is_member = user.is_funnel_member(@funnel)
    if is_member
      {status: 1, message: "Ya es miembro"}
    else
      {status: 0, message: "Invitar"}
    end
  elsif !@deal.nil?
    is_member = user.is_deal_member(@deal)
    if is_member
      {status: 1, message: "Ya es miembro"}
    else
      {status: 0, message: "Invitar"}
    end
  else
    {status: 1, message: "Ya es miembro"}
  end
end

node :permission do |user|
  unless @funnel.nil?
    user.get_funnel_member_permissions(@funnel)
  else
    {name: "Normal", permission: "normal"}
  end
end
