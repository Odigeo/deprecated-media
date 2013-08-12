class MediaController < ApplicationController

  ocean_resource_controller extra_actions: {},
                            required_attributes: [:lock_version]

  respond_to :json

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
    if @medium.valid?
      begin
        @medium.save!
      rescue ActiveRecord::RecordNotUnique, ActiveRecord::StatementInvalid, 
             SQLite3::ConstraintException 
        render_api_error 422, "Medium already exists"
        return
      end
      Api.ban "/v1/media"
      api_render @medium, new: true
    else
      render_validation_errors @medium
    end
  end


  # PUT /media/1
  def update
    if missing_attributes?
      render_api_error 422, "Missing resource attributes"
      return
    end
    begin
      @medium.assign_attributes(filtered_params Medium)
      set_updater(@medium)
      @medium.save
    rescue ActiveRecord::StaleObjectError
      render_api_error 409, "Stale Medium"
      return
    end
    if @medium.valid?
      Api.ban "/v1/media/#{@medium.id}"
      Api.ban "/v1/media"
      api_render @medium
    else
      render_validation_errors(@medium)
    end
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
