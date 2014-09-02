#! ruby
require 'sinatra'
require 'rufus-scheduler'
require_relative 'mysqlfunc'
require_relative 'linear_func'
#require_relative 'rtm_datamanager'
$hashitem=Hash.new
$hashtime=Hash.new
$hashvalue=Hash.new
$queue=Array.new
before do
	Thread.new do
			datamanager
	end
end
post '/' do
		time=params[:time]
		hostname=params[:hostname]
		itemk=params[:itemk]
		value=params[:value]
		#"get #{time}/n"
		getdata(time,hostname,itemk,value)
		"get #{showhash}\n"
end
def getdata(time,hostname,itemk,value)
		$hashvalue[hostname]=value
		$hashtime[time]=$hashvalue
		$hashitem[itemk]=$hashtime
end
def datamanager
		scheduler=Rufus::Scheduler.new
		svalue=0
		scheduler.every '1s' do
				#`echo "in datamanager" >> scheduler.txt`
				nowstr=`date -d "5 seconds ago" +%T`
				itemk,svalue,sumvalue,log=getsfunc(nowstr)
				if log.length==0
						insertdata(itemk,nowstr,svalue,sumvalue,0)
						#`echo "#{itemk}:#{svalue.to_s}-#{sumvalue.to_s}" > scheduler.txt`
				end
		end
		scheduler.join
end
def getsfunc(nowstr)
		nowstr=nowstr.lstrip.rstrip
		sumvalue=0
		$hashitem.each do |key,value|
		if value.include?(nowstr)
				#`echo "get time  #{sumvalue.to_s}" >> scheduler.txt`
				value[nowstr].each_value do |timevalue|
						sumvalue+=timevalue.to_i
				end
				i,log=getsvalue(nowstr,sumvalue)
				if log.length==0
						return key,i,sumvalue,""
				end
				return key,0,0,"error"
		else
				`echo "no time" > scheduler.txt`
				return key,0,0,"error"
		end
		end
end   
def getsvalue(str,value)
		svalue=0
		nowstr=str+" "+value.to_s
		if addqueue(nowstr)
				svalue=linear_func($queue)
				return svalue,""
		end
		return svalue,"error"
end
def addqueue(nowstr)
		if $queue.size<20
				$queue.push(nowstr)
				if $queue.size==20
						return true
				end
				return false
		else
				$queue.delete_at(0)
				$queue.push(nowstr)
				return true
		end
		return false
end
def showhash
		str=""
		$hashitem.each do |itemk,value|
				value.each do |time,value|
						value.each do |host,value|
								str+=itemk+":"+time+":"+host+":"+value
						end
				end
		end
		return str
end
