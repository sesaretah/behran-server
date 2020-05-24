class ShortnerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :url, :the_items, :editable

  def the_items
    if scope && scope[:user_id]
      ActiveModel::SerializableResource.new(object.items,  each_serializer: ItemSerializer, scope: {user_id: scope[:user_id]} ).as_json
    else 
      ActiveModel::SerializableResource.new(object.items,  each_serializer: ItemSerializer).as_json
    end
  end

  def editable
    if scope && scope[:user_id]
      if object.user_id == scope[:user_id] 
         true 
      else
         false
      end 
    end
  end
end
