require "spec_helper"

describe MediaController do
  describe "routing" do

    it "routes to #index" do
      get("/v1/media").should route_to("media#index")
    end

    it "routes to #show" do
      get("/v1/media/1").should route_to("media#show", :id => "1")
    end

    it "routes to #create" do
      post("/v1/media").should route_to("media#create")
    end

    it "routes to #update" do
      put("/v1/media/1").should route_to("media#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/v1/media/1").should route_to("media#destroy", :id => "1")
    end

  end
end
