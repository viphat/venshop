class CategoriesController < ApplicationController

  ITEMS_PER_PAGE = 10

  def show
    @category = Category.find_by_id(params[:id])
    page = params[:page] || 1
    return render 'categories/_category_not_found' if @category.nil?
    @items = @category.items.newest.page(page).per(ITEMS_PER_PAGE)
    add_breadcrumb "#{@category.category_name}", category_path(@category)
  end

end
