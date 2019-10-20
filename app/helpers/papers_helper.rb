module PapersHelper


  def can_view?(paper_id)
    current_user.admin? || UserPaperRecord.where(user_id: current_user.id, paper_id: paper_id).last&.not_expired?
  end

  def can_read?(product)
    if product.is_a? Variant
       can_view?(product.paper.id)
    else
      false
    end
  end


end
