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

  def sub_question(childList)
    return if childList.blank?
    html = []
    childList.each_with_index do |child, idx|
      html \
      << %Q{<div class="talqs_main clearfix">
          <span class="talqs_index">#{idx + 1}</span>
          <div class="talqs_content clearfix">
            #{child.content}
          </div>
          #{sub_question(child.childList) if child.childList.present? }
      </div>}.strip
    end
    %Q{
      <div class="talqs_subqs">
        #{html.join.strip}
      </div>
    }.strip.html_safe
  end

  def sub_answer(childList)
    return if childList.blank?
    html = []
    childList.each_with_index do |child, idx|
      if child.answer.present?
        child.answer.each do |answer|
          html << \
          %Q{<div class="talqs_analyze_item">
              <div class="talqs_analyze_item_index">
                #{idx + 1}
              </div>
              <div class="talqs_panel_item">
                <div class="talqs_panel_item_content">
                    #{answer.join(",")}
                </div>
              </div>
              #{sub_answer(child.childList) if child.childList}
            </div>
          }.strip
        end
      else
        html << \
          %Q{<div class="talqs_analyze_item">
              <div class="talqs_analyze_item_index">
                #{idx + 1}
              </div>
              <div class="talqs_panel_item">
                <div class="talqs_panel_item_content">
                </div>
              </div>
              #{sub_answer(child.childList) if child.childList}
            </div>
        }.strip
      end
    end
    %Q{
      <div class="talqs_panel">
        #{html.join.strip}
      </div>
    }.strip.html_safe
  end

  def sub_analyze(childList)
    return if childList.blank?
    html = []
    childList.each_with_index do |child, idx|
      if child.analysis
        child.analysis.each do |analyze|
          html << \
          %Q{<div class="talqs_analyze_item">
              <div class="talqs_analyze_item_index">
                #{idx + 1}
              </div>
              <div class="talqs_panel_item clearfix">
                <div class="talqs_panel_item_content">
                  #{analyze}
                </div>
              </div>
              #{sub_analyze(child.childList) if child.childList.present? }
            </div>
            }.strip
        end
      else
        html << \
        %Q{<div class="talqs_analyze_item">
            <div class="talqs_analyze_item_index">
              #{idx + 1}
            </div>
            <div class="talqs_panel_item clearfix">
              <div class="talqs_panel_item_content">
              </div>
            </div>
            #{sub_analyze(child.childList) if child.childList.present? }
          </div>
        }.strip
      end
    end
    %Q{
      <div class="talqs_panel">
        #{html.join.strip}
      </div>
    }.strip.html_safe
  end

end
