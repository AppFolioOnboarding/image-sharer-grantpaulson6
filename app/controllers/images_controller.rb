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
      redirect_to :show
    end
  end

  private

  def image_params
    debugger
    params.require(:image).permit(:name, :url)
  end

  def show
    render
  end
end
