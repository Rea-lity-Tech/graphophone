

(20...30).each do |x|
  Graphophone::Note.channels[2].programChange(0, 0)

  puts "x " + x.to_s
  (25...29).each do |n|
    Graphophone::Note.Play(n, 150, 120, 0, 2)
    sleep 0.5
  end

end
