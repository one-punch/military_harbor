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
          #{answer_options(child.answer_options) if child.answer_option_list.present? }
          #{sub_question(child.childList) if child.childList.present? }
      </div>}.strip
    end
    %Q{
      <div class="talqs_subqs">
        #{html.join.strip}
      </div>
    }.strip.html_safe
  end

  def sub_answer_options(answer)
    return unless answer.present?
    html = answer.map do |opt|
      %Q{<li class="talqs_options_columns_item clearfix">
        <span class="talqs_options_label">#{opt.aoVal}. </span>
        <div class="talqs_options_content">
          #{opt.content}
        </div>
      </li>}
    end
    html.join.strip
  end

  def answer_options(answer_options)
    if answer_options.present?
      html = answer_options.map do |answer|
            %Q{<ul class="talqs_options_list talqs_options_list_4 talqs_layout_complete">
                <li class="talqs_options_rows clearfix">
                  <ul class="talqs_options_columns_1 clearfix">
                    #{ sub_answer_options(answer) if answer.present? }
                  </ul>
                </li>
            </ul>}
          end
      %Q{<div class="talqs_options clearfix">
        #{html.join.strip}
      </div>}.strip.html_safe
    end
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

  def chapter_menu(sections)
    titles = sections.select{|e| e.is_h1? || e.is_h2?}
    html = []
    titles.each_with_index do |title, idx|
      if title.is_h1?
        html << "<li title='#{title.question_man_content}'>"
        html <<   "<h3>#{title.remark}、#{title.question_man_content}</h3>"
            end_index = find_next_h1(titles, idx + 1)
            if end_index.to_i <= idx + 1
              html << "</li>"
              next
            end
            sublis = titles[(idx + 1)..end_index].each_with_index.map do |title_2, idx|
              "<li title='#{title_2.question_man_content}'>#{idx + 1}. #{title_2.question_man_content}</li>"
            end
            html << "<ol>#{sublis.join}</ol>"
        html << "</li>"
      end
    end
    html.join
  end

  def find_next_h1(titles, start)
    titles[start..-1].index{|t| t.is_h1? }
  end

  def chapter_answer_options_list(question)
    #  题目选项
    return unless question.answer_option_list.present?
      list = question.answer_options.map do |options|
        options.map do |option|
          %Q{<ul class="clearfix">
            <li class="clearfix">
              <span class="opt_num">#{option.aoVal}.</span>
              <div class="opt_cont clearfix">
                #{option.content}
              </div>
            </li>
          </ul>}
        end.join
      end
    %Q{<div>
      <div>
        #{list.join}
      </div>
    </div>}.html_safe
  end


  def chapter_answer_html(answer)
    # 答案
    return unless answer.present?
    content = if answer.is_a?(Array)
      answer.flatten.try(:[], 0)
    elsif answer.is_a?(Hash) && answer["content"].present?
      answer["content"]
    end
    return unless content.present?
    %Q{<div>
      <div class="answer answer_child">
        <div class="answer_list">
          <span class="answer_titlle">答 案</span>
          <div class="answer_box daan">
            <div>
              #{content}
            </div>
          </div>
        </div>
      </div>
    </div>}.html_safe
  end


  def chapter_analysis_html(question)
    return unless question.analysis
    %Q{<div>
        <div class="answer answer_child">
          <div class="answer_list">
            <span class="answer_titlle">解 析</span>
            <div class="answer_box">
              #{question.analysis}
            </div>
          </div>
      </div>
    </div>}.html_safe
  end

end
