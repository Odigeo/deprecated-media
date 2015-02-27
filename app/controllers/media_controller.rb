class MediaController < ApplicationController

  ocean_resource_controller extra_actions: {},
                            required_attributes: [:lock_version]

  before_action :find_medium, :only => [:show, :update, :destroy]
    
  
  # GET /media
  def index
    expires_in 0, 's-maxage' => 30.minutes
    if stale?(collection_etag(Medium))
      @media = Medium.collection(params)
      api_render @media
    end
  end


  # GET /media/1
  def show
    expires_in 0, 's-maxage' => 30.minutes
    if stale?(@medium)
      api_render @medium
    end
  end


  # POST /media
  def create
    @medium = Medium.new(filtered_params Medium)
    set_updater(@medium)
    @medium.save!
    api_render @medium, new: true
  end


  # PUT /media/1
  def update
    if missing_attributes?
      render_api_error 422, "Missing resource attributes"
      return
    end
    @medium.assign_attributes(filtered_params Medium)
    set_updater(@medium)
    @medium.save!
    api_render @medium
    Api.ban "/v1/media/#{@medium.id}"
    Api.ban "/v1/media"
  end


  # DELETE /media/1
  def destroy
    @medium.destroy
    Api.ban "/v1/media/#{@medium.id}"
    Api.ban "/v1/media"
    render_head_204
  end
  
  
  private
     
  def find_medium
    @medium = Medium.find_by_id params[:id]
    return true if @medium
    render_api_error 404, "Not found"
    false
  end  
  
end
