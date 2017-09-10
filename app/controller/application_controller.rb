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
  	if session[:user_id]
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
    if session[:user_id]
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
    if session[:user_id]
      session.clear
      redirect to '/login'
    else
      redirect to '/'
    end
  end

  get '/workouts' do
    if session[:user_id] 
      @user = User.find_by_id(session[:user_id])
      @workouts = Workout.all
      erb :'/workouts/index'
    else
      redirect to '/login'
    end
  end

  get '/workouts/new' do
    if current_user
      erb :'/workouts/new'
    else 
      redirect to "/login"
    end
  end

  get '/workouts/:id' do
    if session[:user_id]
     @workout = Workout.find_by_id(params[:id])
     erb :'/workouts/show'
    else
      redirect to '/login'
    end
  end

  post '/workouts' do 
    if params[:workout] && params[:workout][:exercises] == ""
      redirect to '/workouts/new'
      else
        @workout = Workout.create(name: params[:workout][:name], date: params[:workout][:date])
        params[:workout][:exercises].each do |exercise_data| 
          exercise = Exercise.new(exercise_data)  
          exercise.workout = @workout
          exercise.save
        end
    end
    current_user.workouts << @workout
    redirect to "/workouts/#{@workout.id}"
  end


  get '/workouts/:id/edit' do
    if session[:user_id]
      @workout = Workout.find_by_id(params[:id])
      if @workout.user_id == current_user.id
         erb :'/workouts/edit_workout'
      else
         redirect to '/workouts'
      end
    else
      redirect '/login'
    end
  end

  patch '/workouts/:id' do
    @workout = Workout.find_by_id(params[:id])
    if params[:workout] && params[:workout][:exercises] == ""
      redirect to '/workouts/:id/edit'
    else
      @workout = Workout.update(name: params[:workout][:name], date: params[:workout][:date])
        params[:workout][:exercises].each do |exercise_data| 
          exercise = Exercise.update(exercise_data)  
          exercise.workout = @workout
          exercise.save
        end
      redirect to "/workouts/#{@workout.id}"
    end
  end

  delete '/workouts/:id/delete' do
    if current_user
      @workout = Workout.find_by(params[:id])
      if @workout.user_id == current_user.id
        @workout.delete
        redirect to '/login'
      else
        redirect to '/workouts'
      end
    else
      redirect to '/login'
    end
  end

  helpers do
    def current_user
      @current_user ||= User.find_by_id(session[:user_id])
    end
  end
end

