class V1::ProfilesController < ApplicationController

  def add_experties
    @profile = Profile.find(params[:id])
    @profile.experties << params[:experties]
    @profile.save
    render json: { data: ProfileSerializer.new(@profile).as_json, klass: 'Profile' }, status: :ok
  end

  def remove_experties
    @profile = Profile.find(params[:id])
    @profile.experties.delete(params[:experties])
    @profile.save
    render json: { data: ProfileSerializer.new(@profile).as_json, klass: 'Profile' }, status: :ok
  end

  def index
    if current_user.has_ability('show_profile')
      profiles = Profile.all
    else 
      profiles = Profile.where(user_id: current_user.id)
    end
    render json: { data: ActiveModel::SerializableResource.new(profiles,  each_serializer: ProfileSerializer ).as_json, klass: 'Profile' }, status: :ok
  end

  def search
    if !params[:q].blank?
      profiles = Profile.search params[:q], star: true
      render json: { data: ActiveModel::SerializableResource.new(profiles,  each_serializer: ProfileSerializer ).as_json, klass: 'Profile' }, status: :ok
    else 
      render json: { data: [], klass: 'Profile' }, status: :ok
    end
  end

  def show
    @profile = Profile.find(params[:id])
    render json: { data: ProfileShowSerializer.new(@profile, scope: {user_id: current_user.id} ).as_json,  klass: 'Profile' }, status: :ok
  end

  def my
    @profile = current_user.profile
    if @profile
      render json: { data: ProfileSerializer.new(@profile).as_json, klass: 'Profile' }, status: :ok
    else
      render json: { data: 'No profile', klass: 'Profile' }, status: :ok
    end
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.user_id = current_user.id
    if @profile.save
      render json: { data: ProfileSerializer.new(@profile).as_json, klass: 'Profile' }, status: :ok
    end
  end

  def update
    @profile = current_user.profile
    if @profile.update_attributes(profile_params)
      render json: { data: ProfileSerializer.new(@profile).as_json, klass: 'Profile' }, status: :ok
    end
  end



  def profile_params
    params.require(:profile).permit!
  end
end
