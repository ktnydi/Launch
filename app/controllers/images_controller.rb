class ImagesController < ApplicationController
  def update
    upload_file = image_params[:file]
    image = {}
    if upload_file != nil
      image[:filename] = upload_file.original_filename
      image[:file] = upload_file.read
    end
    @image = current_user.image
    @image.filename = image[:filename]
    @image.file = image[:file]
    if @image.save
      redirect_to root_path
    else
      puts "save failed"
    end
  end

  def destroy
    image = current_user.image
    image.assign_attributes(filename: "", file: "")
    image.save
    redirect_to edit_user_registration_path
  end

  def show_image
    @image = current_user.image
    send_data @image.file, :type => 'image/jpeg'
  end

  private
    def image_params
      params.permit(:file)
    end
end
