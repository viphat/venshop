require 'uri'

module SocialButtonHelper

  def share_on_facebook
    raw <<-HTML
    <div class="fb-share-button"
      data-href='#{request.original_url}'
      data-layout="button" data-size="large"
      data-mobile-iframe="true">
      <a class="fb-xfbml-parse-ignore" target="_blank"
      href="https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Ffacebook.com%2F&amp;src=sdkpreparse">
        <i class="fa fa-facebook"></i>
      </a>
    </div>
    HTML
  end

  def share_on_twitter
    raw <<-HTML
    <a class="btn btn-social-icon btn-twitter"
      href="https://twitter.com/share?url=#{URI.encode(request.original_url)}" target='_blank'>
      <i class="fa fa-twitter"></i>
    </a>
    HTML

  end

end
