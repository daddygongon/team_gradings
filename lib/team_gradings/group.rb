class Group
  attr_accessor :members, :bonus, :final_score, :average, :name
  attr_accessor :speaker_score, :report_score
  def initialize(name, members)
    @name = name
    @members = members.split(' ')
    @bonus=0
    @average = 0
    @speaker_score = ""
    @report_score = []
  end
  def get_average(scores)
    num, sum = 0, 0.0
    @members.each do |no|
      next if scores[no]==nil
      sum += scores[no].to_f
      num += 1
    end
    @average = (sum/num).round
  end
  def put_personal_score(scores)
    cont_all = ""
    @members.each do |no|
      cont = no.to_s+","
      next if scores[no]==nil
      cont << scores[no]+","
      cont << @average.to_s+","
      cont << @final_score.to_s
      cont_all << cont+"\n"
    end
    return cont_all
  end
  def print()
    content = []
    content << @members.join(' ')
    @report_score.each{|score| content << score}
    content << @speaker_score if @speaker_score
    return content.join(',')
  end
end
