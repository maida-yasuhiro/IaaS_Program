#coding: utf-8

require 'sinatra'
require 'json'
require_relative '/root/work/sinatra/controllers/dcmnger.rb'
require 'thread'
include DCManager

set :bind, '0.0.0.0'

q = Queue.new

#インスタンス新規作成
post '/instance' do

=begin  #デバッグ用
		task = {:params => {
			:name => params[:name],
			:cpu => params[:cpu],
			:mem => params[:mem],
			:guest_size => params[:guest_size],
			:owner => params[:owner],
			:password => params[:password]}}

		  DCManager.createInstance(task[:params])
=end
	q.push({
		:cmd => :create,
		:params => {
			:name => params[:name],
			:cpu => params[:cpu],
			:mem => params[:mem],
			:guest_size => params[:guest_size],
			:owner => params[:owner],
			:password => params[:password]
		}
	})
	"インスタンス作成中 インスタンス名 : #{params[:name]}.\n"
end

#インスタンスの起動
get '/instance/:name/start' do
	q.push({
		:cmd => :start,
		:params => {
			:name => params[:name]
		}
	})
	"インスタンス起動中 インスタンス名 : #{params[:name]}.\n"
end

#インスタンスの停止
get '/instance/:name/shutdown' do
	q.push({
		:cmd => :shutdown,
		:params => {
			:name => params[:name]
		}
	})
	"インスタンスシャットダウン中 インスタンス名 : #{params[:name]}.\n"
end

#インスタンスの削除
delete '/instance' do
=begin	#デバッグ用
	task = {:params => {
			:name => params[:name]}}
		DCManager.delete(task[:params])
=end
	q.push({
		:cmd => :delete,
		:params => {
			:name => params[:name]
		}
	})
	"インスタンス削除 インスタンス名 : #{params[:name]}.\n"
end

#インスタンスの状態取得
get '/instance/:name' do
	guest = DCManager.getGuestList(params[:name])
	guest.to_json
end

#インスタンスの一覧取得
get '/instance' do
	list = DCManager.getGuestList()
	list.to_json
end

#鍵の情報登録
post '/key' do
	DCManager.registKey({
		:name => params[:name],
		:key => params[:key]
	})
end


th = Thread.start do
	while task = q.pop
		case task[:cmd]
		when :create
			DCManager.createInstance(task[:params])
		when :start
			DCManager.start(task[:params])
		when :shutdown
			DCManager.shutdown(task[:params])
		when :delete
			DCManager.delete(task[:params])
		end
	end
end
