class ConvertersController < ApplicationController
  def base64
  end

  def html2haml
    render json: {haml: convert_html_to_haml} if request.post?
  end

  private

  def convert_html_to_haml
    Html2haml::HTML.new(params[:html]).render
  rescue
    ""
  end
end
