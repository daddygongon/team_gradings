# -*- coding: utf-8 -*-
# translate a,b,c to 3, 2, 1 scores
class TransABCTo321
  attr_accessor :conts
  def initialize(tmp_csv)
    @conts = ''
    lines = tmp_csv.split("\n")
    score = { 'A++++' => 6, 'A+++' => 5, 'A++' => 4, 'A+' => 3, 'A' => 2,
      'B' => 1, 'C' => 0, '' => 0 }
    sep = ','
    line = lines[0]
    @conts << line + "\n"
    day = line.chomp.split(/,/).size - 4

    lines[1..-1].each do |line|
      line_elem = line.chomp.split(/,/)
      score_total = 0
      line_elem.each_with_index do |elem, i|
        if i > 1 && i <= day + 1
          score_total += if score[elem].nil?
                           elem.to_i
                         else
                           score[elem]
                         end
        end
        @conts << elem.to_s + sep
      end
      (day + 2 - line_elem.size).times { @conts << ' ' + sep }
      if line_elem[day + 2] != nil
        bonus = line_elem[day + 2].split(/ /).length
      else
        bonus = 0
        @conts << sep
      end
      score_total += bonus
      @conts << "#{score_total}/#{2 * day}\n"
    end
  end

  def print
    @conts
  end
end
