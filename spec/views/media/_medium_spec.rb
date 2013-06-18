require 'spec_helper'


describe "media/_medium" do
  
  before :each do
    Medium.delete_all
    m = create(:medium, url: "https://static.travelservices.se/riak/76sdgfs/sd6tisf",
                        content_type: 'image/jpeg')
    render partial: "media/medium", locals: {medium: m}
    @json = JSON.parse(rendered)
    @x = @json['medium']
    @links = @x['_links'] rescue {}
  end
  

  it "has a named root" do
    @x.should_not == nil
  end

  it "should have four hyperlinks" do
    @links.length.should == 4
  end

  it "should have a self hyperlink" do
    @links.should be_hyperlinked('self', /media/)
  end

  it "should have a url hyperlink" do
    @links.should be_hyperlinked('url', /media/, "image/jpeg")
  end

  it "should have a creator hyperlink" do
    @links.should be_hyperlinked('creator', /api_users/)
  end

  it "should have a updater hyperlink" do
    @links.should be_hyperlinked('updater', /api_users/)
  end

  it "should have an app" do
    @x['app'].should be_a String
  end
  
  it "should have a context" do
    @x['context'].should be_a String
  end
  
  it "should have a locale" do
    @x['locale'].should be_a String
  end
  
  it "should have a name" do
    @x['name'].should be_a String
  end
  
  it "should have tags" do
    @x['tags'].should be_a String
  end
  
  it "should have a MIME type" do
    @x['content_type'].should be_a String
  end
  
  it "should have a byte size" do
    @x['bytesize'].should be_an Integer
  end
  
  it "should have a created_at time" do
    @x['created_at'].should be_a String
  end
  
  it "should have an updated_at time" do
    @x['updated_at'].should be_a String
  end
  
  it "should not expose the created_by attribute" do
    @x['created_by'].should == nil
  end
  
  it "should not expose the updated_by attribute" do
    @x['updated_by'].should == nil
  end
  
  it "should have a lock_version field" do
    @x['lock_version'].should be_an Integer
  end
  
  it "should have a delete_at field" do
    @x['delete_at'].should be_a String
  end
  
  it "should have an email field" do
    @x['email'].should be_a String
  end
  
  it "should have an original file name field" do
    @x['file_name'].should be_a String
  end

  it "should have a usage field" do
    @x['usage'].should be_a String
  end

end
