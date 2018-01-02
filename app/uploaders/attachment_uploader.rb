class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include Sprockets::Rails::Helper
  storage :file

  def store_dir
    "uploads/attachment/#{model.id}"
  end

  def image?(_new_file)
    file.content_type.include? 'image'
  end

  def not_image?(_new_file)
    !file.content_type.include? 'image'
  end

  version :thumb, if: :image? do
    process resize_and_pad: [200, 200]
  end

  version :small, if: :image? do
    process resize_and_pad: [75, 75]
  end

  def filename
     "#{secure_token(10)}.#{file.extension}" if original_filename.present?
  end

  protected
  def secure_token(length=16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end
end