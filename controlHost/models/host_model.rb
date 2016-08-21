require 'sequel'
require 'json'

#VM用イメージを管理するクラス
DB = Sequel.connect('sqlite:///root/work/sinatra/database/mkData.db')

class Hosts < Sequel::Model
end

class HostModel
	#ディスク使用量の増減
	#clone作成でサイズ分減らす(VMを削除した場合、サイズを増やす)
	def modifyAmount(host_id, size, type)
=begin
#うまく動かないので、コメントアウト中
		if type == "clone"
			size_all = Hosts.filter(:host_id => host_id).get(:host_amount_size)
			size_all -= size
			Hosts.filter(:host_id => host_id).update(:host_amount_size => size_all)
		else
			size_all = Hosts.filter(:host_id => host_id).get(:host_amount_size)
			size_all += size
			Hosts.filter(:host_id => host_id).update(:host_amount_size => size_all)
		end
=end
	end

	#ホストを選択する
	#ディスク使用量が低いホストを選択）
	def selectHost()
=begin
#うまく動かないので、コメントアウト中
		# return(Hosts[].order("guest_count").first)
=end
        #現状、起動マシンナンバーを手動で返す用にしている
		return(3)
	end  
end 
