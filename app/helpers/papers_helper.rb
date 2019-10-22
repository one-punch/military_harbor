module PapersHelper


  def can_view?(paper_id)
    current_user.admin? || UserPaperRecord.where(user_id: current_user.id, paper_id: paper_id).last&.not_expired?
  end

  def can_read?(product)
    if product.paper_id
       can_view?(product.paper_id)
    else
      false
    end
  end

  def can_download?(product)
    if product.paper_id
      current_user.admin? || UserPaperRecord.where(user_id: current_user.id, paper_id: paper_id).last&.allow_download?
    else
      false
    end
  end


end
