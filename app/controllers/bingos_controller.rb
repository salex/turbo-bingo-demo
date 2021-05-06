# contollers.bingos_contoller.rb
class BingosController < ApplicationController
  before_action :set_bingo, only: %i[ show edit update]

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
    if params[:bingo][:game].present?
      @bingo.pattern = params[:bingo][:game]
    end
    if params[:bingo][:control].present?
      if params[:bingo][:control] == 'New'
        @bingo.state = ''
        @bingo.calls = []
        @bingo.status = 'current'
      else
        @bingo.state = params[:bingo][:control]
      end
    end
    @bingo.save
    render action: :edit
  end

 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bingo
      # the bingo game is always ID 1 for demo
      @bingo = Bingo.find 1
     end

    # Only allow a list of trusted parameters through.
    def game_params
      params.require(:game).permit(:status, :calls, :pattern, :state)
    end
end
