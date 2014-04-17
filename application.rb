require 'sinatra/base'
require 'bcrypt'
class Application < Sinatra::Application

  enable :sessions

  def initialize(app=nil)
    super(app)
    @users_table = DB[:users]
  end

  def passwords_not_equal?(password, user)
    hashed_password = user[:password]
    converted_password = BCrypt::Password.new(hashed_password)
    converted_password != password
  end

  def find_user_in_database(id)
    @users_table.where(id: session[:id]).first
  end

  get '/' do
    user = find_user_in_database(session[:id])
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
    given_password = params[:password]
    user = @users_table.where(email: params[:email]).first
    if  user.nil? || passwords_not_equal?(given_password, user)
      error = "Email/Password is invalid"
      erb :login, locals: {error: error}
    else
      session[:id] = user[:id]
      redirect '/'
    end
  end

  get '/users' do
    user = find_user_in_database(session[:id])
    if user && user[:admin]
      email = user[:email]
      erb :users, locals: {email: email}
    else
      erb :get_out
    end
  end
end