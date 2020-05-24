class V1::ItemsController < ApplicationController

  def index
    items = Item.all.order('url ASC')
    render json: { data: ActiveModel::SerializableResource.new(items,  each_serializer: ItemSerializer , scope: {user_id: current_user.id}).as_json, klass: 'Item' }, status: :ok
  end

  def search
    if !params[:q].blank?
      items = Item.search params[:q], star: true
      render json: { data: ActiveModel::SerializableResource.new(items,  each_serializer: ItemSerializer ).as_json, klass: 'Item' }, status: :ok
    else 
      render json: { data: [], klass: 'Item' }, status: :ok
    end
  end
  

  def show
    @item = Item.find(params[:id])
    render json: { data: ItemSerializer.new(@item, scope: {user_id: current_user.id}).as_json,  klass: 'Item' }, status: :ok
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      render json: { data: ShortnerSerializer.new(@item.shortner, scope: {user_id: current_user.id}).as_json, klass: 'Shortner' }, status: :ok
    end
  end

  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(item_params)
      render json: { data: ItemSerializer.new(@item, scope: {user_id: current_user.id}).as_json, klass: 'Item' }, status: :ok
    end
  end


  def item_params
    params.require(:item).permit!
  end
end
