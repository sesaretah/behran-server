class DeviceSerializer < ActiveModel::Serializer
  attributes :token
  belongs_to :user
end
