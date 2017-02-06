require 'rsolr'

$solr = RSolr.connect(:url => 'http://localhost:8983/solr/venshop',:read_timeout => 120, :open_timeout => 120)
