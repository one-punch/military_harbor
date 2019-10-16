module PapersHelper


  def can_view?(paper_id)
    current_user.admin? || UserPaperRecord.where(user_id: current_user.id, paper_id: paper_id).last&.not_expired?
  end


end
