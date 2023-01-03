class ShoppinglistsController < ApplicationController
  before_action :set_shoppinglist, only: %i[ show edit update destroy]

  # GET /shoppinglists or /shoppinglists.json
  def index
    @shoppinglists = Shoppinglist.page(params[:page]).per(5)
  end

  # GET /shoppinglists/1 or /shoppinglists/1.json
  def show
  end

  # GET /shoppinglists/new
  def new
    @shoppinglist = Shoppinglist.new
    @shoppinglist.mtype = 0
    @shoppinglist.total = 0.0
    @shoppinglist.save
    redirect_to shoppinglist_url(@shoppinglist)
  end

  # GET /shoppinglists/1/edit
  def edit
  end

  # POST /shoppinglists or /shoppinglists.json
  def create
    @shoppinglist = Shoppinglist.new(shoppinglist_params)
 
    respond_to do |format|
      if @shoppinglist.save
        format.html { redirect_to shoppinglist_url(@shoppinglist), notice: "Shoppinglist was successfully created." }
        format.json { render :show, status: :created, location: @shoppinglist }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @shoppinglist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shoppinglists/1 or /shoppinglists/1.json
  def update
    respond_to do |format|
      if @shoppinglist.update(shoppinglist_params)
        format.html { redirect_to shoppinglist_url(@shoppinglist), notice: "Shoppinglist was successfully updated." }
        format.json { render :show, status: :ok, location: @shoppinglist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @shoppinglist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shoppinglists/1 or /shoppinglists/1.json
  def destroy
    @shoppinglist.destroy

    respond_to do |format|
      format.html { redirect_to shoppinglists_url, notice: "Shoppinglist was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # POST /shoppinglists/conduct
  def conduct
    @shoppinglist = Shoppinglist.find(params[:id])
    orient = @shoppinglist.mtype == 0 ? 1 : -1;
    puts(orient)
    @shoppinglist.items.each do |item|
      refproduct = item.product
      refproduct.quantity += orient * item.quantity
      refproduct.save
    end
    @shoppinglist.destroy

    redirect_to shoppinglists_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shoppinglist
      @shoppinglist = Shoppinglist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shoppinglist_params
      params.require(:shoppinglist).permit(:mtype, :total)
    end
end
