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

puts "Owned Issues          :  #{all.map(:Assigned_to).length}"

owners = all.map(:Assigned_to)  # {|a| a[:Assigned_to] }.uniq
authors = all.map(:Author)


assigned = owners.histogram
tickets = authors.histogram.merge(assigned)
authors = authors.histogram
puts "User               : Assigned : Submitted : Self Closed : Total Closed " 
tickets.each do |k,v|
	puts " " + 
		"#{k}  : #{assigned[k]} : #{authors[k]} : #{all.filter(:Author => k,:Status => "Closed").count} : #{all.filter(:Assigned_to => k,:Status => "Closed").count}" 
end



#-- Data --
# (`Number` varchar(255), `Status` varchar(255), `Project` varchar(255), `Tracker` varchar(255), `Priority` varchar(255), `Subject` varchar(255), `Assigned_to` varchar(255), `Category` varchar(255), `Target_version` varchar(255), `Author` varchar(255), `Start` varchar(255), `Due_date` varchar(255), `percent_Done` varchar(255), `Estimated_time` varchar(255), `Created` varchar(255), `Updated` varchar(255), `Description` varchar(255));
