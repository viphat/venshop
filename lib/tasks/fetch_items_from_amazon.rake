require_relative '../amazon_products_crawler.rb'

namespace :amazon_products_api do

  desc 'Fetch & Import Items from Amazon Product API'
  task fetch_and_import_items: :environment do
    # Init Vacuum
    request = Vacuum.new
    request.configure(
      aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      associate_tag: ENV['ASSOCIATE_TAG']
    )
    AmazonProductsCrawler.new(request).crawl!
  end

end
