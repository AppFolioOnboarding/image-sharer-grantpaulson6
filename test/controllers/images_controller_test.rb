require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  def test_home
    get root_path

    assert_response :success
    assert_template :home
  end

  def test_home__renders_index_of_images
    get root_path

    assert_response :success
    assert_template partial: '_index'
  end

  def test_home__displays_images_by_desc_date_created
    Image.create!(name: 'oldest', url: 'https://www.pewtrusts.org/-/media/post-launch-images/'\
'2018/01/istock-479409864/istock-479409864_16x9.jpg?la=en&hash=A70682998CAE7084094117D7CA8E14C340BCEC55')
    Image.create!(name: 'newest', url: 'https://www.pewtrusts.org/-/media/post-launch-images/'\
'2018/01/istock-479409864/istock-479409864_16x9.jpg?la=en&hash=A70682998CAE7084094117D7CA8E14C340BCEC55')

    get root_path

    assert_response :success
    assert_select '.card:first-child p', 'newest'
  end

  def test_new
    get new_image_path

    assert_response :success
    assert_template :new
  end

  def test_show__succeed
    image = Image.create!(name: 'zion', url: 'https://www.pewtrusts.org/-/media/post-launch-images/'\
'2018/01/istock-479409864/istock-479409864_16x9.jpg?la=en&hash=A70682998CAE7084094117D7CA8E14C340BCEC55')
    get image_url(image)

    assert_response :success
    assert_template :show
    assert_select '.page-header', /zion/
  end

  def test_show__fail
    get image_url 500

    assert_response :redirect
    assert_equal 'Unable to find image.', flash[:notice]
  end

  def test_create__succeed
    assert_difference 'Image.count' do
      image_params = { image: { name: 'a cat', url: 'https://d17fnq9dkz9hgj.cloudfront.net/uploads/'\
'2012/11/101438745-cat-conjunctivitis-causes.jpg' } }
      post images_path, params: image_params
    end

    assert_response :redirect
    # Note: using query parameters in the url (from the notice) would require this testing pattern
    # instead of using assert_redirect_to
    assert_equal image_url(Image.last), @response.redirect_url
    assert_equal 'Image url successfully saved.', flash[:notice]
  end

  def test_create__fail
    assert_no_difference 'Image.count' do
      image_params = { image: { name: '', url: '' } }
      post images_path, params: image_params
    end

    assert_response :unprocessable_entity
    assert_includes flash[:errors] && flash[:errors][:name], 'can\'t be blank'
    assert_includes flash[:errors] && flash[:errors][:url], 'must be valid'
  end
end
