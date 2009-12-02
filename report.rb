require 'csv'
require 'sequel'
require 'sqlite3'

reader = CSV.open('export.csv', 'r')
fields = reader.shift
fields.map!{ |m| m.gsub('#', 'number') 
	m.gsub('%', 'percent')
}

sfield = fields.map{ |m| "String :#{m.gsub(/\s+/,'_')}"}.join("\n")

DB = Sequel.sqlite('records.db')
eval("
DB.create_table? :users do
  primary_key :id 
	" + 
  sfield + "
end
")
p DB.schema(:users)

users = DB[:users]
reader.each_with_index do |entry,i|
	users.insert( [i] + entry )
end

users.each do |entry|
	puts entry
end
