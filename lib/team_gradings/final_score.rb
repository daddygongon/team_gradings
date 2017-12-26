# -*- coding: utf-8 -*-

# grading final scores
class FinalScore
  attr_reader :groups, :scores, :bonus
  def initialize
    @groups = mk_group('./Group.list')
    @bonus = get_bonus('./tmp2.csv')
    @scores = get_final_exam_score('./final_exam.csv')
    calc_group_score
    print_group_results
    print_personal_results
  end

  def mk_group(group_list)
    groups = []
    File.open(group_list).each do |line|
      name, member = line.chomp.split(/,/)
      next if name[0] == '#'
      groups << Group.new(name, member)
    end
    groups
  end

  def calc_group_score
    @groups.each do |group|
      group.get_average(@scores)
      group.bonus = @bonus[group.name].to_i
      final = group.average + group.bonus
      group.final_score = final > 100 ? 100 : final
      printf("%s, %4d, %4d, %4d\n", group.name, group.average,
             group.bonus, group.final_score)
    end
  end

  def get_final_exam_score(file)
    scores = {}
    File.open(file).each do |line|
      no, score = line.chomp.split(/,/)
      scores.store(no, score)
    end
    scores
  end

  def get_bonus(file)
    bonus = {}
    File.open(file).each do |line|
      element = line.chomp.split(/,/)
      bonus.store(element[0], element[-1].split('/')[0])
    end
    bonus
  end

  # add average and final to tmp2.csv lines
  def print_group_results
    lines = File.readlines('./tmp2.csv')
    conts = String.new(mk_header(lines[0]))
    conts << push_average_final_score(lines)
    File.open('./final_group_results.csv', 'w') { |file| file.print conts }
  end

  def push_average_final_score(lines)
    conts = ''
    lines.each do |line|
      g_i = find_number(line.split(/,/)[0])
      next if g_i.nil?
      conts << "#{line.chomp},#{@groups[g_i].average},"
      conts << "#{@groups[g_i].final_score}\n"
    end
    conts
  end

  def print_personal_results
    conts = ''
    @groups.each do |group|
      conts << group.put_personal_score(@scores)
    end
    File.open('./personal_results.csv', 'w') { |file| file.print conts }
  end

  def mk_header(header)
    ele = header.split(',')
    header = ele[0..-2].join(',')
    header << ",ボーナス合計,最終試験平均,最終スコア\n"
  end

  def find_number(name)
    @groups.each_with_index do |group, i|
      return i if group.name == name
    end
    nil
  end
end
