module ApplicationHelper
  def body_to_html(body)
    Commonmarker.to_html(body, options: { parse: { smart: true }}).html_safe
  end
end
