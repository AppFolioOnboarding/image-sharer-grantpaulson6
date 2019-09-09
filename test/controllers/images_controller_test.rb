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
    assert_template partial: '_tiles'
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

  def test_home__filters_by_tags
    Image.create!(name: 'has tags', url: 'https://www.pewtrusts.org/-/media/post-launch-images/'\
'2018/01/istock-479409864/istock-479409864_16x9.jpg?la=en&hash=A70682998CAE7084094117D7CA8E14C340BCEC55',
                  tag_list: %w[mountains rivers oceans])
    Image.create!(name: 'incorrect tags', url: 'https://www.pewtrusts.org/-/media/post-launch-images/'\
'2018/01/istock-479409864/istock-479409864_16x9.jpg?la=en&hash=A70682998CAE7084094117D7CA8E14C340BCEC55',
                  tag_list: %w[mountains lakes])

    get root_path, params: { tag_list: %w[mountains rivers] }

    assert_response :success
    assert_select '.card', 1
    assert_select '.card p', 'has tags'
  end

  def test_home__filters_by_nonexistent_tag
    Image.create!(name: 'has tags', url: 'https://www.pewtrusts.org/-/media/post-launch-images/'\
'2018/01/istock-479409864/istock-479409864_16x9.jpg?la=en&hash=A70682998CAE7084094117D7CA8E14C340BCEC55',
                  tag_list: %w[mountains rivers oceans])
    Image.create!(name: 'incorrect tags', url: 'https://www.pewtrusts.org/-/media/post-launch-images/'\
'2018/01/istock-479409864/istock-479409864_16x9.jpg?la=en&hash=A70682998CAE7084094117D7CA8E14C340BCEC55',
                  tag_list: %w[mountains lakes])

    get root_path, params: { tag_list: %w[mountains boats] }

    assert_response :success
    assert_select '.card', false
  end

  def test_new
    get new_image_path

    assert_response :success
    assert_template :new
  end

  def test_show__succeed
    image = Image.create!(name: 'zion', url: 'https://www.pewtrusts.org/-/media/post-launch-images/'\
'2018/01/istock-479409864/istock-479409864_16x9.jpg?la=en&hash=A70682998CAE7084094117D7CA8E14C340BCEC55',
                          tag_list: %w[furry feline orange])
    get image_url(image)

    assert_response :success
    assert_template :show
    assert_select '.page-header', /zion/
    assert_select '.tags', 3
  end

  def test_show__fail
    get image_url 1000

    assert_response :redirect
    assert_equal 'Unable to find image.', flash[:notice]
  end

  def test_create__succeeds_with_tags
    assert_difference 'Image.count', 1 do
      image_params = { image: { name: 'a cat', url: 'https://d17fnq9dkz9hgj.cloudfront.net/uploads/'\
'2012/11/101438745-cat-conjunctivitis-causes.jpg', tag_list: %w[furry feline orange] } }
      post images_path, params: image_params
    end

    assert_redirected_to image_path(Image.last)
    assert_equal 'Image url successfully saved.', flash[:notice]
    assert_equal 'a cat', Image.last.name
    assert_equal 3, Image.last.tags.count
  end

  def test_create__succeeds_without_tags
    assert_difference 'Image.count', 1 do
      image_params = { image: { name: 'a cat', url: 'https://d17fnq9dkz9hgj.cloudfront.net/uploads/'\
'2012/11/101438745-cat-conjunctivitis-causes.jpg' } }
      post images_path, params: image_params
    end

    assert_redirected_to image_path(Image.last)
    assert_equal 'Image url successfully saved.', flash[:notice]
    assert_equal 'a cat', Image.last.name
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

  def test_destroy__succeed
    image = Image.create!(name: 'a cat', url: 'https://d17fnq9dkz9hgj.cloudfront.net/uploads/'\
'2012/11/101438745-cat-conjunctivitis-causes.jpg')
    assert_difference 'Image.count', -1 do
      delete image_path(image)
    end
    assert_redirected_to root_path
    assert_equal 'Image url successfully destroyed.', flash[:notice]
  end

  def test_destroy__fail
    assert_no_difference 'Image.count' do
      delete image_path(1000)
    end
    assert_redirected_to root_path
    assert_equal 'Unable to find image.', flash[:notice]
  end
end
