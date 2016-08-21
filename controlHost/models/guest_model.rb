# coding: utf-8
require 'sequel'
require_relative 'host_model'
require 'json'

DB = Sequel.connect('sqlite:///root/work/sinatra/database/mkData.db')

class Guests < Sequel::Model
end


#ゲスト情報DBを管理するクラス

class GuestModel 
	#初期化
	def initialize()
	end

	#データベースの変更
	def registGuest(guestname, owner, size)
		#Guest情報テーブルにデータを登録
		Guests.insert(:guest_name  => guestname, :owner => owner, :guest_size => size, :guest_status => "starting")
		#Host情報テーブルのデータを変更
		h = HostModel.new
		hostid = h.selectHost()
		type = "clone"
		h.modifyAmount(hostid, size, type)
	end

	#VMの開始
	def start(name)
		guest = Guests.filter(:guest_name => name).update(:guest_status => "starting")
	end

	#VMの停止
	def shutdown(name)
		guest = Guests.filter(:guest_name => name).update(:guest_status => "stop")
	end

	#VMの削除
	def deleteInstance(name)
		Guests.filter(:name => name).delete
		h = HostModel.new
		h.modifyAmount(host, "release")
	end

	def getInstanceInfo(owner, name)
		guest = Guests.filter(:owner => owner, :name => name).get(:guest_name)
		p guest
	end

	def getInsgtanceList(owner)
		guest = Guests.filter(:owner => owner).get(:guest_name)
		p guest
	end	
end 
