require 'sinatra/base'
require 'bcrypt'
class Application < Sinatra::Application

  enable :sessions

  def initialize(app=nil)
    super(app)
    @users_table = DB[:users]
  end

  get '/' do
    #if the user is an admin, set admin = true else false

    user = @users_table.where(id: session[:id]).first
    unless user.nil?
      email = user[:email]
      admin = user[:admin]
    end

    erb :index, locals: {id: session[:id], email: email, admin: admin}
  end

  get '/register' do
    erb :register
  end

  post '/' do
    email = params[:email]
    password = params[:password]
    hashed_password = BCrypt::Password.create(password)
    id = @users_table.insert(email: email, password: hashed_password)
    session[:id] = id
    redirect '/'
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/login' do
    error = nil
    erb :login, locals: {error: error}
  end

  post '/login' do
    user = @users_table.where(email: params[:email]).to_a
    if user.empty?
      error = "Email/Password is invalid"
      erb :login, locals: {error: error}
    else
      hashed_password = user.first[:password]
      given_password = params[:password]
      converted_password = BCrypt::Password.new(hashed_password)
      if converted_password == given_password
        session[:id] = user.first[:id]
        redirect '/'
      else
        error = "Email/Password is invalid"
        erb :login, locals: {error: error}
      end
    end
  end

  get '/users' do
    user = @users_table.where(id: session[:id])
    email = user.first[:email]
    erb :users, locals: {email: email}
  end
end