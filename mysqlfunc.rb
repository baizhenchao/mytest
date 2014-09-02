#! ruby
require 'mysql'
def getdata
begin
		db=Mysql.init
		db=Mysql.real_connect("127.0.0.1","xiaobai","123","xiaobai",3336)
		rslt=db.query("select * from friend")
		while row=rslt.fetch_row do
				puts row.join(" ")
		end
rescue Mysql::Error=>e
		puts "Error code: #{e.errno}"
		puts "Error message: #{e.error}"
		puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
ensure
		db.close if db
end
end
def insertdata(itemk,time,svalue,sumvalue,value)
begin
		db=Mysql.init
		db=Mysql.real_connect("127.0.0.1","xiaobai","123","xiaobai",3336)
		db.query("insert into linear_data(itemk,time,svalue,sumvalue,value) value('#{itemk}','#{time}','#{svalue}','#{sumvalue}','#{value}')")
		result=db.affected_rows
rescue Mysql::Error=>e
		puts "Error code: #{e.errno}"
		puts "Error message: #{e.error}"
		puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
ensure
		db.close if db
end
return result
end

#getdata
#res=insertdata("thisisatest3","20140815103160","0.001","0.5","0")
#puts res
#result=sqlfunc
#puts result
