class CategoriesCell < Cell::ViewModel
  include ::Cell::Erb

  def show
    @categories = Category.order(:category_name).all
    render
  end
end
