class ImagesController < ApplicationController
  def home; end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)
    if @image.save
      flash[:notice] = 'Image url successfully saved.'
      redirect_to image_path @image
    else
      flash[:errors] = @image.errors.messages
      render :new, status: :unprocessable_entity
      # QUESTION: would we want to redirect_to new_image_path to maintain consistent URL for client? (shows as
      # /images after failure)
    end
  end

  def show
    @image = Image.find(params[:id])
  end

  private

  def image_params
    params.require(:image).permit(:name, :url)
  end
end
