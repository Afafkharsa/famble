require "test_helper"

class PointAdjustmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get point_adjustments_create_url
    assert_response :success
  end
end
