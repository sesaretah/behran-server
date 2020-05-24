class ItemSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :description, :href, :screencap

  def screencap
    path =  Rails.root.join('public', 'images', "item_#{object.id}.png").to_s
    if File.exists?(path)
       Rails.application.routes.default_url_options[:host] + "/images/item_#{object.id}.png"
    else
      Rails.application.routes.default_url_options[:host] + "/images/default.png"
    end
  end

  
end
