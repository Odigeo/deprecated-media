require "spec_helper"

describe MediaController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/v1/media")).to route_to("media#index")
    end

    it "routes to #show" do
      expect(get("/v1/media/1")).to route_to("media#show", :id => "1")
    end

    it "routes to #create" do
      expect(post("/v1/media")).to route_to("media#create")
    end

    it "routes to #update" do
      expect(put("/v1/media/1")).to route_to("media#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/v1/media/1")).to route_to("media#destroy", :id => "1")
    end

  end
end
