module ApplicationHelper
  def body_to_html(body)
    Commonmarker.to_html(body,
      options: {
        parse: {
          smart: true
        }
      },
      plugins: {
        syntax_highlighter: {theme: "onedark", path: Rails.root.join("vendor/highlight-themes").to_s}
      }).html_safe
  end
end
