class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file

  def store_dir
    "attachment/#{model.id}"
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
end