class PatternsController < ApplicationController
  before_action :set_pattern, only: %i[ show edit update destroy ]

  # GET /patterns or /patterns.json
  def index
    @patterns = Pattern.all
  end

  # GET /patterns/1 or /patterns/1.json
  def show
  end

  # GET /patterns/new
  def new
    @pattern = Pattern.new
  end

  # GET /patterns/1/edit
  def edit
  end

  # POST /patterns or /patterns.json
  def create
    @pattern = Pattern.new(pattern_params)

    respond_to do |format|
      if @pattern.save
        format.html { redirect_to @pattern, notice: "Pattern was successfully created." }
        format.json { render :show, status: :created, location: @pattern }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pattern.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /patterns/1 or /patterns/1.json
  def update
    respond_to do |format|
      if @pattern.update(pattern_params)
        format.html { redirect_to @pattern, notice: "Pattern was successfully updated." }
        format.json { render :show, status: :ok, location: @pattern }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pattern.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patterns/1 or /patterns/1.json
  def destroy
    @pattern.destroy
    respond_to do |format|
      format.html { redirect_to patterns_url, notice: "Pattern was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pattern
      @pattern = Pattern.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pattern_params
      params.require(:pattern).permit(:name, :card)
    end
end
