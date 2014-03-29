class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit,:vote, :update, :destroy]
  before_action :authenticate_user!
  before_action :check_admin!, except: [:vote]

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.order(id: :desc)
  end

  def temperatures
    respond_to do |format|
      ids = params.require('ids')
      temperatures = {}
      ids.each do |id|
        temperatures[id] = Room.find(id).cached_temperature
      end
      format.json do
        render json: temperatures
      end
    end
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
  end

  def vote
    if @room.active?
      @currentVote = CurrentVote.where({user_id: current_user.id,room_id: params.require('id')}).first
    else
      redirect_to root_path, notice: "#{@room.name} is not currently active"
    end
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: 'Room was successfully created.' }
        format.json { render action: 'show', status: :created, location: @room }
      else
        format.html { render action: 'new' }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        return_path = params.require(:room).permit(:return_path)[:return_path] || @room
        format.html { redirect_to return_path, (roomtemp_suppress_messages? ? {} : {notice: 'Room was successfully updated.'}) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:name, :user_id, :status)
    end
end
