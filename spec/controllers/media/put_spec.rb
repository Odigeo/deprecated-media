require 'spec_helper'

describe MediaController do
  
  render_views
  
  
  describe "PUT" do
    
    before do
      Medium.delete_all
      permit_with 200
      request.headers['HTTP_ACCEPT'] = "application/json"
      request.headers['X-API-Token'] = "incredibly-fake!"
      @m = create :medium
      @args = @m.attributes
    end


    it "should return JSON" do
      put :update, @args
      expect(response.content_type).to eq("application/json")
    end
    
    it "should return a 400 if the X-API-Token header is missing" do
      request.headers['X-API-Token'] = nil
      put :update, @args
      expect(response.status).to eq(400)
    end

    it "should return a 400 if the authentication represented by the X-API-Token can't be found" do
      request.headers['X-API-Token'] = 'unknown, matey'
      allow(Api).to receive(:permitted?).and_return(double(:status => 400, :body => {:_api_error => []}))
      put :update, @args
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
    end

    it "should return a 403 if the X-API-Token doesn't yield PUT authorisation" do
      allow(Api).to receive(:permitted?).and_return(double(:status => 403, :body => {:_api_error => []}))
      put :update, @args
      expect(response.status).to eq(403)
      expect(response.content_type).to eq("application/json")
    end

    it "should return a 404 if the resource can't be found" do
      put :update, id: -1
      expect(response.status).to eq(404)
      expect(response.content_type).to eq("application/json")
    end

    it "should return a 422 when resource properties are missing (all must be set simultaneously)" do
      put :update, id: @m.id
      expect(response.status).to eq(422)
      expect(response.content_type).to eq("application/json")
      expect(JSON.parse(response.body)).to eq({"_api_error"=>["Missing resource attributes"]})
    end

    # Uncomment this test as soon as there is one or more DB attributes that need
    # validating.
    #
    # it "should return a 422 when there are validation errors" do
    #   put :update, @args.merge(:locale => "nix-DORF")
    #   response.status.should == 422
    #   response.content_type.should == "application/json"
    #   JSON.parse(response.body).should == {"locale"=>["ISO language code format required ('de-AU')"]}
    # end

    it "should return a 409 when there is an update conflict" do
      @m.update_attributes!({:updated_at => 1.week.from_now}, :without_protection => true)
      put :update, @args
      expect(response.status).to eq(409)
    end
        
    it "should return a 200 when successful" do
      put :update, @args
      expect(response.status).to eq(200)
    end

     it "should render the object partial when successful" do
      put :update, @args
      expect(response).to render_template(partial: '_medium', count: 1)
    end

    it "should return the updated resource in the body when successful" do
      put :update, @args
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to be_a Hash
    end

    it "should not require the payload to be included" do
      @args['payload'] = nil
      @args['tags'] = "foo bar baz"
      expect(Storage).not_to receive(:update_medium)
      put :update, @args
      @m.reload
      expect(@m.tags).to eq("foo bar baz")
    end
    
  end

end
