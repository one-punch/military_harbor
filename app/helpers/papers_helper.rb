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


    # function scan(sections, goter) {
    #     goter = goter || [];
    #     var section;
    #     var sectionTmp = [];
    #     var subSection;
    #     var subSectionTmp = [];
    #     var order = 0;
    #     for (var i = 0, len = sections.length; i < len; i += 1) {
    #         var item = sections[i];
    #         if (item.type == "title@h1") {
    #             order = 0;
    #             section = {
    #                 children: []
    #             };
    #             goter.push(section);
    #             section.name = item.content;
    #             section.cnOrder = item.cnOrder;
    #             section.id = item.id;
    #             section.body = item;
    #             sectionTmp = [];
    #             subSectionTmp = [];
    #             subSection = null;
    #         } else if (item.type == "title@h2") {
    #             order = 0;
    #             subSection = {
    #                 name: item.content,
    #                 id: item.id,
    #                 body: item,
    #                 children: []
    #             };
    #             if (section) {
    #                 section.children.push(subSection);
    #             } else {
    #                 sectionTmp.length == 0 && goter.push({
    #                     name: '临时分类组',
    #                     body: {
    #                         content: '临时分类组'
    #                     },
    #                     isTmp: true,
    #                     children: sectionTmp
    #                 });
    #                 sectionTmp.push(subSection);
    #             }
    #             subSectionTmp = [];
    #         } else {
    #             var deepSection = {
    #                 name: item.content || (item.questions ? item.questions[0].content : ''),
    #                 id: item.id,
    #                 body: item
    #             };
    #             if (subSection) {
    #                 subSection.children.push(deepSection);
    #             } else {
    #                 if (section) {
    #                     subSectionTmp.length == 0 && section.children.push({
    #                         name: '临时分类组',
    #                         body: {
    #                             content: '临时分类组'
    #                         },
    #                         isTmp: true,
    #                         children: subSectionTmp
    #                     });
    #                     subSectionTmp.push(deepSection);

    #                 } else {
    #                     sectionTmp.length == 0 && goter.push({
    #                         name: '临时分类组',
    #                         body: {
    #                             content: '临时分类组'
    #                         },
    #                         isTmp: true,
    #                         children: sectionTmp
    #                     });
    #                     subSectionTmp.length == 0 && sectionTmp.push({
    #                         name: '临时分类组',
    #                         body: {
    #                             content: '临时分类组'
    #                         },
    #                         isTmp: true,
    #                         children: subSectionTmp
    #                     });
    #                     subSectionTmp.push(deepSection);
    #                 }
    #             }
    #         }
    #         if (item.type && ~item.type.indexOf("question")) {
    #             delete item.order;
    #             order++;
    #             var nextQuestion = sections[i + 1];
    #             if (order == 1) {
    #                 if (nextQuestion && ~nextQuestion.type.indexOf("question")) item.order = order;
    #             } else {
    #                 item.order = order;
    #             }
    #         }
    #     }
    #     return goter;
    # }
  def btree(sections, goter=[])
    section = nil
    sectionTmp = []
    subSection = nil
    subSectionTmp = []


  end

end
