namespace :amazon_products_api do

  def create_categories
    ######
    # From the List of all available search indices by US locale in Amazon Product API,
    # We have chosen 5 categories. Those are Books, Magazines, VideoGames, MobileApps, Software
    ######
    categories = %w(Books Movies Video\ Games Mobile\ Apps Software)

    categories.each do |category|
      Category.find_or_create_by!(category_name: category)
    end
  end

  def create_item_from_hashed_item(hashed_item, category)
    item = Item.find_or_initialize_by(category_id: category.id, item_name: hashed_item['ItemAttributes']['Title'])
    item.price = hashed_item['ItemAttributes']['ListPrice']['Amount'].to_i / 100 unless hashed_item['ItemAttributes']['ListPrice'].nil?
    item.asin = hashed_item['ASIN']
    item.set_item_image_from_url(hashed_item['LargeImage']['URL']) unless hashed_item['LargeImage'].nil?
    item.save!
  end

  def import_items_by_category(request, category, item_page:)
    max_of_retries = 5
    num_of_retries = 0
    retries = true

    until (!retries || num_of_retries >= max_of_retries)
      retries = false
      begin
        # Pause the current thread
        sleep(5 * num_of_retries)

        response = request.item_search(
          query: {
            'SearchIndex' => category.category_name.gsub(' ',''),
            'ResponseGroup' => 'ItemAttributes,Images',
            'ItemPage' => item_page,
            'BrowseNode' => 1,
            'MinimumPrice'=> 1 # Minimum Price is $1.00
          }
        )

        response.to_h['ItemSearchResponse']['Items']['Item'].each do |hashed_item|
          create_item_from_hashed_item(hashed_item, category)
        end

      rescue Excon::Error::ServiceUnavailable
        retries = true
        puts "Failed ##{num_of_retries + 1}"
      end
      num_of_retries += 1
    end

  end

  desc 'Fetch & Import Items from Amazon Product API'
  task fetch_and_import_items: :environment do
    # Init Vacuum
    request = Vacuum.new
    request.configure(
      aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      associate_tag: ENV['ASSOCIATE_TAG']
    )

    # Fetch & Import some Categories (Pre-defined)
    create_categories

    # Fetch & Import 20 items each Category
    Category.all.find_each do |category|
      # Each time, Amazon API returns only 10 items, so we need to run it twice
      import_items_by_category(request, category, item_page: 1)
      sleep(5) # pause the current thread for avoid Amazon Api error 503
      import_items_by_category(request, category, item_page: 2)
      sleep(5) # pause the current thread for avoid Amazon Api error 503
    end
  end

end