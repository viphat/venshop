module CommonHelper
  def format_date(timestamp)
    timestamp.nil? ? '' : timestamp.strftime('%d/%m/%Y')
  end
end
