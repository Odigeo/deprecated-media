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

class Medium < ActiveRecord::Base


  ocean_resource_model index: [:app, :context, :name, :locale, :content_type],
                       search: :file_name

  
  attr_accessible :app, :context, :name, :locale, :url, :content_type, 
                  :bytesize, :tags, :delete_at, :email, :file_name, 
                  :payload, :created_at, :updated_at, :created_by, 
                  :updated_by, :lock_version
                  
  attr_accessor :payload
                  
  validates :app,          :presence => true
  validates :context,      :presence => true
  validates :locale,       :presence => true, :format => /^[a-z]{2}-[A-Z]{2}$/
  validates :name,         :presence => true
  validates :content_type,    :presence => true
  validates :lock_version, :presence => true
  validates :file_name,    :presence => true
  validates :url,          :presence => true
  #validates :tags,         :presence => true
  validates :bytesize,     :presence => true
  
  before_validation :set_url
  
  def set_url
    self.url = Storage.url(:media, self)
  end
    
  
  #
  # Transfer the base64 data to Riak
  #
  before_create :create_on_riak
  before_update :update_on_riak
  before_destroy :delete_on_riak
  
  def create_on_riak
    return unless payload.present?
    # TODO: require the presence of content_type and file_name
    Storage.create_medium(self)
    # TODO: make a failed Storage store operation terminate the creation process
  end
  
  def update_on_riak
    return true unless payload.present?
    # TODO: require the presence of content_type and file_name
    Storage.update_medium(self)
    # TODO: make a failed Storage store operation terminate the update process
  end
  
  def delete_on_riak
    Storage.delete_medium(self)
    # TODO: make a failed Storage delete operation terminate the destruction process
  end
  
  def riak_key
    "#{context}-#{name}-#{locale}-#{file_name}"
  end
  
end
