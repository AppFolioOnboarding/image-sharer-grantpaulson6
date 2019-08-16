class ImagesController < ApplicationController
  def home
    render
  end

  def new
    @image = Image.new
    render
  end

  def create
    @image = Image.new(image_params)
    if @image.save
      redirect_to image_path @image
    else
      flash[:errors] = @image.errors.messages
      redirect_to new_image_path
    end
  end

  def show
    @image = Image.find(params[:id])
    render
  end

  private

  def image_params
    params.require(:image).permit(:name, :url)
  end
end
