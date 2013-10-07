module RefreshHelper
  class Refresher
    include ActionView::Helpers::TagHelper
    include ActionView::Context

    def initialize(params)
      @interval = params[:refresh]
    end

    def meta_tag
      content_tag(:meta, nil, {
        "http-equiv" => "refresh",
        "content" => @interval,
      }) if @interval
    end

    def stats
      "Updated @ #{Time.now.utc.strftime("%m/%d/%Y %I:%M:%S%p %Z")}"
    end

    def toggle_link
      if @interval
        content_tag(:a, "Disable auto-refresh", href: "?")
      else
        content_tag(:a, "Enable auto-refresh", href: "?refresh=10")
      end
    end
  end

  def refresher
    @refresher ||= Refresher.new(params)
  end
end
