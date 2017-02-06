module CommonHelper

  def google_analytics_event_tracking(category, action, event_label=nil, value=nil)
    '<script type="text/javascript">' +
      google_analytics_event_tracking_script(category,
                                           action,
                                          event_label,
                                          value) +
      '</script>'
  end

  def google_analytics_event_tracking_script(category, action, event_label=nil, value=nil)
    "ga('send', 'event'," +
    " '#{category}', '#{action}'" +
    (event_label.nil? ? '' : ", '#{event_label}'") +
    (value.nil? ? '' : ", '#{value}'") +
    ')'
  end

end
