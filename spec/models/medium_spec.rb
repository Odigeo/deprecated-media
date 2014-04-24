# == Schema Information
#
# Table name: media
#
#  id           :integer          not null, primary key
#  app          :string(255)
#  context      :string(255)
#  locale       :string(255)
#  tags         :string(255)
#  content_type :string(255)
#  url          :string(255)
#  name         :string(255)
#  lock_version :integer          default(0), not null
#  created_by   :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  bytesize     :integer          default(0), not null
#  updated_by   :integer          default(0), not null
#  delete_at    :datetime
#  email        :string(255)
#  file_name    :string(255)      default(""), not null
#  usage        :string(255)      default(""), not null
#

require 'spec_helper'

describe Medium do
  
  describe "properties" do
    it "should include the app" do
      create :medium, app: "foo"
    end
    
    it "should include the context" do
      create :medium, context: "bar"
    end
    
    it "should include the name" do
      create :medium, name: "baz"
    end
    
    it "should include the original locale" do
      create :medium, locale: "sv-SE"
    end
    
    it "should include the url" do
      create :medium, url: "quux"
    end
    
    it "should include the content_type" do
      create :medium, content_type: "image/jsp"
    end
    
    it "should include the size of the original binary media" do
      create :medium, bytesize: 10000
    end
    
    it "should include the tags" do
      create :medium, tags: "foo, bar, baz"
    end
    
    it "should include the time to delete this medium" do
      create :medium, delete_at: 1.month.from_now.utc
    end
    
    it "should include a notification email for autodeletes" do
      create :medium, email: "foo@example.com"
    end
    
    it "should include the original file_name" do
      create :medium, file_name: "betty.jpg"
    end
    
    it "should include the time created" do
      create :medium, created_at: Time.now.utc
    end
    
    it "should include the time updated" do
      create :medium, updated_at: Time.now.utc
    end
    
    it "should include the creator id" do
      create :medium, created_by: 123
    end
    
    it "should include the updater id" do
      create :medium, updated_by: 123
    end
    
    it "should include a lock_version" do
      create :medium, lock_version: 123
    end
    
    it "should include a usage field" do
      create :medium, usage: "something"
    end
  end
  
  
  it "should have a method to calculate the Riak key, i.e. the final part of its URL" do
    m = create :medium
    m.riak_key.should be_a String
  end
  
  it "URLs for a Medium should follow a specific format" do
    m = create :medium
    b = Storage.double_bucket m.app
    m.url.should == "#{RIAK_MEDIA_URL}/riak/#{b}/#{m.context}-#{m.name}-#{m.locale}-#{m.file_name}"
  end
    
  
  describe "property payload" do
    it "should be accepted when creating a new Medium" do
      create :medium, payload: "suyfuysus", content_type: "text/plain"
    end
    
    it "should set the instance variable @payload" do
      m = create :medium, payload: "usygfuyggss", content_type: "text/plain"
      m.payload.should == "usygfuyggss"
    end
    
    it "should not be stored with the Medium instance" do
      create :medium, payload: "usygfuyggss", content_type: "text/plain", name: "foobar"
      m = Medium.find_by_name "foobar"
      m.payload.should == nil
    end
    
    it "should trigger the method create_on_riak if the Media resource is new" do
      Medium.any_instance.should_receive(:create_on_riak)
      m = create :medium, payload: "hej", content_type: "text/plain"
    end
        
    it "should trigger the method update_on_riak if the Media resource already exists" do
      m = create :medium
      Medium.any_instance.should_receive(:update_on_riak)
      m.update_attributes!(payload: "tjo", content_type: "text/plain")
    end
    
    it "if present, should call Storage.create_medium for a new record" do
      Storage.should_receive(:create_medium).with(an_instance_of(Medium))
      create :medium, payload: "udyfg", content_type: "text/plain"
    end
    
    it "if present, should call Storage.update_medium for an update" do
      m = create :medium
      Storage.should_receive(:update_medium).with(m)
      m.update_attributes! payload: "sduyf", content_type: "text/plain"
    end
  end
  
  describe "destroy" do
    it "should delete the media from the Riak cluster" do
      m = create :medium
      Storage.should_receive(:delete_medium).with(m)
      m.destroy
    end
  end
  
  
  describe ".collection" do
    before :all do
      Medium.destroy_all
      create :medium, app: 'foo', context: 'alfa', name: 'ett',  locale: 'sv-SE'
      create :medium, app: 'foo', context: 'alfa', name: 'ett',  locale: 'no-NO'
      create :medium, app: 'foo', context: 'alfa', name: 'ett',  locale: 'da-DK'
      create :medium, app: 'foo', context: 'beta', name: 'gokk', locale: 'sv-SE'
      create :medium, app: 'bar', context: 'zoo',  name: 'gokk', locale: 'sv-SE'
      create :medium, app: 'bar', context: 'zoo',  name: 'gokk', locale: 'en-GB'
      create :medium, app: 'bar', context: 'xux',  name: 'gokk', locale: 'en-GB'
    end
    
    it "should return an array of Medium instances" do
      ix = Medium.collection
      ix.length.should == 7
      ix[0].should be_a Medium
    end
    
    it "should allow matches on app" do
      Medium.collection(app: 'NOWAI').length.should == 0
      Medium.collection(app: 'foo').length.should == 4
      Medium.collection(app: 'bar').length.should == 3
    end
    
    it "should allow matches on context" do
      Medium.collection(context: 'NOWAI').length.should == 0
      Medium.collection(context: 'alfa').length.should == 3
      Medium.collection(context: 'beta').length.should == 1
      Medium.collection(context: 'zoo').length.should == 2
      Medium.collection(context: 'xux').length.should == 1
    end
    
    it "should allow matches on name" do
      Medium.collection(name: 'NOWAI').length.should == 0
      Medium.collection(name: 'ett').length.should == 3
      Medium.collection(name: 'gokk').length.should == 4
    end
    
    it "should allow matches on locale" do
      Medium.collection(locale: 'NOWAI').length.should == 0
      Medium.collection(locale: 'sv-SE').length.should == 3
      Medium.collection(locale: 'no-NO').length.should == 1
      Medium.collection(locale: 'da-DK').length.should == 1
      Medium.collection(locale: 'en-GB').length.should == 2
    end
    
    it "should allow searches on app and context" do
      Medium.collection(app: 'bar', context: 'zoo').length.should == 2
      Medium.collection(app: 'bar', context: 'xux').length.should == 1
      Medium.collection(app: 'bar', context: 'NOWAI').length.should == 0
      Medium.collection(app: 'NOWAY', context: 'zoo').length.should == 0
    end
    
    it "key/value pairs not in the index_only array should quietly be ignored" do
      Medium.collection(app: 'foo', aardvark: 12).length.should == 4
    end
    
    
    describe "should permit menu grouping" do
      
      it "to list the existing apps" do
        media = Medium.collection(group: :app)
        media.length.should == 2
      end
      
      it "to give all the contexts in an app" do
        media = Medium.collection(app: 'bar', group: :context)
        media.length.should == 2
      end
      
      it "to give all the names in an app and context" do
        media = Medium.collection(app: 'bar', context: 'zoo', group: :name)
        media.length.should == 1
      end
      
      it "to list all the locales" do
        media = Medium.collection(group: :locale)
        media.length.should == 4
      end
      
    end
  end

end
