class LocationsController < ApplicationController
  # takes request for html or json and returns that
  respond_to :html, :json

  # def new
  #   @location = Location.new

  #   render :new
  # end

  def index
    # list of Location objects
    # pulling all listings in database
    @offers = Location.all
    respond_with(@offers)


  end
  # def show
  #   # goes to /locations/:id
  #   @location = Location.find(params[:id])

  #   render :show
  # end
end
