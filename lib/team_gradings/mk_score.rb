# -*- coding: utf-8 -*-
require 'kconv'

# make hash table between member and group
class MkScore
  attr_accessor :group, :m2g
  def initialize
    @group = {}
    @m2g = {}
    mk_group
    gets_speaker_score
    gets_report_score
    print_score_table
  end

  def mk_group
    File.open(File.join('.', 'Group.list'), 'r').each do |line|
      next if line =~ /^\#/
      team_name, members = line.strip.split(/,/)
      g = Group.new(team_name, members)
      members.split(/ /).each do |mem|
        @m2g.store(mem, team_name)
      end
      @group.store(team_name, g)
    end
  end

  def gets_speaker_score
    File.readlines(File.join('.', 'Speaker.list')).each do |line|
      next if line =~ /^\#/
      next unless m = line.match(/^([\d|\/]+) (.+)/)
      date, team = m[1..2]
      team_name = !@group[team].nil? ? team : @m2g[team]
      if !@group[team_name].nil?
        @group[team_name].speaker_score << date + ' '
      else
        $stderr.print 'Non list:' + team + "\n"
      end
    end
  end

  def gets_report_score
    lines = File.readlines(File.join('.', 'Report.tsv'), '\r')
    lines_conv = lines[0].kconv(Kconv::UTF8, Kconv::UTF16).split("\n")
    @head = lines_conv.shift
    lines_conv.each do |line|
      l1 = line.split(/\t/)
      team_name = l1.shift.strip
      l1.each do |score|
        if !@group[team_name].nil?
          @group[team_name].report_score << score.strip
        else
          $stderr.print 'Non list:' + team_name + "\n"
        end
      end
    end
  end

  def print_score_table
    cont = 'グループ名,メンバー,'
    cont << @head.chomp.split("\t")[1..-1].join(',')
    cont << ",発表ボーナス,合計\n"
    @group.each do |key, g|
      cont << key + ',' + g.print + "\n"
    end
    print cont
    cont
  end
end
