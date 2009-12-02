require 'csv'
require 'sequel'
require 'sqlite3'
file = ARGV[0] || 'export.csv'
puts file

reader = CSV.open(file, 'r')
fields = reader.shift
fields.map! do |m| 
	tmp = m.gsub(/#/, 'number') 
	tmp.gsub('%', 'percent')
end

sfield = fields.map{ |m| "String :#{m.gsub(/\s+/,'_')}"}.join("\n")

DB = Sequel.sqlite('records.db')

eval("
DB.create_table! :import do 
  " + sfield + "
end
")

users = DB[:import]

reader.each do |entry|
	users.insert( entry )
end

users.each do |entry|
	puts entry
end
