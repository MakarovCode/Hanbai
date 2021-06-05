object @logs

attributes :id, :action_text

child :user do
  attributes :id, :name

  node :image do |user|
    if user.image.url.nil?
      gravatar_image_url(user.email, :gravatar => { :rating => 'pg' }, secure:false)
    else
      user.image.url
    end
  end
end

# child :funnel do
#   attributes :id, :name
# end
#
# child :stage do
#   attributes :id, :name
# end
#
# child :deal do
#   attributes :id, :title
# end
#
# child :activity do
#   attributes :id, :title
# end
