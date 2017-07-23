defmodule Dbs.RoomView do
  use Dbs.Web, :view

  alias Dbs.DateTimeHelpers

  def render("room.json", %{room: room}) do
    %{
      id: room.id, 
      name: room.name, 
      players: [room.player1.name, room.player2.name],
      created_at: DateTimeHelpers.from_iso8601_to_unix(room.inserted_at)
    }
  end
end
