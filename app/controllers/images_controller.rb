class ImagesController < ApplicationController
  before_action :filter_tags

  def home
    @images = if filter_tags.none?
                Image.order(created_at: :desc)
              else
                Image.tagged_with(filter_tags).order(created_at: :desc)
              end
  end

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
    end
  end

  def show
    @image = Image.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = 'Unable to find image.'
    redirect_to root_path
  end

  private

  def image_params
    params.require(:image).permit(:name, :url, tag_list: [])
  end

  def filter_tags
    @filter_tags ||= params.permit(tag_list: [])[:tag_list]&.uniq || []
  end
end
