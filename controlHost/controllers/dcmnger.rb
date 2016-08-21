# coding: utf-8

require_relative '../models/host_model'
require_relative '../models/guest_model'
require_relative '../models/key_model'
require 'drb/drb'

# 接続先の URI
HOST2_URI="druby://192.168.1.12:8787"
HOST3_URI="druby://192.168.1.13:8787"
HOST4_URI="druby://192.168.1.14:8787"

#DataCenterManagerクラス

module DCManager

	#インスタンスを作成する
	def createInstance(params)

		guestname = params[:name]
		cpu = params[:cpu]
		mem = params[:mem]
		size = params[:guest_size]
		owner =  params[:owner]
		pass = params[:password]

		# DRbサーバを起動する
		DRb.start_service
		#起動するゲスト情報の登録
		g = GuestModel.new
		g.registGuest(guestname, owner, size)
		#起動するホストの選択
		h = HostModel.new
		hostid = h.selectHost()
		#各ホストへQueueの送信
		prm = "clone" 
		prms = {:prm => prm,
			:guestname => guestname,
			:cpu => cpu,
			:mem => mem,
			:guest_size => size,
			:owner => owner,
			:password => pass
		}
		obj = getHostObj(hostid)
		obj.enq(prms)
	end

	#インスタンスを起動する
	def start(params)
		name = params[:name]
		g = GuestModel.new
		g.start(name)

		h = HostModel.new
		hostid = h.selectHost()
		#各ホストへQueueの送信
		prm = "start"
		prms = {:guestname => guestname}
		obj = getHostObj(hostid)
		obj.enq(prms)
	end

	#インスタンスをシャットダウンする
	def shutdown(params)
		guestname = params[:name]
		g = GuestModel.new
		g.shutdown(name)

		h = HostModel.new
		hostid = h.selectHost()
		#各ホストへQueueの送信
		prm = "shutdown" 
		prms = {:guestname => guestname}

		obj = getHostObj(hostid)
		obj.enq(prms)

	end

	#インスタンスを削除する
	def delete(params)
		name = params[:name]
		g = GuestModel.new
		g.deleteInstance(name)

		h = HostModel.new
		hostid = h.selectHost()
		#各ホストへQueueの送信
		prm = "delete" 
		prms = {:guestname => guestname}
		obj = getHostObj(hostid)
		obj.enq(prms)
	end

	#インスタンスの情報を取得する
	def getGuestList(owner, name = nil)
		g = GuestModel.new
		if name != nil
			g.getInstanceInfo(owner,name)
		else
			g.getInsgtanceList(owner)
		end
	end

	#キーを登録する
	def registKey(params)
		name = params[:name]
		key = params[:key]
		k = KeyModel.new
		k.regist(name, key)
	end 

	#キューを送るホストを選択する
	def getHostObj(hostid)
		case hostid
		when 2; obj = DRbObject.new_with_uri(HOST2_URI)
		when 3; obj = DRbObject.new_with_uri(HOST3_URI)
		when 4; obj = DRbObject.new_with_uri(HOST4_URI)
		end

		return obj
	end

end   

