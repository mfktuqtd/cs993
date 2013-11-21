# -*- coding: utf-8 -*-
Cs993::App.controllers :account do
  
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

  get :register, :map => '/register' do
    @account = Account.new
    render 'account/register'
  end

  post :create do
    @account = Account.new(params[:account])
    @account.role = 'user'
    if @account.save
      flash[:success] = '注册成功，请登入邮箱激活该账户'
      set_current_account(@account)
      redirect '/'
    else
      flash.now[:error] = '注册失败'
      render '/account/register'
    end
  end


end
