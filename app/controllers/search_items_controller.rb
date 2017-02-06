class SearchItemsController < ApplicationController
  def index
    @page = params[:page] || 1
    return flash[:error] = 'You must input a keyword to find items' if params[:keyword].blank?
    response = search
    paginate(response)
  end

  private

  def paginate(response)
    total_count = response['numFound']
    item_ids = response['docs'].map { |x| x['id'] }
    @items = Item.where(id: item_ids)
    @items = Kaminari.paginate_array(@items.to_a, total_count: total_count).page(params[:page]).per(10)
  end

  def search
    response = $solr.paginate(@page, Item::SEARCH_ITEMS_LIMIT, 'select',
                              params: { q: params[:keyword] })
    response['response']
  end
end
