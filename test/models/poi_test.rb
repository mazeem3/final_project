require "test_helper"

describe Poi do
  let(:poi) { Poi.new }

  it "must be valid" do
    value(poi).must_be :valid?
  end
end
