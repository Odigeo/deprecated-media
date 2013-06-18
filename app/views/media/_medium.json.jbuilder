json.medium do |json|
	json._links hyperlinks(self:    medium_url(medium),
	                       url:     {href: medium.url, type: medium.content_type},
	                       creator: api_user_url(medium.created_by),
	                       updater: api_user_url(medium.updated_by))
	json.(medium, :app, 
	              :context, 
	              :locale, 
	              :name, 
	              :content_type, 
	              :file_name,
	              :bytesize, 
	              :usage,
	              :tags,
	              :email, 
	              :lock_version)
	json.delete_at  medium.delete_at.present? && medium.delete_at.utc.iso8601
	json.created_at medium.created_at.utc.iso8601
	json.updated_at medium.updated_at.utc.iso8601
end
