class PlayerSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :current_room
  belongs_to :game

  def current_room
    object.current_room.as_json(only: [:id, :title, :description], methods: [:connections])
  end
end
