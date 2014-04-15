require 'sinatra/base'

class Application < Sinatra::Application

  enable :sessions

  def initialize(app=nil)
    super(app)
    @users_table = DB[:users]
 end

  get '/' do
    erb :index, locals: {email: session[:email]}
  end

  get '/register' do
    erb :register
  end

  post '/' do
    email = params[:email]
    password = params[:password]
    @users_table.insert(email: email, password: password)
    session[:email] = email
    redirect '/'
  end

  get '/logout' do
    session.clear
    redirect '/'
  end
end