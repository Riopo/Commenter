# conding: utf-8
require 'sinatra'
require 'sinatra/reloader'
require 'active_record'
require 'sinatra/json'

ActiveRecord::Base.establish_connection(
	"adapter" => "sqlite3",
	"database" => "./bbs.db"
)

class Comment < ActiveRecord::Base
end

#before < main�����O ���s�p�T���v��
before do
	@author = "nishida"
	@title = "Commenter"
end

before '/admin/*' do
	@msg = "admin area"
end


#after < main������ ���s�p�T���v��
after do
 logger.info "page displayed successfully"
end


#���ʊ֐� helpers
helpers do
	include Rack::Utils
	alias_method :h, :escape_html
end

#�e�A�N�V�����w��
get '/' do
	@comments = Comment.order("id desc").all
	erb :index
end

get '/screen' do
	@comments = Comment.order("id desc").where(:dspflg => 0)
	erb :screen
end

get '/comments' do  
	@comments = Comment.order("id desc").where(:dspflg => 0).to_a
	comments = Array.new()
	@comments.each do |comment|
		comments.push({comment_body: comment.body, id: comment.id})
	end
	output = {comments: comments}
	json output
end

post '/new' do
  Comment.create({:body => params[:body]})
  redirect '/'
end

post '/delete' do
  Comment.find(params[:id]).destroy
  redirect '/'
end

post '/updateflg' do
  Comment.find(params[:id]).update_column(:dspflg, 1)
end

get '/showall' do
  Comment.update_all :dspflg => 0
  redirect '/'
end