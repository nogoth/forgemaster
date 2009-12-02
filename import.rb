require 'csv'
require 'sequel'
require 'sqlite3'

reader = CSV.open('export.csv', 'r')
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
