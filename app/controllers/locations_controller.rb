require 'freecycle_mail.rb'
class LocationsController < ApplicationController
  def new
    @location = Location.new

    render :new
  end
  # def create
  #   @location = Location.new(params[:location])

  #   itsaved = @location.save
  #   if itsaved
  #     redirect_to :show
  #   else
  #     render :new
  #   end
  # end
  def index
    load "freecycle_mail.rb"
        # list of Location objects
    @offers = Location.all
    recent_offers_web_data()
    # @subject = Location.new(params[:subject])
    #     itsaved = @subject.save
    # if itsaved
    #   redirect_to :show
    # else
    #   render :index
    # end

    render :index

  end
  def show
    # goes to /locations/:id
    @location = Location.find(params[:id])

    render :show
  end
end
