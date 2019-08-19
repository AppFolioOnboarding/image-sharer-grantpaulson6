require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  def test_image__valid
    image = Image.new(name: 'zion', url: 'https://www.pewtrusts.org/-/media/post-launch-images/2018/01/istock-479409864/istock-479409864_16x9.jpg?la=en&hash=A70682998CAE7084094117D7CA8E14C340BCEC55')

    # QUESTION: use assert or assert_predicate?
    assert image.valid?
  end

  def test_image__invalid_if_name_is_blank
    image = Image.new(name: '', url: 'https://www.pewtrusts.org/-/media/post-launch-images/2018/01/istock-479409864/istock-479409864_16x9.jpg?la=en&hash=A70682998CAE7084094117D7CA8E14C340BCEC55')

    refute image.valid?
    assert_includes image.errors.full_messages, 'Name can\'t be blank'
  end

  def test_image__invalid_if_url_is_blank
    image = Image.new(name: 'zion', url: '')

    refute image.valid?
    assert_includes image.errors.full_messages, 'Url can\'t be blank'
  end

  def test_image__invalid_if_url_is_invalid
    image = Image.new(name: '', url: 'Desktop/my_zion_photo1.jpeg')

    refute image.valid?
    assert_includes image.errors.full_messages, 'Url must be valid'
  end
end
