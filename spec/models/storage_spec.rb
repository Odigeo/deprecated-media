require 'spec_helper'

describe Storage do

  before do
  	$riak_connection_data = nil
  end

  it "should have a setup_connection class method" do
  	Storage.setup_connection
  end
  
  it "the setup method should return the setup as a hash" do
  	expect(Storage.setup_connection).to be_a Hash
  end

  it "the setup method should return false if setup already was done" do
  	Storage.setup_connection
  	expect(Storage.setup_connection).to eq(false)
  end

  it "should have a method to return the Riak client" do
  	expect(Storage.client).to be_a Riak::Client
  end

  it "the client method should create the client if it doesn't exist" do
  	$riak_client = nil
  	Storage.client
  	expect($riak_client).to be_a Riak::Client
  end
  
  it "should have a class method to calculate a bucket with a separate test bucket" do
    expect(Storage.double_bucket('bucket', 'development')).to match /^test-[0-9]+-bucket$/
    expect(Storage.double_bucket('bucket', 'test')).to match /test-[0-9]+-bucket/
    expect(Storage.double_bucket('bucket', '')).to match /test-[0-9]+-bucket/
    expect(Storage.double_bucket('bucket', 'production')).to eq('bucket')
  end
  
end
