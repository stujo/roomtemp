require 'spec_helper'

describe "Rooms" do
  describe "GET /rooms" do
    it "Can view rooms listing" do
      get rooms_path
      response.status.should be(200)
    end
  end
end
