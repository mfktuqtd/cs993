# Helper methods defined here can be accessed in any controller or view in the application

Cs993::App.helpers do
  # def simple_helper_method
  #  ...
  # end

  def resize_image(image, width_fit, height_fit)
    if (image.width > width_fit) or (image.height > height_fit)
      w = width_fit / image.width.to_f
      h = height_fit / image.height.to_f
      if (w < h)
        new_w = image.width * w
        new_h = image.height * w
      else
        new_w = image.width * h
        new_h = image.height * h
      end
      image_resize = image.resize(CvSize.new(new_w.to_i, new_h.to_i));
    else
      image_resize = image
    end
    image_resize
  end

end
