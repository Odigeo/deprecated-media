require 'spec_helper'

describe Storage do

  before do
  	$riak_connection_data = nil
  end

  it "should have a setup_connection class method" do
  	Storage.setup_connection
  end
  
  it "the setup method should return the setup as a hash" do
  	Storage.setup_connection.should be_a Hash
  end

  it "the setup method should return false if setup already was done" do
  	Storage.setup_connection
  	Storage.setup_connection.should == false
  end

  it "should have a method to return the Riak client" do
  	Storage.client.should be_a Riak::Client
  end

  it "the client method should create the client if it doesn't exist" do
  	$riak_client = nil
  	Storage.client
  	$riak_client.should be_a Riak::Client
  end
  
  it "should have a class method to calculate a bucket with a separate test bucket" do
    Storage.double_bucket('bucket', 'development').should match /^test-[0-9]+-bucket$/
    Storage.double_bucket('bucket', 'test').should match /test-[0-9]+-bucket/
    Storage.double_bucket('bucket', '').should match /test-[0-9]+-bucket/
    Storage.double_bucket('bucket', 'production').should == 'bucket'
  end
  
end
