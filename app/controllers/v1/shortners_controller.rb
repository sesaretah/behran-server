class V1::ShortnersController < ApplicationController

  def index
    shortners = Shortner.all.order('url ASC')
    render json: { data: ActiveModel::SerializableResource.new(shortners,  each_serializer: ShortnerSerializer , scope: {user_id: current_user.id}).as_json, klass: 'Shortner' }, status: :ok
  end

  def search
    if !params[:q].blank?
      shortners = Shortner.search params[:q], star: true
      shortners = Shortner.filter_unconfirmed(shortners)
      render json: { data: ActiveModel::SerializableResource.new(shortners,  each_serializer: ShortnerSerializer ).as_json, klass: 'Shortner' }, status: :ok
    else 
      render json: { data: [], klass: 'Shortner' }, status: :ok
    end
  end
  

  def show
    @shortner = Shortner.find(params[:id])
    if !current_user.blank?
      render json: { data: ShortnerSerializer.new(@shortner, scope: {user_id: current_user.id}).as_json,  klass: 'Shortner' }, status: :ok
    else
      render json: { data: ShortnerSerializer.new(@shortner).as_json,  klass: 'Shortner' }, status: :ok
    end
  end

  def create
    @shortner = Shortner.new(shortner_params)
    @shortner.user_id = current_user.id
    if @shortner.save
      render json: { data: ShortnerSerializer.new(@shortner, scope: {user_id: current_user.id}).as_json, klass: 'Shortner' }, status: :ok
    end
  end

  def update
    @shortner = Shortner.find(params[:id])
    if @shortner.update_attributes(shortner_params)
      render json: { data: ShortnerSerializer.new(@shortner, scope: {user_id: current_user.id}).as_json, klass: 'Shortner' }, status: :ok
    end
  end


  def shortner_params
    params.require(:shortner).permit!
  end
end
