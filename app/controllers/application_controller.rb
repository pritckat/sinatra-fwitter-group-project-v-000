require './config/environment'
require 'pry'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    @users = User.all
    erb :'users/index'
  end

  get '/signup' do
    erb :'users/new'
  end

  post '/signup' do
    binding.pry
    if params[:username] == "" || params[:password] == "" || params[:email] == ""
      redirect to "/signup"
    else
      user = User.create(params[:user])

      redirect to "/tweets"
    end
  end

  get '/login' do

    erb :'users/login'
  end

  post '/login' do
    user = User.find_by(username: params[:user][:username])
    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      redirect to "/tweets"
    else
      redirect to "/login"
    end
  end

  get '/logout' do
    session.clear
    redirect "/"
  end

  get '/tweets' do
    @tweets = Tweet.all
    erb :'tweets/index'
  end

  get '/tweets/new' do
    if !logged_in?
      redirect to "/login"
    else

      erb :'tweets/new'
    end
  end

  post '/tweets' do
    @tweet = Tweet.create(params[:tweet])

    redirect to "/tweets/#{@tweet.id}"
  end

  get '/tweets/:id' do
    @tweet = Tweet.find(params[:id])

    erb :'tweets/show'
  end

  get '/tweets/:id/edit' do
    @tweet = Tweet.find(params[:id])

    erb :'tweets/edit'
  end

  patch '/tweets/:id' do
    @tweet = Tweet.find_by_id(params[:id])
    @tweet.content = params[:tweet][:content]
    @tweet.save
    redirect to "/tweets/#{@tweet.id}"
  end

  delete '/tweets/:id/delete' do
    @tweet = Tweet.find(params[:id])
    @tweet.delete
    redirect to '/tweets'
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
