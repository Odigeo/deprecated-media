class Storage

  def self.setup_connection
  	return false if $riak_connection_data
  	$riak_connection_data = {
  	  protocol: 'pbc',                       # Use protocol buffers
  	  nodes:    RIAK_NODES.collect { |ip| {host: ip} }	        
  	}
  	return $riak_connection_data
  end

  def self.client
  	setup_connection
  	$riak_client ||= Riak::Client.new $riak_connection_data
  end
  
  def self.double_bucket(bucket, env=Rails.env)
    return bucket.to_s if env == 'production'
    "#{$riak_bucket_prefix}#{bucket}"
  end
  
  def self.url(bucket, m)
    bucket = double_bucket(m.app)
    "#{RIAK_MEDIA_URL}/riak/#{bucket}/#{m.riak_key}"
  end
  
  
  #
  # These three methods manage a binary medium in the Riak cluster.
  # The return value indicates success or failure. When called from 
  # a Medium instance, the instance and/or the changes have not yet 
  # been written to the MySQL DB. We shouldn't create an ActiveModel 
  # DB instance unless the Riak operation succeeds.
  #
  def self.create_medium(m)
    bucket = client.bucket(double_bucket m.app)
    nm = Riak::RObject.new(bucket, m.riak_key)
    nm.content_type = m.content_type
    nm.raw_data = Base64.decode64(m.payload);
    nm.store  
  end

  def self.update_medium(m)
    bucket = client.bucket(double_bucket m.app)
    om = bucket.get m.riak_key
    om.content_type = m.content_type
    om.raw_data = Base64.decode64(m.payload) if m.payload
    om.store
  end
  
  def self.delete_medium(m)
    bucket = client.bucket(double_bucket m.app)
    bucket.delete m.riak_key
  end

end
