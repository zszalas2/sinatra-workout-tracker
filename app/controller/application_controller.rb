require './config/environment'
require 'pry'
class ApplicationController < Sinatra::Base

    configure do
     set :public_folder, 'public'
     set :views, 'app/views'
     enable :sessions
     set :session_secret, "secret"
    end

  get '/' do
  	erb :home_page
  end

  get '/signup' do
  	if logged_in?
  		redirect '/workouts'
  	else
  		erb :'/users/signup'
  	end
  end

  post '/signup' do
    if params[:username].empty? || params[:email].empty? || params[:password].empty?
      redirect to '/signup'
    else
      @user = User.create(username: params[:username], email: params[:email], password: params[:password])
      session[:user_id] = @user.id
      redirect '/workouts'
    #no user name- so sign up. if username is empty throw error
    #no email- no sign up. if email is empty throw error
    #no password - no sign up. If password is empty throw error
    #if someone is already logged in, redirect to twitter index.
    end
  end

  get '/login' do
    #displays the form if user isn't already logged in
    if logged_in?
       redirect to "/workouts"
     else
       erb :'/users/login'
    end
  end

  post '/login' do
    @user = User.find_by(username: params["username"])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/workouts"
    else
      redirect "/login"
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect to '/login'
    else
      redirect to '/'
    end
  end

  get '/workouts/new' do
    if logged_in? && current_user
      erb :'/workouts/new'
    else 
      redirect to "/login"
    end
  end

  get '/workouts/:id' do
    @workout = Workout.find_by_id(params[:id])
    erb :'/workouts/show'
    
  end

  post '/workouts' do 
    binding.pry
  end


  get '/workouts' do
    if logged_in? && current_user
      @workouts = Workout.all
      erb :'/workouts/index'
    else
      redirect to '/login'
    end
  end



  helpers do
     def current_user
       if session[:user_id] != nil
        User.find_by_id(session[:user_id])
       end
     end
 
     def logged_in?
       !!current_user
     end
   end
end