STDIN.readlines.each do |line|
	line.gsub!(/^/, "|")
	line.gsub!(/:/, "|")
	line.gsub!(/\n/, "|")
	
	if line =~ /User/ || line.match(/Authors/)
					puts "\n"
					ma = line.match(/^\|(.*)\s\s\s/)
					m = ma[1].gsub /\s/, ''
					line.gsub! m,"*#{m}*"
	end
  line.gsub! "|Progress", "h2. Progress"
  line.gsub! "Report|", "Report"

  puts "\n" if line.match(/\=+/)
	puts line unless line.match(/\=+/)
end
