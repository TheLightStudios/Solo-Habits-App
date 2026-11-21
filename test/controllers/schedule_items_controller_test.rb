require "test_helper"

class ScheduleItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get schedule_items_index_url
    assert_response :success
  end

  test "should get new" do
    get schedule_items_new_url
    assert_response :success
  end

  test "should get edit" do
    get schedule_items_edit_url
    assert_response :success
  end

  test "should get _form" do
    get schedule_items__form_url
    assert_response :success
  end
end
