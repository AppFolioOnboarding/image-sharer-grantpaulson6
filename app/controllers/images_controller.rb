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
      render :show
    else

    end
  end

  def show
    render
  end

  private

  def image_params
    params.require(:image).permit(:name, :url)
  end
end
