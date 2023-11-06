class ConvertersController < ApplicationController
  def base64; end

  def html2haml
    if request.post?
      haml = Html2haml::HTML.new(params[:html]).render rescue ""
      render json: { haml: haml }
    end
  end
end
