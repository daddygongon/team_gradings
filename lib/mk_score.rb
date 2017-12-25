# -*- coding: utf-8 -*-

class Group
  attr_accessor :member, :speaker_score, :report_score
  def initialize(mem)
    @member = mem
    @speaker_score = ""
    @report_score = []
  end

  def print()
    content = @member
    report_score.each{|score| content << ","+score.to_s}
    content << ","+speaker_score.to_s if speaker_score
    return content
  end
end

# make hash table between member and group
group=Hash.new
m2g=Hash.new
File.open(File.join('..',"Group.list"),"r").each do |line|
  next if line =~ /^\#/
  l1=line.chomp.split(/,/)
  team_name=l1[0].strip
  members=l1[1]
  g=Group.new(members)
  l1[1].split(/ /).each do |mem|
      m2g.store(mem,team_name)
  end
  group.store(l1[0].strip,g)
end

# make
File.readlines(File.join('..',"Speaker.list")).each do |line|
  next if line =~ /^\#/
  next unless m = line.chomp.match(/^([\d|\/]+) (.+)/)
  date, team = m[1],m[2]
  next unless team
  team_name = group[team]!=nil ? team : m2g[team]
  if group[team_name]!=nil then
    group[team_name].speaker_score << date.to_s+" "
  else
    $stderr.print "Non list:"+team+"\n"
  end
end

require 'kconv'
lines=File.readlines(File.join('..',"Report.tsv"),'\r')
lines_conv=lines[0].kconv(Kconv::UTF8, Kconv::UTF16).split("\n")
head=lines_conv.shift

lines_conv.each{|line|
  l1=line.split(/\t/)
  team_name=l1.shift.strip
  l1.each{|score|
    if group[team_name]!=nil then
      group[team_name].report_score << score.strip
    else
      $stderr.print "Non list:"+team_name+"\n"
    end
  }
}

cont="グループ名,メンバー,"
cont << head.chomp.split("\t")[1..-1].join(",")
#p cont
cont << ",発表ボーナス,合計\n"
#p cont
group.each{|key,g| cont << key+","+g.print+"\n"}
print cont
