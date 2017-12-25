# -*- coding: utf-8 -*-
score={"A++++"=>6,"A+++"=>5,"A++"=>4,"A+"=>3,"A"=>2,"B"=>1,"C"=>0,""=>0}

j=0
sep=","
line=gets
print line
day = line.chomp.split(/,/).size-4

while line=gets do
  line_elem=line.chomp.split(/,/)

  score_total=0
  line_elem.each_with_index do |elem,i|
    if i>1 && i<=day+1 then
      unless score[elem]==nil
        score_total += score[elem]
      else
        score_total+=elem.to_i
      end
    end
    print "#{elem}"+sep
  end
  (day+2-line_elem.size).times{ print " "+sep }
  if line_elem[day+2]!=nil then
    bonus=line_elem[day+2].split(/ /).length
  else
    bonus=0
    print sep
  end
  score_total += bonus
  print "#{score_total}/#{2*day}\n"
end

