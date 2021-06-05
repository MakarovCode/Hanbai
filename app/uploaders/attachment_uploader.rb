class AttachmentUploader < CarrierWave::Uploader::Base

	# Include RMagick or MiniMagick support:
	# include CarrierWave::RMagick
	include CarrierWave::MiniMagick

	# Choose what kind of storage to use for this uploader:
	storage :file
	# storage :fog

	# Override the directory where uploaded files will be stored.
	# This is a sensible default for uploaders that are meant to be mounted:
	def store_dir
		"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
	end

	version :high, if: :is_image? do
		process resize_to_fill: [800, 0]
	end

	version :mid, if: :is_image? do
		process resize_to_fill: [640, 0]
	end

	version :low, if: :is_image? do
		process resize_to_fill: [320, 0]
	end

	version :square, if: :is_image? do
		process resize_to_fill: [300, 300]
	end

	version :thumb, if: :is_image? do
		process resize_to_fill: [200, 0]
	end

	def extension_whitelist
		%w(jpg jpeg gif png pdf xls xlsx ods xlr doc docx key pps ppt ods pptx odt trf txt)
	end

	def is_image?(new_file)
		if new_file.content_type != false
			new_file.content_type.start_with?('image')
		end
	end

	def filename
		if original_filename
			if model && model.read_attribute(mounted_as).present?
				model.read_attribute(mounted_as)
			else
				# new filename
				"#{secure_token}.#{file.extension}" if original_filename.present?
			end
		end
	end

	protected
	def secure_token
		var = :"@#{mounted_as}_secure_token"
		model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
	end

end
