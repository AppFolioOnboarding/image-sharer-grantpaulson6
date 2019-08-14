require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get home' do
    get '/'
    assert_response :success
  end

  test 'should say welcome' do
    get '/'
    assert_select 'h1', /Welcome*/
  end
end
