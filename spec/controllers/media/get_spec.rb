require 'spec_helper'

describe MediaController do
  
  #render_views
  
  
  describe "GET" do
    
    before do
      Medium.delete_all
      permit_with 200
      @medium = create :medium
      request.headers['HTTP_ACCEPT'] = "application/json"
      request.headers['X-API-Token'] = "totally-fake"
    end
    
    it "should return JSON" do
      get :show, id: @medium.id
      expect(response.content_type).to eq("application/json")
    end
    
    it "should return a 400 if the X-API-Token header is missing" do
      request.headers['X-API-Token'] = nil
      get :show, id: @medium.id
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
    end
    
    it "should return a 400 if the authentication represented by the X-API-Token can't be found" do
      request.headers['X-API-Token'] = 'unknown, matey'
      allow(Api).to receive(:permitted?).and_return(double(:status => 400, :body => {:_api_error => []}))
      get :show, id: @medium.id
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
    end

    it "should return a 403 if the X-API-Token doesn't yield GET authorisation for Media" do
      allow(Api).to receive(:permitted?).and_return(double(:status => 403, :body => {:_api_error => []}))
      get :show, id: @medium.id
      expect(response.status).to eq(403)
      expect(response.content_type).to eq("application/json")
    end
        
    it "should return a 404 when the user can't be found" do
      get :show, id: 9999999999999
      expect(response.status).to eq(404)
      expect(response.content_type).to eq("application/json")
    end
    
    it "should return a 200 when successful" do
      get :show, id: @medium.id
      expect(response.status).to eq(200)
    end
    
    it "should render the object partial when successful" do
      get :show, id: @medium.id
      expect(response).to render_template(partial: '_medium', count: 1)
    end
  end
  
end
