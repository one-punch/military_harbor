require 'json'

desc "import classes to DB"
namespace :izhikang do
  task :import, [:path] => [:environment] do |t, args|
    args.with_defaults(:path => "./edu-db.json")
    file = File.read(args.path)
    @data_hash = JSON.parse(file, symbolize_names: true)
    grade
    subject
    course
    material
    paper
  end
end

def grade
  [{:id=>1, :name=>"一年级"},
   {:id=>2, :name=>"二年级"},
   {:id=>3, :name=>"三年级"},
   {:id=>4, :name=>"四年级"},
   {:id=>5, :name=>"五年级"},
   {:id=>6, :name=>"六年级"},
   {:id=>7, :name=>"初一"},
   {:id=>8, :name=>"初二"},
   {:id=>9, :name=>"初三"},
   {:id=>10, :name=>"高一"},
   {:id=>11, :name=>"高二"},
   {:id=>12, :name=>"高三"}].each do |g|
    Grade.where(id: g[:id], name: g[:name]).first_or_create
  end
end

def subject
  @data_hash[:subjects].each do |sub|
    Subject.where(name: sub[:name]).first_or_create
  end
end

def course
  grades = {
    1 => 1,
    2 => 7,
    3 => 10
  }
  @data_hash[:courses].each do |cour|
    if cour[:courseList].present? # 第一类
      Course.where(proto_id: cour[:id]).first_or_create(name: cour[:name], subject_id: cour[:subjectId], grade_id: grades[cour[:gradeId].to_i])
    else
      c = Course.where(proto_id: cour[:id]).first_or_initialize(name: cour[:name], grade_id: cour[:gradeId])
      sub = @data_hash[:subjects].find{|sub| sub[:name] == cour[:subjectName] }
      c.subject_id = sub[:id] if sub
      c.attrs = cour.slice(:labelId, :labelName, :paperNum, :remark, :year, :quarterId, :quarterName, :semester, :gradeGroupId, :folderNum, :classTypeId, :cityId, :diffId, :diffName, :subjectTypeId, :subjectTypeName, :textBookId, :textBookName, :modulePurpose, :moduleType, :volumeName, :volumeId)
      c.save
    end
  end
end

def material
  @data_hash[:courses].select{|cour| cour[:courseList].present? }.each do |cour|
    cour[:courseList].each do |mat|
      Material.where(proto_id: mat[:id]).first_or_create name: mat[:name], number: mat[:lectureNum], proto_course_id: cour[:id]
    end
  end

  @data_hash[:papers].each do |paper|
    Material.where(proto_id: paper[:id]).first_or_create name: paper[:name], number: paper[:number], proto_course_id: paper[:courseId]
  end
end

def paper
  @data_hash[:papers].each do |paper|
    cloumns = [:explainPapers, :workPapers, :coursewareList]
    cloumns.each do |clo|
      paper[:classes][clo].each_with_index do |p, i|
          type = case clo
          when :explainPapers
            "explain"
          when :workPapers
            "work"
          when :coursewareList
            "courseware"
          else
            ""
          end
          Paper.where(proto_id: p[:id]).first_or_create name: p[:name], proto_material_id: paper[:id], student: p[:downloads][:student], tearcher: p[:downloads][:tearcher], type_name: type, number: i, path: p[:path]
          # pa = Paper.where(proto_id: p[:id]).last
          # pa.update_attributes name: p[:name], proto_material_id: paper[:id], student: p[:downloads][:student], tearcher: p[:downloads][:tearcher], type_name: type, number: i, path: p[:path]
      end
    end
  end

  @data_hash[:classes].each do |_class|
    Paper.where(proto_id: _class[:id]).first_or_create name: _class[:name], proto_material_id: _class[:courseId], student: _class[:downloads][:student], tearcher: _class[:downloads][:tearcher], path: _class[:downloads][:path]
  end

end

