# -*- coding: utf-8 -*-
Cs993::App.controllers :contact do
  
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

  get :index, :map => 'contact/index', :provides => [:html, :xls] do
    @section = 'contact'
    @items = Contact.all
    render 'contact/index'
  end

  get :download do
    content_type 'application/vnd.ms-excel;charset=utf8'
    @items = Contact.all
    render 'contact/xls', :layout => false, :format => :xhtml
  end

  get :new do
    @contact = Contact.new
    render 'contact/new'
  end

  post :create do
    @contact = Contact.new(params[:contact])
    if @contact.save
      flash[:success] = '加入成功'
      redirect url(:contact, :index)
    else
      flash[:error] = '加入失败'
      render 'contact/new'
    end
  end

  get :edit do
    @contact = Contact.find_by_id(params[:id])
    render 'contact/edit'
  end

  get :delete do
    @contact = Contact.find(params[:id])
    Contact.destroy(params[:id]) if @contact
    redirect url(:contact, :index)
  end

  post :update do
    @contact = Contact.find_by_id(params[:id])
    if @contact.update_attributes(params[:contact])
      flash[:success] = '更新成功'
      redirect url(:contact, :index)
    else
      flash[:error] = '更新失败'
      render 'contact/edit'
    end
  end

end
