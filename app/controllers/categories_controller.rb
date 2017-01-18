class CategoriesController < ApplicationController

  def show
    @category = Category.find_by_id(params[:id])
    page = params[:page] || 1
    return render 'categories/_category_not_found' if @category.nil?
    @items = @category.items.newest.page(page).per(Category::ITEMS_LIMIT)
    add_breadcrumb @category.category_name, category_path(@category)
  end

end
