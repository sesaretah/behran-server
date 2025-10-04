class V1::ShortnersController < ApplicationController
  include Authenticatable

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
    # Extract href from params before creating shortner
    href = params[:shortner][:href]
    
    # Create shortner with only URL
    @shortner = Shortner.new(url: params[:shortner][:url])
    @shortner.user_id = current_user.id
    
    if @shortner.save
      # Create item with the shortner_id and provided href
      if href.present?
        @item = @shortner.items.create!(
          title: extract_title_from_url(@shortner.url),
          description: "Shortened link for #{@shortner.url}",
          href: href
        )
      end
      
      render json: { 
        data: ShortnerSerializer.new(@shortner, scope: {user_id: current_user.id}).as_json, 
        klass: 'Shortner' 
      }, status: :created
    else
      render json: { 
        error: 'Validation failed', 
        message: 'Unable to create shortner', 
        details: @shortner.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end
  
  private
  
  def extract_title_from_url(url)
    # Extract a simple title from the URL
    uri = URI.parse(url)
    domain = uri.host || url
    domain.gsub(/^www\./, '').capitalize
  rescue
    "Shortened Link"
  end

  def update
    @shortner = Shortner.find(params[:id])
    if @shortner.update_attributes(shortner_params)
      render json: { data: ShortnerSerializer.new(@shortner, scope: {user_id: current_user.id}).as_json, klass: 'Shortner' }, status: :ok
    end
  end

  def shortner_params
    params.require(:shortner).permit(:url, :href)
  end
end
