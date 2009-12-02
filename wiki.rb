STDIN.readlines.each do |line|
	line.gsub!(/^/, "|")
	line.gsub!(/:/, "|")
	line.gsub!(/\n/, "|")
	
	if line =~ /\|\s+\|/ || line.match(/Authors/)
					puts "\n"
					ma = line.match(/^\|(.*)\s\s\s/)
					m = ma[1].gsub /\s/, ''
					line.gsub! m,"*#{m}*"
	end
	puts line
end
