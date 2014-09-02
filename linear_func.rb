#! ruby
def linear_func(itemlist)
		xavg,yavg=0,0
		n=itemlist.size
		itemlist.each do |str|
				time=str.split[0]
				y=str.split[1].to_i
				x=getx(time)
				xavg+=x
				yavg+=y
		end
		xavg=xavg/10
		yavg=yavg/10
		lxx,lyy,lxy=0,0,0
		itemlist.each do |str|
				time=str.split[0]
				y=str.split[1].to_i
				x=getx(time)
				lxx+=(x-xavg)*(x-xavg)
				lyy+=(y-yavg)*(y-yavg)
				lxy+=(x-xavg)*(y-yavg)
		end
		b=lxy/lxx
		return b
end
def getx(time)
		t=Time.gm *"2014:08:08:00:00:00".split(":")
		t2=Time.gm *"2014:08:08:#{time}".split(":")
		x=(t2-t).round
		return x
end
def prolist
		newlist=Array.new
		(1..10).each do |i|
				x="00:00:0"+i.to_s
				y=99.to_s
				newlist.push(x+" "+y)
		end
		b=linear_func(newlist)
		`echo #{b} > test.txt`
end
#prolist
