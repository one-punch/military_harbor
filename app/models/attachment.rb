class Attachment < ApplicationRecord
  mount_uploader :file, AttachmentUploader

  belongs_to :source, polymorphic: true

end
