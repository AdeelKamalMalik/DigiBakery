class CookiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_oven

  def new
    @cookie = @oven.cookies.new
  end

  def create
    @cookie = @oven.cookies.create!(cookie_params)
    redirect_to oven_path(@oven)
  end

  def bulk_create
    size = params[:no_of_cookies].present? ? params[:no_of_cookies].to_i : 1

    cookies_attributes = Array.new(size, cookie_params)
    @oven.cookies.create!(cookies_attributes)
    @oven.update(busy: true)
    redirect_to oven_path(@oven)
  end

  private

  def set_oven
    @oven = current_user.ovens.find_by!(id: params[:oven_id])
  end

  def cookie_params
    params.require(:cookie).permit(:fillings)
  end
end
