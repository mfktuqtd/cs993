# -*- coding: utf-8 -*-
require 'opencv'
include OpenCV
Cs993::App.controllers :photo do
  
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

  get :index, :map => '/photo/index' do
    @section = 'photo'
    @items = Face.order('RAND()')
    render "photo/index"
  end

  get :upload do
    @faces = session[:faces]
    @origin_file_name = session[:origin_file_name]
    render "photo/upload"
  end


  data = '/usr/local/share/OpenCV/haarcascades/haarcascade_frontalface_alt.xml'
  detector = CvHaarClassifierCascade::load(data)
  width_fit = 1024
  height_fit = 768

  width_thumbnail = 600
  height_thumbnail = 450

  post :create do
    unless params[:file] &&
        (tmpfile = params[:file][:tempfile]) &&
        (name = params[:file][:filename])
      @error = "No file selected"
      redirect "/photo/upload"
      return 
    end
    tmpfile
    @faces = []
    image = CvMat.load(tmpfile.path)
    
    #resize to fit 1024 * 768
    image_resize = resize_image(image, width_fit, height_fit)
    image_resize.save_image(File.join(Padrino.root, "public", "images", "photos", name))
    image_thumbnail = resize_image(image, width_thumbnail, height_thumbnail)
    image_thumbnail.save_image(File.join(Padrino.root, "public", "images", "thumbnails", name))

    id = 0
    file_name = File.basename(name, File.extname(name))
    detector.detect_objects(image_resize).each do |region|
      x = region.x - region.width / 2
      x = 0 if x < 0 
      y = region.y - region.height / 2
      y = 0 if y < 0
      width = region.width * 2
      width = image_resize.width - x if (x + width) > image_resize.width
      height = region.height * 2
      height = image_resize.height - y if (y + height) > image_resize.height
      subimage = image_resize.sub_rect(CvRect.new(x, y, width, height))
      face_file = "#{file_name}_#{id}.png"
      subimage.save_image(File.join(Padrino.root, "public", "images", "faces", face_file))
      @faces << face_file
      id += 1
    end
    session[:faces] = @faces
    session[:origin_file_name] = name
    redirect url(:photo, :upload)
  end

  post :upwall do
    @selected_faces = params[:selected_faces]
    puts "@selected_faces : #{@selected_faces}"
    if @selected_faces
      @selected_faces.each do |item|
        Face.find_or_create_by_file_name(item) do |face|
          face.editor = current_account.name
          face.origin_file_name = session[:origin_file_name]
          face.save
        end
      end
      session[:faces] = nil
      session[:origin_file_name] = nil
      redirect url(:photo, :index)
    else
      flash[:notice] = '请点击图片，选中需要上传的头像'
      redirect url(:photo, :upload)
    end
  end

  get :edit do
    @face = Face.find(params[:id])
    render 'photo/edit'
  end

  post :update do
    @face= Face.find_by_id(params[:id])
    if @face.update_attributes(params[:face])
      redirect url(:photo, :index)
    else
      render 'photo/edit'
    end
  end

  get :delete do
    @face = Face.find(params[:id])
    Face.destroy(params[:id]) if @face
    redirect url(:photo, :index)
  end
end
