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
    expect(m.riak_key).to be_a String
  end
  
  it "URLs for a Medium should follow a specific format" do
    m = create :medium
    b = Storage.double_bucket m.app
    expect(m.url).to eq("#{RIAK_MEDIA_URL}/riak/#{b}/#{m.context}-#{m.name}-#{m.locale}-#{m.file_name}")
  end
    
  
  describe "property payload" do
    it "should be accepted when creating a new Medium" do
      create :medium, payload: "suyfuysus", content_type: "text/plain"
    end
    
    it "should set the instance variable @payload" do
      m = create :medium, payload: "usygfuyggss", content_type: "text/plain"
      expect(m.payload).to eq("usygfuyggss")
    end
    
    it "should not be stored with the Medium instance" do
      create :medium, payload: "usygfuyggss", content_type: "text/plain", name: "foobar"
      m = Medium.find_by_name "foobar"
      expect(m.payload).to eq(nil)
    end
    
    it "should trigger the method create_on_riak if the Media resource is new" do
      expect_any_instance_of(Medium).to receive(:create_on_riak)
      m = create :medium, payload: "hej", content_type: "text/plain"
    end
        
    it "should trigger the method update_on_riak if the Media resource already exists" do
      m = create :medium
      expect_any_instance_of(Medium).to receive(:update_on_riak)
      m.update_attributes!(payload: "tjo", content_type: "text/plain")
    end
    
    it "if present, should call Storage.create_medium for a new record" do
      expect(Storage).to receive(:create_medium).with(an_instance_of(Medium))
      create :medium, payload: "udyfg", content_type: "text/plain"
    end
    
    it "if present, should call Storage.update_medium for an update" do
      m = create :medium
      expect(Storage).to receive(:update_medium).with(m)
      m.update_attributes! payload: "sduyf", content_type: "text/plain"
    end
  end
  
  describe "destroy" do
    it "should delete the media from the Riak cluster" do
      m = create :medium
      expect(Storage).to receive(:delete_medium).with(m)
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
      expect(ix.length).to eq(7)
      expect(ix[0]).to be_a Medium
    end
    
    it "should allow matches on app" do
      expect(Medium.collection(app: 'NOWAI').length).to eq(0)
      expect(Medium.collection(app: 'foo').length).to eq(4)
      expect(Medium.collection(app: 'bar').length).to eq(3)
    end
    
    it "should allow matches on context" do
      expect(Medium.collection(context: 'NOWAI').length).to eq(0)
      expect(Medium.collection(context: 'alfa').length).to eq(3)
      expect(Medium.collection(context: 'beta').length).to eq(1)
      expect(Medium.collection(context: 'zoo').length).to eq(2)
      expect(Medium.collection(context: 'xux').length).to eq(1)
    end
    
    it "should allow matches on name" do
      expect(Medium.collection(name: 'NOWAI').length).to eq(0)
      expect(Medium.collection(name: 'ett').length).to eq(3)
      expect(Medium.collection(name: 'gokk').length).to eq(4)
    end
    
    it "should allow matches on locale" do
      expect(Medium.collection(locale: 'NOWAI').length).to eq(0)
      expect(Medium.collection(locale: 'sv-SE').length).to eq(3)
      expect(Medium.collection(locale: 'no-NO').length).to eq(1)
      expect(Medium.collection(locale: 'da-DK').length).to eq(1)
      expect(Medium.collection(locale: 'en-GB').length).to eq(2)
    end
    
    it "should allow searches on app and context" do
      expect(Medium.collection(app: 'bar', context: 'zoo').length).to eq(2)
      expect(Medium.collection(app: 'bar', context: 'xux').length).to eq(1)
      expect(Medium.collection(app: 'bar', context: 'NOWAI').length).to eq(0)
      expect(Medium.collection(app: 'NOWAY', context: 'zoo').length).to eq(0)
    end
    
    it "key/value pairs not in the index_only array should quietly be ignored" do
      expect(Medium.collection(app: 'foo', aardvark: 12).length).to eq(4)
    end
    
    
    describe "should permit menu grouping" do
      
      it "to list the existing apps" do
        media = Medium.collection(group: :app)
        expect(media.length).to eq(2)
      end
      
      it "to give all the contexts in an app" do
        media = Medium.collection(app: 'bar', group: :context)
        expect(media.length).to eq(2)
      end
      
      it "to give all the names in an app and context" do
        media = Medium.collection(app: 'bar', context: 'zoo', group: :name)
        expect(media.length).to eq(1)
      end
      
      it "to list all the locales" do
        media = Medium.collection(group: :locale)
        expect(media.length).to eq(4)
      end
      
    end
  end

end
