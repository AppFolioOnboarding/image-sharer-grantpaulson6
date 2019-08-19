require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  def test_home
    get root_path

    # should we test what template is rendered?
    assert_response :success
    assert_select '#header', /Welcome/
  end

  def test_new
    get new_image_path

    assert_response :success
    assert_select '#header', /Create/
  end

  def test_show
    image = Image.create!(name: 'zion', url: 'https://www.pewtrusts.org/-/media/post-launch-images/'\
'2018/01/istock-479409864/istock-479409864_16x9.jpg?la=en&hash=A70682998CAE7084094117D7CA8E14C340BCEC55')
    get image_url(image)

    assert_response :success
    assert_select '#header', /zion/
  end

  def test_create__succeed
    assert_difference 'Image.count' do
      image_params = { image: { name: 'a cat', url: 'https://d17fnq9dkz9hgj.cloudfront.net/uploads/'\
'2012/11/101438745-cat-conjunctivitis-causes.jpg' } }
      post images_path, params: image_params
    end

    assert_response :redirect
    # Note: query parameters in the url (from the notice) would require this testing pattern
    # instead of using assert_redirect_to
    assert_match image_url(Image.last), @response.redirect_url
    assert_equal 'Image url successfully saved.', flash[:notice]
  end

  def test_create__fail
    assert_no_difference 'Image.count' do
      image_params = { image: { name: '', url: '' } }
      post images_path, params: image_params
    end

    # QUESTION: best practice for displaying (wrapper classes with form) and testing each error
    assert_response :unprocessable_entity
    assert_select '.name.error', 'Name can\'t be blank'
    assert_select '.url.error', 'Url must be valid'
  end
  # test 'test_home' do
  #   get root_url
  #
  #   assert_select 'h1', /Welcome*/
  #   assert_response :success
  # end
end
