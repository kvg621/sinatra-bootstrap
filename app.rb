require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello stranger'
  end
end

before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/' do
  erb 'Хотите попасть сюда: <a href="/secure/place">SECRET</a>?'
end

get '/about' do
  erb :about
end

get '/contact' do
  erb :contact
end

get '/visit' do
  erb :visit
end

post '/visit' do
  @username=params[:username]
  @phone=params[:phone]
  @spec=params[:spec]
  @datetime=params[:datetime]
  @color=params[:color]

  erb "OK. : #{@username}  #{@phone} #{@datetime} #{@spec} #{@color}"
end
get '/login/form' do
  erb :login_form
end

post '/login/attempt' do
  session[:identity] = params['username']
  where_user_came_from = session[:previous_url] || '/'
  redirect to where_user_came_from
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end

get '/secure/place' do
  erb 'This is a secret place that only <%=session[:identity]%> has access to!'
end
