class GameSerializer < ActiveModel::Serializer
  attributes :id, :title, :starting_room, :theme, :theme_id, :user_id

  def starting_room
    object.starting_room.as_json(only: [:id, :title, :description], methods: [:connections])
  end
end
