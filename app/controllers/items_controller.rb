class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]

  def index
    # Fetch Newest Items
    page = params[:page] || 1
    @items = Item.newest.page(page).per(Item::NEWEST_ITEMS_LIMIT)
    # Authorize with Pundit
    @items.each { |item| authorize item, :index? }
  end

  def show
    @item = Item.find_by_id(params[:id])
    return render 'items/_item_not_found' if @item.nil?
    authorize @item, :show?
    @order_item = OrderItem.new(item: @item, order: current_order) unless current_user.nil?
    add_breadcrumb_for_item
  end

  def new
    @item = Item.new
    authorize @item, :create?
    add_breadcrumb_for_creating
  end

  def create
    @item = Item.new(item_params)
    authorize @item, :create?
    unless @item.save
      add_breadcrumb_for_creating
      flash[:error] = @item.errors.full_messages
      return render 'new'
    end
    flash[:success] = 'Item was created successfully.'
    add_breadcrumb_for_item
    render 'show'
  end

  def edit
    @item = Item.find(params[:id])
    authorize @item, :update?
    add_breadcrumb_for_item
  end

  def update
    @item = Item.find(params[:id])
    authorize @item, :update?
    add_breadcrumb_for_item
    unless @item.update_attributes(item_params)
      flash[:error] = @item.errors.full_messages
      return render 'edit'
    end
    flash[:success] = 'Item was updated successfully.'
    render 'show'
  end

  private

    def item_params
      params.require(:item).permit(:item_name, :category_id, :price, :description, :item_image)
    end

    def add_breadcrumb_for_creating
      add_breadcrumb('Create New Item', new_item_path)
    end

    def add_breadcrumb_for_item
      add_breadcrumb(@item.category_name, category_path(@item.category))
      add_breadcrumb("Item ID #{@item.id}", item_path(@item))
    end

end
