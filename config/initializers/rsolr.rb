require 'rsolr'

$solr = RSolr.connect(url: ENV['RSOLR_SERVER_ADDRESS'],
                      read_timeout: 120,
                      open_timeout: 120)
