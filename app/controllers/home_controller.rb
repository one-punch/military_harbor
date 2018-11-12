class HomeController < ApplicationController

  def index
    @categories = Category.roots.actived.select { |category| category.pictures.any? }
    @products = Product.limit 12
  end

  def about
    if content_names.include? params[:name]
      @content = get_centent params[:name]
    else
      @url = "#{Picture::BASE_URL}/#{Picture::NAMES[params[:name]]}.jpg"
    end
  end

  private

  def content_names
    %w(shipping)
  end

  def url_names
    %w(payment tunic)
  end

  def get_centent name
    {
      'shipping' => ["When your order status change to 'Accepted'. We will send out your parcel in time.",
                     "U.S.A. will take about 10-15 working days arrived.",
                     "Europe will take about 15-20 working days.",
                     "Australia & Asia will take about 5-10 working days.",
                     "Canada, Russia & Middle east will take about 15-20 working days.",
                     "Latin America will take about 20-35 working days.",
                     "If your country/region didn't show on above, I'll tell you the correct date, postage, and service when you send order to me.",
                     "In some countries/regions, the custom will charge you some import duty. That is what you need to do. If you want to return the parcel that you don’t want to pay the custom duty, we won’t accept that.",
                     "After shipped out, you will get the tracking information by automatic email."]
    }[name]
  end
end
