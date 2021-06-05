object @extra_fields

attributes :id, :name

node :model_name_id do |extra_field|
  "#{extra_field.name.downcase.gsub(" ", "_")}-#{extra_field.id}"
end

node :model_name do |extra_field|
  extra_field.name.downcase.gsub(" ", "_")
end

node :kind do |extra_field|
  unless extra_field.kind.nil?
    extra_field.kind.to_s
  else
    "1"
  end
end

node :required do |extra_field|
  unless extra_field.required.nil?
    extra_field.required.to_s
  else
    "0"
  end
end

node :kind_name do |extra_field|
  extra_field.get_kind_name
end
