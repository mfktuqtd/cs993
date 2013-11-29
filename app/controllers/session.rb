Cs993::App.controllers :session do
  
  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   'Maps to url '/foo/#{params[:id]}''
  # end

  # get '/example' do
  #   'Hello world!'
  # end
  layout :front

  get :new, :map => 'session/login' do
    render "session/new", nil
  end

  get :logout, :map => 'session/logout' do
    set_current_account(nil)
    redirect_back_or_default('/')
  end

  post :create do
    puts "login params: #{params}"
    if account = Account.authenticate(params[:name],  params[:password])
      set_current_account(account)
      redirect_back_or_default('/')
      #redirect '/'
    else
      params[:name], params[:password] = h(params[:name]), h(params[:password])
      flash[:error] = pat('login.error')
      redirect url(:session, :new)
    end
  end


end
