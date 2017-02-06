module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?
    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t('errors.messages.not_saved',
                      count: resource.errors.count,
                      resource: resource.class.model_name.human.downcase)
    raw render_html(sentence, messages)
  end

  private

  def render_html(sentence, messages)
    <<-HTML
    <div class="alert alert-danger">
      <a href="#" data-dismiss="alert" class="close">×</a>
      <h4>#{sentence}</h4>
      #{messages}
    </div>
    HTML
  end
end
