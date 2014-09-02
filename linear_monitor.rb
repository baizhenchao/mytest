#! ruby
def getdata(str)
		time_hash=Hash.new
		file=File.open("./#{str}")
		file.each do |line|
				linesp=line.split
				time=linesp[0][0,8]
				time_hash[time]=linesp[1].to_i
		end
		return time_hash
end
def mean_filter(timespan)
		span=timespan.to_i
		timevalue=getdata("flow_cnt_0806")
		testvalue=getdata("flow_cnt_0811")
		k_hash=Hash.new
		timestr="00:00:00"
		endstr="23:59:59"
		tmptime=timestr
		x_start=getx(timestr)
		x_end=getx(endstr)
		while x_start<(x_end-span)
				strtmp=gettime(x_start+span)
				k=linear_func(x_start,span-1,timevalue)
				k_hash[strtmp]=k
				x_start+=1
		end
		x_start=getx(timestr)
		#showdata(timevalue)
		showdata(testvalue)
		while x_start<(x_end-span)
				strtmp=gettime(x_start+span)
				k=linear_func(x_start,span-1,testvalue)
				#diff=Math.log(k_hash[strtmp])-Math.log(k)
				#puts k_hash[strtmp].to_s
				#puts k.to_s
				#puts diff.to_s
				#puts strtmp+"  "+k_hash[strtmp].to_s+"-"+k.to_s+" : "+diff.to_s
=begin
				if k>0
						if diff>0.5
							puts strtmp+"raise too fast:"+diff.abs.to_s
						elsif diff<-0.5
							puts strtmp+"raise too slow:"+diff.abs.to_s
						end
				else
						if diff>0.5
							puts strtmp+"down too slow:"+diff.abs.to_s
						elsif diff<-0.5
							puts strtmp+"down too fast:"+diff.abs.to_s
						end
				end
=end
				x_start+=1
		end
end
def linear_func(x,i,timevalue)
		xavg,yavg=0,0
		ix=x
		(0..i).each do
				xavg+=ix
				yavg+=gety(ix,timevalue)
				ix+=1
		end
		xavg=xavg/10
		yavg=yavg/10
		lxx,lyy,lxy=0,0,0
		ix=x
		(0..i).each do
				y=gety(ix,timevalue)
				lxx+=(ix-xavg)*(ix-xavg)
				lyy+=(y-yavg)*(y-yavg)
				lxy+=(ix-xavg)*(y-yavg)
		end
		b=lxy/lxx
		return b.to_f
end
#str=changetime("05:06:07",-1)
def changetime(start,sec)
		t=Time.gm *"2014:08:08:#{start}".split(":")
		tc=t+sec
		return tc.strftime("%H:%M:%S")
end
def showdata(hash)
		hash.each_value do |value|
				puts value.to_s
		end
end
def getx(time)
		t=Time.gm *"2014:08:08:00:00:00".split(":")
		t2=Time.gm *"2014:08:08:#{time}".split(":")
		x=(t2-t).round
		return x.to_i
end
def gety(x,funchash)
		str=gettime(x)
		return funchash[str].to_f
end
def gettime(x)
		ss=x%60
		mm=x%(60*60)/60
		hh=x/(60*60)
		if hh>24
				hh=hh%24
		end
		ss=ss.to_s
		mm=mm.to_s
		hh=hh.to_s
		if ss.size<2
				ss="0"+ss
		end
		if mm.size<2
				mm="0"+mm
		end
		if hh.size<2
				hh="0"+hh
		end
		str=hh+":"+mm+":"+ss
		return str
end
mean_filter 20

