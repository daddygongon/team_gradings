# -*- coding: utf-8 -*-
require 'kconv'

# make hash table between member and group
class MkScore
  attr_accessor :group, :m2g
  def initialize
    @group=Hash.new
    @m2g=Hash.new
    mk_group
    get_speaker_score
    get_report_score
    print_score_table
  end
  def mk_group
    File.open(File.join('.',"Group.list"),"r").each do |line|
      next if line =~ /^\#/
      l1=line.chomp.split(/,/)
      team_name=l1[0].strip
      members=l1[1]
      g=Group.new(team_name, members)
      l1[1].split(/ /).each do |mem|
        @m2g.store(mem,team_name)
      end
      @group.store(l1[0].strip,g)
    end
  end
  def get_speaker_score
    File.readlines(File.join('.',"Speaker.list")).each do |line|
      next if line =~ /^\#/
      next unless m = line.chomp.match(/^([\d|\/]+) (.+)/)
      date, team = m[1],m[2]
      next unless team
      team_name = group[team]!=nil ? team : m2g[team]
      if @group[team_name]!=nil then
        @group[team_name].speaker_score << date.to_s+" "
      else
        $stderr.print "Non list:"+team+"\n"
      end
    end
  end
  def get_report_score
    lines=File.readlines(File.join('.',"Report.tsv"),'\r')
    lines_conv=lines[0].kconv(Kconv::UTF8, Kconv::UTF16).split("\n")
    @head=lines_conv.shift
    lines_conv.each do |line|
      l1=line.split(/\t/)
      team_name=l1.shift.strip
      l1.each do |score|
        if @group[team_name]!=nil then
          @group[team_name].report_score << score.strip
        else
          $stderr.print "Non list:"+team_name+"\n"
        end
      end
    end
  end
  def print_score_table
    cont="グループ名,メンバー,"
    cont << @head.chomp.split("\t")[1..-1].join(",")
    cont << ",発表ボーナス,合計\n"
    @group.each{|key,g|
      cont << key+","+g.print+"\n"
    }
    return cont
  end
end
