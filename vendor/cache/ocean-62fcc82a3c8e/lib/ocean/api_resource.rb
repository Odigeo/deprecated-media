module ApiResource

  def self.included(base)
    base.extend(ClassMethods)
  end


  module ClassMethods

    #
    # This method implements the common behaviour in Ocean for requesting collections
    # of resources, including conditions, +GROUP+ and substring searches. It can be used
    # directly on a class:
    #
    #  @collection = ApiUser.index(params, params[:group], params[:search])
    #
    # or on any Relation:
    #
    #  @collection = @api_user.groups.index(params, params[:group], params[:search])
    #
    # The whole params hash can safely be passed in as the first arg: the 
    # the +conds+ arg is filtered so that matches only are done against the attributes 
    # declared in the controller using +ocean_resource_model+.
    #
    # The +conds+ arg is a hash suitable for passing to an ActiveRecord +where+.
    #
    # The +group_by+ arg, if present, adds a +GROUP+ clause to the generated SQL.
    #
    # The +substring+ arg, if present, searches for the value in the database string or
    # text column declared in the controller's +ocean_resource_model+ declaration.
    # The search is done using an SQL +LIKE+ clause, with the substring framed by 
    # wildcard characters. It's self-evident that this is not an efficient search method
    # in larger datasets; in such cases, other search methods should be employed.
    # 
    # In future, this method will take args to control pagination of results.
    #
    def collection_internal(conds={}, group_by=nil, substring=nil)
      # TODO: pagination
      if index_only != []
        new_conds = {}
        index_only.each { |key| new_conds[key] = conds[key] if conds[key].present? }
        conds = new_conds
      end
      query = all.where(conds)
      query = query.group(group_by) if group_by.present? && index_only.include?(group_by.to_sym)
      if substring.present?
        return query.none if index_search_property.blank?
        query = query.where("#{index_search_property} LIKE ?", "%#{substring}%")
      end
      query
    end

    #
    # This is the successor to +index+. The difference is that +collection+ is called with
    # all params in the same bag, thus simplifying the call from the controller.
    #
    def collection(bag={})
      collection_internal bag, bag[:group], bag[:search]
    end
    

    #
    # Returns the latest version for the resource class. E.g.:
    #
    #  > ApiUser.latest_version
    #  "v1"
    #
    def latest_api_version
      Api.version_for(self.class.name.pluralize.underscore)
    end

    #
    # Invalidate all members of this class in Varnish using a +BAN+ requests to all
    # caches in the Chef environment. The +BAN+ requests are done in parallel.
    # The number of +BAN+ requests, and the exact +URI+ composition in each request,
    # is determined by the +invalidate_collection:+ arg to the +ocean_resource_model+
    # declaration in the model.
    #
    def invalidate
      resource_name = name.pluralize.underscore
      varnish_invalidate_collection.each do |suffix|
        Api.ban "/v[0-9]+/#{resource_name}#{suffix}"
      end
    end

  end


  # Instance methods

  #
  # Convenience function used to touch two resources in one call, e.g:
  #
  #  @api_user.touch_both(@connectee)
  #
  def touch_both(other)
    touch
    other.touch
  end


  #
  # Invalidate the member and all its collections in Varnish using a +BAN+ requests to all
  # caches in the Chef environment. The +BAN+ request are done in parallel.
  # The number of +BAN+ requests, and the exact +URI+ composition in each request,
  # is determined by the +invalidate_member:+ arg to the +ocean_resource_model+
  # declaration in the model.
  #
  # The optional arg +avoid_self+, if true (the default is false), avoids invalidating
  # the basic resource itself: only its derived collections are invalidated. This is useful
  # when instantiating a new resource.
  #
  def invalidate(avoid_self=false)
    self.class.invalidate
    resource_name = self.class.name.pluralize.underscore
    varnish_invalidate_member.each do |thing|
      if thing.is_a?(String)
        Api.ban "/v[0-9]+/#{resource_name}/#{self.id}#{thing}" if !avoid_self
      else
        Api.ban "/v[0-9]+/#{thing.call(self)}"
      end
    end
  end

end
