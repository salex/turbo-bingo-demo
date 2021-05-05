# contollers.bingos_contoller.rb
class BingosController < ApplicationController
  before_action :set_bingo, only: %i[ show edit update caller viewer]

  def show
  end

  def edit
  end

  def update
    if params[:bingo][:calls].present?
      add,call = params[:bingo][:calls].split
      if add == 'add'
        @bingo.calls.unshift(call)
      else
        @bingo.calls.delete(call)
      end
    end
    if params[:bingo][:control].present?
      @bingo.state = params[:bingo][:control]
    end
    @bingo.save
    render action: :edit
  end

 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bingo
      @bingo = Bingo.current
      # dev klude ot get curr
      if @bingo.blank?
        @bingo = Bingo.last
        @bingo.state = 'current'
      end
    end

    # Only allow a list of trusted parameters through.
    def game_params
      params.require(:game).permit(:status, :calls, :pattern, :state)
    end
end
