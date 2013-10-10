class ListingsController < ApplicationController
  def index
    @listings = current_user.listings
  end

  def new
    @listing = Listing.new
  end

  def create
    @listing = Listing.new(user_params)
    @listing.save!
    current_user.listings << @listing
    current_user.save!
    redirect_to :action => :index
  end

  private


  def user_params
    params.require(:listing).permit(:airbnb_id)
  end
end
