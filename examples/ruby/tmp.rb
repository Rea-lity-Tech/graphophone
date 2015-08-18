

Graphophone::Note.channels[2].programChange 0, 45

#(20...30).each do |x|

(50...55).each do |n|
  Graphophone::Note.Play(n, 1500, 1000, 100, 2)
  sleep 0.5
end

#end
