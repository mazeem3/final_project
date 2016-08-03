require "test_helper"

describe MapsController do
  it "should get index" do
    get maps_index_url
    value(response).must_be :success?
  end

  it "should get show" do
    get maps_show_url
    value(response).must_be :success?
  end

end
