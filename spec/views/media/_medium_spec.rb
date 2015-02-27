require 'spec_helper'


describe "media/_medium" do
  
  before :each do
    Medium.delete_all
    m = create(:medium, url: "https://static.example.com/riak/76sdgfs/sd6tisf",
                        content_type: 'image/jpeg')
    render partial: "media/medium", locals: {medium: m}
    @json = JSON.parse(rendered)
    @x = @json['medium']
    @links = @x['_links'] rescue {}
  end
  

  it "has a named root" do
    expect(@x).not_to eq(nil)
  end

  it "should have four hyperlinks" do
    expect(@links.length).to eq(4)
  end

  it "should have a self hyperlink" do
    expect(@links).to be_hyperlinked('self', /media/)
  end

  it "should have a url hyperlink" do
    expect(@links).to be_hyperlinked('url', /media/, "image/jpeg")
  end

  it "should have a creator hyperlink" do
    expect(@links).to be_hyperlinked('creator', /api_users/)
  end

  it "should have a updater hyperlink" do
    expect(@links).to be_hyperlinked('updater', /api_users/)
  end

  it "should have an app" do
    expect(@x['app']).to be_a String
  end
  
  it "should have a context" do
    expect(@x['context']).to be_a String
  end
  
  it "should have a locale" do
    expect(@x['locale']).to be_a String
  end
  
  it "should have a name" do
    expect(@x['name']).to be_a String
  end
  
  it "should have tags" do
    expect(@x['tags']).to be_a String
  end
  
  it "should have a MIME type" do
    expect(@x['content_type']).to be_a String
  end
  
  it "should have a byte size" do
    expect(@x['bytesize']).to be_an Integer
  end
  
  it "should have a created_at time" do
    expect(@x['created_at']).to be_a String
  end
  
  it "should have an updated_at time" do
    expect(@x['updated_at']).to be_a String
  end
  
  it "should not expose the created_by attribute" do
    expect(@x['created_by']).to eq(nil)
  end
  
  it "should not expose the updated_by attribute" do
    expect(@x['updated_by']).to eq(nil)
  end
  
  it "should have a lock_version field" do
    expect(@x['lock_version']).to be_an Integer
  end
  
  it "should have a delete_at field" do
    expect(@x['delete_at']).to be_a String
  end
  
  it "should have an email field" do
    expect(@x['email']).to be_a String
  end
  
  it "should have an original file name field" do
    expect(@x['file_name']).to be_a String
  end

  it "should have a usage field" do
    expect(@x['usage']).to be_a String
  end

end
