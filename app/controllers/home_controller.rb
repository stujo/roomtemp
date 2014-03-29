class HomeController < ApplicationController
  def index
    @rooms = Room.order(id: :desc)
  end
end
