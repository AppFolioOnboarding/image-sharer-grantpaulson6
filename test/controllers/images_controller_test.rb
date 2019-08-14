require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "should get home" do
    get '/'
    assert_response :success
  end
end
