# -*- coding: utf-8 -*-
require 'kconv'

class TransHiki
  attr_accessor :conts
  def initialize(tmp2_csv)
    @conts = "!!!グループ得点\n"

    sep = '||'
    lines = tmp2_csv.split("\n")
    lines.each do |line|
      elem1 = line.chomp.split(/,/)
      @conts << sep
      elem1.each do |elem|
        @conts << elem + sep
      end
      @conts << sep + "\n"
    end

    @conts << %(
!!!得点対応
||評価||得点
||A++:=51-infinity||4+
||A+:=45-50||3
||A:=35-44||2
||B:=10-34||1
||C:=0-9||0
)
  end
end
