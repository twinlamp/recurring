class AddressesController < ApplicationController
  layout 'admin'
  helper_method :sort_column, :sort_direction
  before_action :set_address, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  
  def index
    update_index
    respond_to do |format|
      format.html
      format.json { render json: @address.to_json }
    end
  end
  
  def new
    @address = Address.new
    @address.account_id = params[:account_id]
  end
  
  def create
    @address = Address.create(address_params)
    @account = @address.account
    update_index
  end
  
  def show
  end
  
  def edit
  end
    
  def update
    @address.update_attributes(address_params)
    @account = @address.account
    update_index
  end

  def destroy
    @account = @address.account
    @address.destroy!
  end
  
  private

  def set_address
    @address = Address.find(params[:id])
  end

  def update_index
    @addresses = Address.order(sort_column + " " + sort_direction)
    unless params[:term].blank?
      @addresses = @addresses.lookup(params[:term]) if params[:term].present?
    end
    @addresses = @addresses.paginate(:page => params[:page], :per_page => 25)
  end

  def address_params
    params.require(:address).permit(:name, :address_1, :address_2, :city, :state, :zip, :phone, :fax, :main, :account_id, :account_name)
  end

  def sort_column
    Address.column_names.include?(params[:sort]) ? params[:sort] : "addresses.name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end