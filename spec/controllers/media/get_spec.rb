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
      response.content_type.should == "application/json"
    end
    
    it "should return a 400 if the X-API-Token header is missing" do
      request.headers['X-API-Token'] = nil
      get :show, id: @medium.id
      response.status.should == 400
      response.content_type.should == "application/json"
    end
    
    it "should return a 400 if the authentication represented by the X-API-Token can't be found" do
      request.headers['X-API-Token'] = 'unknown, matey'
      Api.stub(:permitted?).and_return(double(:status => 400, :body => {:_api_error => []}))
      get :show, id: @medium.id
      response.status.should == 400
      response.content_type.should == "application/json"
    end

    it "should return a 403 if the X-API-Token doesn't yield GET authorisation for Media" do
      Api.stub(:permitted?).and_return(double(:status => 403, :body => {:_api_error => []}))
      get :show, id: @medium.id
      response.status.should == 403
      response.content_type.should == "application/json"
    end
        
    it "should return a 404 when the user can't be found" do
      get :show, id: 9999999999999
      response.status.should == 404
      response.content_type.should == "application/json"
    end
    
    it "should return a 200 when successful" do
      get :show, id: @medium.id
      response.status.should == 200
    end
    
    it "should render the object partial when successful" do
      get :show, id: @medium.id
      response.should render_template(partial: '_medium', count: 1)
    end
  end
  
end
