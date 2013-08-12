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
      response.content_type.should == "application/json"
    end
    
    it "should return a 400 if the X-API-Token header is missing" do
      request.headers['X-API-Token'] = nil
      get :index
      response.status.should == 400
      response.content_type.should == "application/json"
    end
    
    it "should return a 400 if the authentication represented by the X-API-Token can't be found" do
      request.headers['X-API-Token'] = 'unknown, matey'
      Api.stub(:permitted?).and_return(double(:status => 400, :body => {:_api_error => []}))
      get :index
      response.status.should == 400
      response.content_type.should == "application/json"
    end
    
    it "should return a 403 if the X-API-Token doesn't yield GET authorisation for Media" do
      Api.stub(:permitted?).and_return(double(:status => 403, :body => {:_api_error => []}))
      get :index
      response.status.should == 403
      response.content_type.should == "application/json"
    end
        
    it "should return a 200 when successful" do
      get :index
      response.status.should == 200
      response.should render_template(partial: "_medium", count: 3)
    end

    it "should return a collection" do
      get :index
      response.status.should == 200
      JSON.parse(response.body).should be_an Array
    end
    
  end
  
end
