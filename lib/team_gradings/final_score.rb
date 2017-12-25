#! /usr/bin/ruby
# -*- coding: utf-8 -*-
require 'pp'


class MkGroups
  attr_reader :groups, :scores, :bonus
  def initialize
    @groups = mk_group('./Group.list')
    @bonus = get_bonus('./tmp2.csv')
    @scores = get_final_exam_score('./final_exam.csv')
    calc_group_score
    print_results_all
    print_personal_results
  end
  def calc_group_score
    @groups.each do |group|
      printf "Name: %s\n", name = group.name
      printf "Average:%7.2f\n", group.get_average(@scores)
      printf "Bonus  :%4.0f\n", group.bonus = @bonus[name].to_i
      final = group.average + group.bonus
      group.final_score = (final > 100) ? 100 : final
      printf "Final  :%7.2f\n", group.final_score
    end
  end
  def mk_group(group_list)
    groups = []
    File.open(group_list).each do |line|
      name, member = line.chomp.split(/,/)
      next if name[0] == '#'
      groups << Group.new(name, member)
    end
    return groups
  end
  def get_final_exam_score(file)
    scores = Hash.new
    File.open(file).each do |line|
      no,score = line.chomp.split(/,/)
      scores.store(no,score)
    end
    return scores
  end
  def get_bonus(file)
    bonus = Hash.new
    File.open(file).each do |line|
      element = line.chomp.split(/,/)
      bonus.store(element[0],element[-1].split('/')[0])
    end
    return bonus
  end
  def print_results_all
    lines = File.readlines('./tmp2.csv')
    cont = ""
    cont << mk_header(lines[0])
    lines.each do |line|
      name = line.split(/,/)[0]
      g_i = find_number(name)
      next if g_i == nil
      average = @groups[g_i].average.to_i
      final = @groups[g_i].final_score.to_i
      cont << line.chomp+","+average.to_s+","+final.to_s+"\n"
    end
    File.open('./tmp3.csv','w'){|file| file.print cont}
  end
  def print_personal_results
    conts = ""
    @groups.each do |group|
      conts << group.put_personal_score(@scores)
    end
    File.open('./tmp4.csv','w'){|file| file.print conts}
  end
  def mk_header(header)
    ele = header.split(',')
    header = ele[0..-2].join(",")
    header << ",ボーナス合計,最終試験平均,最終スコア\n"
  end
  def find_number(name)
    @groups.each_with_index do |group,i|
      return i if group.name == name
    end
    return nil
  end
end


