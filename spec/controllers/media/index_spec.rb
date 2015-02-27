require 'spec_helper'

describe MediaController do
  
  render_views
  
  
  describe "INDEX" do
    
    before do
      Medium.delete_all
      permit_with 200
      create :medium
      create :medium
      create :medium
      request.headers['HTTP_ACCEPT'] = "application/json"
      request.headers['X-API-Token'] = "boy-is-this-fake"
    end
    
    it "should return JSON" do
      get :index
      expect(response.content_type).to eq("application/json")
    end
    
    it "should return a 400 if the X-API-Token header is missing" do
      request.headers['X-API-Token'] = nil
      get :index
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
    end
    
    it "should return a 400 if the authentication represented by the X-API-Token can't be found" do
      request.headers['X-API-Token'] = 'unknown, matey'
      allow(Api).to receive(:permitted?).and_return(double(:status => 400, :body => {:_api_error => []}))
      get :index
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
    end
    
    it "should return a 403 if the X-API-Token doesn't yield GET authorisation for Media" do
      allow(Api).to receive(:permitted?).and_return(double(:status => 403, :body => {:_api_error => []}))
      get :index
      expect(response.status).to eq(403)
      expect(response.content_type).to eq("application/json")
    end
        
    it "should return a 200 when successful" do
      get :index
      expect(response.status).to eq(200)
      expect(response).to render_template(partial: "_medium", count: 3)
    end

    it "should return a collection" do
      get :index
      expect(response.status).to eq(200)
      wrapper = JSON.parse(response.body)
      expect(wrapper).to be_a Hash
      resource = wrapper['_collection']
      expect(resource).to be_a Hash
      coll = resource['resources']
      expect(coll).to be_an Array
      expect(coll.count).to eq(3)
      n = resource['count']
      expect(n).to eq(3)
    end
    
  end
  
end
