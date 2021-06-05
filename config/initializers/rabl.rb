require 'rabl'
Rabl.configure do |config|	
	config.include_json_root = false
	config.include_child_root = false
	config.replace_nil_values_with_empty_strings = true
end