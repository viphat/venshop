class CategoryCell < Cell::ViewModel
  include ::Cell::Erb

  def show
    render
  end

  private

    def category_link
      # It may be a bug of Cell-rails 0.6.0
      # Calling categoty_path will cause an exception.
      # link_to model.category_name, category_path(model)
      link_to model.category_name, "/categories/#{model.id}"
    end

end
