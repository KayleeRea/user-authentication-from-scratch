require 'sinatra/base'
require 'bcrypt'
class Application < Sinatra::Application

  enable :sessions

  def initialize(app=nil)
    super(app)
    @users_table = DB[:users]
  end

  get '/' do
    error = nil
    erb :index, locals: {email: session[:email]}
  end

  get '/register' do
    erb :register
  end

  post '/' do
    email = params[:email]
    password = params[:password]
    hashed_password = BCrypt::Password.create(password)
    @users_table.insert(email: email, password: hashed_password)
    session[:email] = email
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
      error = "That user does not exist"
      erb :login, locals: {error: error}
    else
      hashed_password = user.first[:password]
      given_password = params[:password]
      converted_password = BCrypt::Password.new(hashed_password)
      if hashed_password == converted_password
        session[:email] = params[:email]
        redirect '/'
      else
        error = ""
        erb :index
      end
    end

  end
end