require 'sequel'
require 'sqlite3'

class Array
	def histogram
		inject(Hash.new(0)){|h, item| h[item] += 1 ; h }
  end
end

DB = Sequel.sqlite('records.db')

nonclosed = DB[:import].filter( ~{:Status => 'Closed'} )
all = DB[:import]

puts "Progress        Report"
puts "======================"

puts "New Issues            : " + all.filter( :Status => 'New' ).count.to_s

puts "Non Closed Issues     : " + nonclosed.to_a.length.to_s 

puts "Percent Finished, Open: " + nonclosed.exclude( :percent_Done => "0" ).avg(:percent_Done)
puts "Issues, no progress   :  #{nonclosed.filter( :percent_Done => "0" ).count }"

 
puts "Unassigned Issues     :  #{all.select(:Assigned_to).select_more(:Status).exclude( ~{:Assigned_to => ""}).count}"

to_status = all.select(:Assigned_to).select_more(:Status).exclude(:Assigned_to => "")
puts "Owned Issues          :  #{to_status.count}"

owners = to_status.map {|a| a[:Assigned_to] }.uniq
puts "Owners                : " 

owners.each do |owner| 
	puts "                        " +
	  owner + 
	  " :" + to_status.filter(:Assigned_to => owner).count.to_s  +
#	  " " + to_status.filter(:Assigned_to => owner).map{|a| a[:Status] }.join(",") +
		" "
end

puts "Authors               : Closed " 
authors = all.exclude( :Author => "" ).select(:Author).map(:Author)
authors.histogram.each do |k,v|
	puts " " + 
		"#{k}  (#{v}) : #{all.filter(:Author => k,:Status => "Closed").count}" 
end



#-- Data --
# (`Number` varchar(255), `Status` varchar(255), `Project` varchar(255), `Tracker` varchar(255), `Priority` varchar(255), `Subject` varchar(255), `Assigned_to` varchar(255), `Category` varchar(255), `Target_version` varchar(255), `Author` varchar(255), `Start` varchar(255), `Due_date` varchar(255), `percent_Done` varchar(255), `Estimated_time` varchar(255), `Created` varchar(255), `Updated` varchar(255), `Description` varchar(255));
