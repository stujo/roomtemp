class HomeController < ApplicationController
  def index
    @rooms = Room.active.order(id: :desc)
  end
end
