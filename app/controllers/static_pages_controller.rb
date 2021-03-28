class StaticPagesController < ApplicationController
  def home
    @carousel_images = Dir.glob('app/assets/images/carousel/*.{gif,jpg,png,jpeg}')
  end
end
