class OvensController < ApplicationController
  before_action :authenticate_user!
  before_action :set_oven, only: [:show, :empty]

  def index
    @ovens = current_user.ovens
  end

  def show; end

  def empty
    @oven.cookies.find_each do |cookie|
      cookie.update(storage: current_user)
    end
    redirect_to @oven, alert: 'Oven emptied!'
  end

  private

  def set_oven
    @oven = current_user.ovens.find_by!(id: params[:id])
  end
end
